//
//  CAController.mm
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "CAController.h"
#import "FXLibrary.h"

#define scale 0.00002267573696

////////////////////////////////////////////////////////////
const		Float64		sampleRate = 44100.0;
float*		bufferL;
float*		bufferR;
float*		j = new float [2];
float*		render_output = new float [2];

bool		playback;	//	YES if noise is desired
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////


//	Trigger arrays
float*	w_triggers	= new float [30];
float*	x_triggers	= new float [30];
float*	y_triggers	= new float [30];
float*	z_triggers	= new float [30];

//	MAXI OBJECT DECLARATION

maxiOsc		metro;
int			metroCount;
double		metroOut;
double		metroSpeed;


//	Sample Players
maxiSample	sample_w,
			sample_x,
			sample_y,
			sample_z;


//	Sample output vols
double	w_vol, x_vol, y_vol, z_vol;


//	Sample output variables
double	w_out, x_out, y_out, z_out;


//	Sample sustain vals
double	w_sus, x_sus, y_sus, z_sus;		//	sustain = (1/44100) / sustain value in seconds

//	Sample play speeds
double	w_speed, x_speed, y_speed, z_speed;


/*
NSArray		*parameters	 = [NSArray arrayWithObjects: 
							points_w, points_x, points_y, points_z,
							NSNumCurves_w, NSNumCurves_x, NSNumCurves_y, NSNumCurves_z,								
							NSNumCurves, NSNumShapes, NSNumPoints,
							NSAlphaAverage, NSAlphaTotal,
							NSTotalR, NSTotalG, NSTotalB,
							nil];
*/

//	Local curves
int curves_w, curves_x, curves_y, curves_z;

//	Local points
int	points_w, points_x, points_y, points_z;

//	Globals
//	…shape
int		globalNumCurves;
int		globalNumShapes;
int		globalNumPoints;

double	globalShapeSizeAverage;
double	globalShapeSizeTotal;

//	…color
double	globalAlphaAverage;
double	globalAlphaTotal;
double	globalColorTotalR;
double	globalColorTotalG;
double	globalColorTotalB;





////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void initLocalVariables	(void)	{	
	//	Create trigger buffers
	
	memset(w_triggers,	0, sizeof(float)*16);
	memset(x_triggers,	0, sizeof(float)*16);
	memset(y_triggers,	0, sizeof(float)*16);
	memset(z_triggers,	0, sizeof(float)*16);	
}

