//
//  CAController.mm
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "CAController.h"
#import "FXLibrary.h"

////////////////////////////////////////////////////////////
const		Float64		sampleRate = 44100.0;
float*		bufferL;
float*		bufferR;
float*		j = new float [2];
float*		render_output = new float [2];

bool		playback;	//	YES if noise is desired
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

float*	w_triggers	= new float [30];
//float*	w_pitches	= new float [480];

float*	x_triggers	= new float [30];
//float*	x_pitches	= new float [480];

float*	y_triggers	= new float [30];
//float*	y_pitches	= new float [480];

float*	z_triggers	= new float [30];
//float*	z_pitches	= new float [480];

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
double		w_vol, x_vol, y_vol, z_vol;

//	Sample sustain vals
double		w_sus, x_sus, y_sus, z_sus;



////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void initLocalVariables	(void)	{	
	memset(w_triggers,	0, sizeof(float)*16);
	memset(x_triggers,	0, sizeof(float)*16);
	memset(y_triggers,	0, sizeof(float)*16);
	memset(z_triggers,	0, sizeof(float)*16);	
}

//	MAXI SETUP

double w_out, x_out, y_out, z_out;

inline void maxiSetup		(void)	{
	initLocalVariables();
	
	//	Load samples
	sample_w.load([[[NSBundle mainBundle] pathForResource:@"piano_4" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	sample_x.load([[[NSBundle mainBundle] pathForResource:@"evp_5ths_3" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	sample_y.load([[[NSBundle mainBundle] pathForResource:@"12st_odd_2" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	sample_z.load([[[NSBundle mainBundle] pathForResource:@"electric_1" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);	
	
	
	metroSpeed	= 2.0f;
	metroOut	= 0.0f;
	metroCount	= 0;

	
	//	Sample outputs
	w_out = x_out = y_out = z_out = 0.0f;
	
	//	Sustain values
	w_sus = x_sus = y_sus = z_sus = .005f;	//	slower decay .004 is the minimum decay
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

float	trigger_index = 0;
float	triggerIncrement = 0.0018;

inline void readTriggers	(int i)	{	
	if (w_triggers[i]>=0.01f)	{
		w_vol = 1.0f;
		sample_w.trigger();
		NSLog(@"W");
	}

	if (x_triggers[i]>=0.01f)	{
		x_vol = 1.0f;		
		sample_x.trigger();		
		NSLog(@"X");
	}

	if (y_triggers[i]>=0.01f)	{
		sample_y.trigger();
		y_vol = 1.0f;
		NSLog(@"Y");	
	}
	
	if (z_triggers[i]>=0.01f)	{
		sample_z.trigger();
		z_vol =	1.0f;
		NSLog(@"Z");
	}
}

inline void sustain	()	{
	if (w_vol>0.0f)
		w_vol-=(0.0009*w_sus);	//	Reduce volume by sustained amount
	if (x_vol>0.0f)
		x_vol-=(0.0009*x_sus);	//	Reduce volume by sustained amount
	if (y_vol>0.0f)
		y_vol-=(0.0009*y_sus);	//	Reduce volume by sustained amount
	if (z_vol>0.0f)
		z_vol-=(0.0009*z_sus);	//	Reduce volume by sustained amount
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

FXDistortion	dist_1,			dist_2,			dist_3,			dist_4;
FXFlanger		fxflanger_1,	fxflanger_2,	fxflanger_3,	fxflanger_4;
FXTremolo		tremolo_1,		tremolo_2,		tremolo_3,		tremolo_4;
FXDelay			delay_1,		delay_2,		delay_3,		delay_4;
FXFilter		filter_1,		filter_2,		filter_3,		filter_4;
FXBitcrusher	bitcrusher_1,	bitcrusher_2,	bitcrusher_3,	bitcrusher_4;

//NSArray		*parameters	 = [NSArray arrayWithObjects: 
//							points_w, points_x, points_y, points_z,		// trigger arrays
//							NSNumCurves, NSNumShapes,					
//							NSAlphaAverage, NSAlphaTotal,
//							NSNumCurves_w, NSNumCurves_x, NSNumCurves_y, NSNumCurves_z,
//							NSTotalR, NSTotalG, NSTotalB,
//							nil];


inline double voice_w()	{
	double output = .0f;

	output = w_vol*sample_w.playOnce();
	
	output = fxflanger_1.flange(output, 0.5, 0.5);
	
	return output*w_vol;
}

inline double voice_x()	{
	double output = .0f;

	output = x_vol*sample_x.playOnce();
	
	output = delay_2.delay(output, 0.8, 0.8);
	
	return output*x_vol;
}

inline double voice_y()	{
	double output = .0f;
	
	output = y_vol*sample_y.playOnce();
	
	output = tremolo_3.tremolo(output, 0.5, 0.5);
	
	return output;
}

inline double voice_z()	{
	double output = .0f;
	
	output = z_vol*sample_z.playOnce();
	
	output = bitcrusher_4.bitcrusher(output, 0.5);
	
	output = dist_4.distortion(output, 0.5, 0.2);
	
	return output;
}



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
	
	NSArray*	points_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	NSArray*	points_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	NSArray*	points_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	NSArray*	points_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
	
	for (NSPoint* p in points_w)	{
		p.x = p.x*0.03f;
//		w_pitches[(int)p.x] = (int)floorf((80.0f-p.y)/8);
		w_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_x)	{
		p.x = p.x*0.03f;		
//		x_pitches[(int)p.x] = (int)floorf((160.0f-p.y)/8);
		x_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_y)	{
		p.x = p.x*0.03f;		
//		y_pitches[(int)p.x] = (int)floorf((240.0f-p.y)/8);
		y_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_z)	{
		p.x = p.x*0.03f;		
//		z_pitches[(int)p.x] = (int)floorf((320.0f-p.y)/8);
		z_triggers[(int)p.x] = 1.0f;
	}
	
	
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