inline void maxiSetup		(void)	{
	initLocalVariables();
	
	//	Load samples
	sample_w.load([[[NSBundle mainBundle] pathForResource:@"piano_odd_4"	ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	sample_x.load([[[NSBundle mainBundle] pathForResource:@"evp_odd_3" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	sample_y.load([[[NSBundle mainBundle] pathForResource:@"12st_5ths_2" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	sample_z.load([[[NSBundle mainBundle] pathForResource:@"electric_1" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);	
	
	//	Metronome setup
	metroSpeed	= 2.0f;
	metroOut	= 0.0f;
	metroCount	= 0;
	
	//	Sample outputs
	w_out = x_out = y_out = z_out = 0.0f;
	
	//	Sustain values
	w_sus = x_sus = y_sus = z_sus = 3.5f;	//	value in seconds
	
	//	Speeds
	w_speed = x_speed = y_speed = z_speed = 1.0f;
	
	//	Incoming params
	globalNumCurves		= 0;
	globalNumShapes		= 0;
	globalNumPoints		= 0;
	globalAlphaAverage	= 0;
	globalAlphaTotal	= 0;
	globalColorTotalR	= 0;
	globalColorTotalG	= 0;
	globalColorTotalB	= 0;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void readTriggers	(int i)	{	
	if (w_triggers[i]>=0.01f)	{
		w_vol = 1.0f;
		sample_w.trigger();
	}

	if (x_triggers[i]>=0.01f)	{
		x_vol = 1.0f;		
		sample_x.trigger();		
	}

	if (y_triggers[i]>=0.01f)	{
		sample_y.trigger();
		y_vol = 1.0f;
	}
	
	if (z_triggers[i]>=0.01f)	{
		sample_z.trigger();
		z_vol =	1.0f;
	}
}

inline void sustain	()	{
	if (w_vol>0.0f)
		w_vol-=(scale/w_sus);	//	Reduce volume by sustained amount
	if (x_vol>0.0f)
		x_vol-=(scale/x_sus);	//	Reduce volume by sustained amount
	if (y_vol>0.0f)
		y_vol-=(scale*y_sus);	//	Reduce volume by sustained amount
	if (z_vol>0.0f)
		z_vol-=(scale*z_sus);	//	Reduce volume by sustained amount
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

FXBitcrusher	bitcrusher_1,	bitcrusher_2,	bitcrusher_3,	bitcrusher_4;
FXDistortion	dist_1,			dist_2,			dist_3,			dist_4;
FXFlanger		fxflanger_1,	fxflanger_2,	fxflanger_3,	fxflanger_4;
FXTremolo		tremolo_1,		tremolo_2,		tremolo_3,		tremolo_4;
FXDelay			delay_1,		delay_2,		delay_3,		delay_4;
FXFilter		filter_1,		filter_2,		filter_3,		filter_4;


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

double	w_bitcrushAmount	= 0.1;

double	w_distortionAmount	= 0.2;
double	w_distortionMix		= 0.3;

double	w_flangeAmount		= 0.4;
double	w_flangeMix			= 0.5;

double	w_tremoloAmount		= 0.6;
double	w_tremoloMix		= 0.7;

double	w_delayAmount		= 0.8;
double	w_delayMix			= 0.9;

inline double voice_w()	{
	double output = .0f;

	output = w_vol*sample_w.playOnce(w_speed);

//	output = bitcrusher_1.	bitcrusher	(output, w_bitcrushAmount);
//	output = dist_1.		distortion	(output, w_distortionAmount,	w_distortionMix);
//	output = fxflanger_1.	flange		(output, w_flangeAmount,		w_flangeMix);
	output = tremolo_1.		tremolo		(output, w_tremoloAmount,		w_tremoloMix);
//	output = delay_1.		delay		(output, w_delayAmount,			w_delayMix);
//	output	filter
	
	return output*w_vol;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

double	x_bitcrushAmount	= 0.9;

double	x_distortionAmount	= 0.8;
double	x_distortionMix		= 0.7;

double	x_flangeAmount		= 0.6;
double	x_flangeMix			= 0.5;

double	x_tremoloAmount		= 0.4;
double	x_tremoloMix		= 0.3;

double	x_delayAmount		= 0.2;
double	x_delayMix			= 0.1;

inline double voice_x()	{
	double output = .0f;

	output = x_vol*sample_x.playOnce(x_speed);
	
	output = bitcrusher_2.	bitcrusher	(output, x_bitcrushAmount);
//	output = dist_2.		distortion	(output, x_distortionAmount,	x_distortionMix);
//	output = fxflanger_2.	flange		(output, x_flangeAmount,		x_flangeMix);
	output = tremolo_2.		tremolo		(output, x_tremoloAmount,		x_tremoloMix);
//	output = delay_2.		delay		(output, x_delayAmount,			x_delayMix);
	//	output	filter
	
	return output*x_vol;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

double	y_bitcrushAmount	= 0.1;

double	y_distortionAmount	= 0.9;
double	y_distortionMix		= 0.2;

double	y_flangeAmount		= 0.8;
double	y_flangeMix			= 0.3;

double	y_tremoloAmount		= 0.7;
double	y_tremoloMix		= 0.4;

double	y_delayAmount		= 0.6;
double	y_delayMix			= 0.1;

inline double voice_y()	{
	double output = .0f;
	
	output = y_vol*sample_y.playOnce(y_speed);
	
//	output = bitcrusher_3.	bitcrusher	(output, y_bitcrushAmount);
//	output = dist_3.		distortion	(output, y_distortionAmount,	y_distortionMix);
//	output = fxflanger_3.	flange		(output, y_flangeAmount,		y_flangeMix);
	output = tremolo_3.		tremolo		(output, y_tremoloAmount,		y_tremoloMix);
//	output = delay_3.		delay		(output, y_delayAmount,			y_delayMix);
	//	output	filter
	
	return output;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

double	z_bitcrushAmount	= 0.4;

double	z_distortionAmount	= 0.6;
double	z_distortionMix		= 0.3;

double	z_flangeAmount		= 0.7;
double	z_flangeMix			= 0.1;

double	z_tremoloAmount		= 0.9;
double	z_tremoloMix		= 0.2;

double	z_delayAmount		= 0.8;
double	z_delayMix			= 0.5;

inline double voice_z()	{
	double output = .0f;
	
	output = z_vol*sample_z.playOnce(z_speed);
	
//	output = bitcrusher_4.	bitcrusher	(output, z_bitcrushAmount);
//	output = dist_4.		distortion	(output, z_distortionAmount,	z_distortionMix);
//	output = fxflanger_4.	flange		(output, z_flangeAmount,		z_flangeMix);
	output = tremolo_4.		tremolo		(output, z_tremoloAmount,		z_tremoloMix);
//	output = delay_4.		delay		(output, z_delayAmount,			z_delayMix);
	//	output	filter
	
	return output;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark USER RENDERING METHOD
float*	output	()	{
    render_output[0] = render_output[1] = w_out = x_out = y_out = z_out = 0.0f;
	
	sustain();
	
	if ((int)metro.phasor(metroSpeed)>=1)	{
		metroCount++;
		if (metroCount>15)
			metroCount = 0;
		readTriggers(metroCount);
	}

	w_out = voice_w();
	x_out = voice_x();
	y_out = voice_y();
	z_out = voice_z();

	render_output	[0] = .25f*(w_out + x_out + y_out + z_out);
	render_output	[1] = .25f*(w_out + x_out + y_out + z_out);
	
    return render_output;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

OSStatus renderAudioOutput  (
							 void *inRefCon,
							 AudioUnitRenderActionFlags *ioActionFlags,
							 const AudioTimeStamp *inTimeStamp,
							 UInt32 inBusNumber, 
							 UInt32 inNumberFrames,
							 AudioBufferList *ioData)
{
	const int l = 0;
    bufferL = (Float32*)ioData->mBuffers[l].mData;
	bufferR = (Float32*)ioData->mBuffers[l+1].mData;
    for (UInt32 i = 0; i < inNumberFrames; i++) {
		if (playback)	{
			j = output();
		}
		bufferL[i]  =   j[0];
		bufferR[i]	=	j[1];
    }
    return noErr;
}

////////////////////////////////////////////////////////////

@implementation CAController

////////////////////////////////////////////////////////////

-(void)updatedParameters:(NSArray*)parameters	{
	initLocalVariables();
	
	/*
		Points and triggers
	 */
	NSArray*	NSPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	NSArray*	NSPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	NSArray*	NSPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	NSArray*	NSPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
	
	for (NSPoint* p in NSPoints_w)	{
		p.x = p.x*0.03f;
		w_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in NSPoints_x)	{
		p.x = p.x*0.03f;		
		x_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in NSPoints_y)	{
		p.x = p.x*0.03f;		
		y_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in NSPoints_z)	{
		p.x = p.x*0.03f;		
		z_triggers[(int)p.x] = 1.0f;
	}

	/*
		Local curve totals
	 */
	curves_w =	[[parameters objectAtIndex:4]intValue];
	curves_x =	[[parameters objectAtIndex:5]intValue];
	curves_y =	[[parameters objectAtIndex:6]intValue];
	curves_z =	[[parameters objectAtIndex:7]intValue];

	/*
		Local point totals
	*/
	points_w =	[NSPoints_w count];
	points_x =	[NSPoints_x count];
	points_y =	[NSPoints_y count];
	points_z =	[NSPoints_z count];
	 
	/*
	 Global totals
	 */
	
	//	Shape stats
	globalNumCurves		= [[parameters objectAtIndex:8]intValue];
	globalNumShapes		= [[parameters objectAtIndex:9]intValue];
	globalNumPoints		= [[parameters objectAtIndex:10]intValue];
	
	//	Color info
	globalAlphaAverage	= [[parameters objectAtIndex:11]doubleValue];
	globalAlphaTotal	= [[parameters objectAtIndex:12]doubleValue];
	globalColorTotalR	= [[parameters objectAtIndex:13]doubleValue];
	globalColorTotalG	= [[parameters objectAtIndex:14]doubleValue];
	globalColorTotalB	= [[parameters objectAtIndex:15]doubleValue];
		
	//	Size info
	globalShapeSizeAverage	= [[parameters objectAtIndex:16] doubleValue];
	globalShapeSizeTotal	= [[parameters objectAtIndex:17] doubleValue];	
	
	/*
		Set some local variables
	 */
	metroSpeed = 0.25 * (globalNumShapes*globalAlphaAverage);		//	Lots of bolder shapes = faster playback.
																	//	up to 0.25 * 12 (3Hz)

	
	
	
	
	NSLog(@"\n\n\n\n");	
	
	NSLog(@"Num curves: %i",	globalNumCurves);
	NSLog(@"Num shapes: %i",	globalNumShapes);
	NSLog(@"Num points: %i",	globalNumPoints);
	
	NSLog(@"Alpha average: %f", globalAlphaAverage);
	NSLog(@"Alpha total: %f",	globalAlphaTotal);
	NSLog(@"R total: %f",		globalColorTotalR);
	NSLog(@"G total: %f",		globalColorTotalG);
	NSLog(@"B total: %f",		globalColorTotalB);
	
	NSLog(@"W curves: %i",		curves_w);
	NSLog(@"X curves: %i",		curves_x);
	NSLog(@"Y curves: %i",		curves_y);
	NSLog(@"Z curves: %i",		curves_z);
	
	NSLog(@"W points: %i",		points_w);
	NSLog(@"X points: %i",		points_x);
	NSLog(@"Y points: %i",		points_y);
	NSLog(@"Z points: %i",		points_z);
	
	NSLog(@"Average size:	%f",		globalShapeSizeAverage);
	NSLog(@"Total size:		%f",		globalShapeSizeTotal);
	
	NSLog(@"\n\n\n\n");
	
	w_speed = globalAlphaAverage;
	x_speed = globalAlphaAverage*globalColorTotalR;
	y_speed = globalAlphaAverage*globalColorTotalG;
	z_speed = globalAlphaAverage*globalColorTotalB;
}


////////////////////////////////////////////////////////////

-(void)initAudioController	{
	AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType          =   kAudioUnitType_Output;
    defaultOutputDescription.componentSubType       =   kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer  =   kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags         =   0;
    defaultOutputDescription.componentFlagsMask     =   0;
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	
    OSErr err = AudioComponentInstanceNew(defaultOutput, &outputUnit);
    
    AURenderCallbackStruct renderCallbackStruct;
    renderCallbackStruct.inputProc          = &renderAudioOutput;
    renderCallbackStruct.inputProcRefCon    = (__bridge void*) self;
    
    err = AudioUnitSetProperty(outputUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &renderCallbackStruct, sizeof(renderCallbackStruct));
    
    const int four_bytes_per_float      =   4;
    const int eight_bytes_per_float     =   8;
    
    AudioStreamBasicDescription format;
    format.mSampleRate      =   sampleRate;
    format.mFormatID        =   kAudioFormatLinearPCM;
    format.mFormatFlags     =   kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    format.mBytesPerPacket  =   four_bytes_per_float;
    format.mFramesPerPacket =   2;	
    format.mBytesPerFrame   =   four_bytes_per_float;
	format.mChannelsPerFrame=   2;
    format.mBitsPerChannel  =   (four_bytes_per_float * eight_bytes_per_float)*2;
    err = AudioUnitSetProperty(outputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &format, sizeof(format));
}

////////////////////////////////////////////////////////////

-(void)startAudioUnit   {
	maxiSetup();
    OSErr   err = AudioUnitInitialize   (outputUnit);
			err	= AudioOutputUnitStart  (outputUnit);
    playback = false;
}

////////////////////////////////////////////////////////////

-(void)togglePlayback	{
	playback=!playback;
}

////////////////////////////////////////////////////////////

-(void)closeAudioUnit	{
	playback = false;
	OSErr	err = AudioOutputUnitStop	(outputUnit);
			err = AudioUnitUninitialize	(outputUnit);
	NSLog(@"Audio unit closed");
}

@end