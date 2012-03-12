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

NSArray*	starPoints_w;
NSArray*	starPoints_x;
NSArray*	starPoints_y;
NSArray*	starPoints_z;	

NSArray*	triPoints_w;	
NSArray*	triPoints_x;
NSArray*	triPoints_y;
NSArray*	triPoints_z;

NSArray*	quadPoints_w;
NSArray*	quadPoints_x;
NSArray*	quadPoints_y;
NSArray*	quadPoints_z;

//	MAX OBJECT DECLARATION

#pragma mark METRONOME
maxiOsc		metro;
int			metroCount;
double		metroOut;
double		metroSpeed;

/*
NSArray		*parameters	 = [NSArray arrayWithObjects: 
							points_w, points_x, points_y, points_z,
							NSNumCurves_w, NSNumCurves_x, NSNumCurves_y, NSNumCurves_z,								
							NSNumCurves, NSNumShapes, NSNumPoints,
							NSAlphaAverage, NSAlphaTotal,
							NSTotalR, NSTotalG, NSTotalB,
							nil];
*/

#pragma mark PARAMETERS
//	Local curves
int curves_w, curves_x, curves_y, curves_z;

//	Local points

//	STAR
int	starPoints_w_Total, starPoints_x_Total, starPoints_y_Total, starPoints_z_Total;

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

//	SAMPLE PLAYERS
//	QUAD
maxiSample quad_w;
maxiSample quad_x;
maxiSample quad_y;
maxiSample quad_z;

double	quad_w_out, quad_x_out, quad_y_out, quad_z_out;
double	quad_w_vol, quad_x_vol, quad_y_vol, quad_z_vol;

double	quadOut;

//	STAR
maxiSample star_w;
maxiSample star_x;
maxiSample star_y;
maxiSample star_z;

double	star_w_out, star_x_out, star_y_out, star_z_out;
double	star_w_vol, star_x_vol, star_y_vol, star_z_vol;

double	starOut;


//	TRI
maxiSample tri_w;
maxiSample tri_x;
maxiSample tri_y;
maxiSample tri_z;

double	tri_w_out, tri_x_out, tri_y_out, tri_z_out;
double	tri_w_vol, tri_x_vol, tri_y_vol, tri_z_vol;

double	triOut;


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void initLocalVariables	(void)	{	
	starPoints_w = [[NSArray alloc] init];
	starPoints_x = [[NSArray alloc] init];
	starPoints_y = [[NSArray alloc] init];
	starPoints_z = [[NSArray alloc] init];	
	
	triPoints_w  = [[NSArray alloc] init];
	triPoints_x  = [[NSArray alloc] init];
	triPoints_y  = [[NSArray alloc] init];
	triPoints_z	 = [[NSArray alloc] init];
	
	quadPoints_w = [[NSArray alloc] init];
	quadPoints_x = [[NSArray alloc] init];
	quadPoints_y = [[NSArray alloc] init];
	quadPoints_z = [[NSArray alloc] init];	
}

inline void maxiSetup		(void)	{
	initLocalVariables();
	
	//	Metronome setup
	metroSpeed	= 2.0f;
	metroOut	= 0.0f;
	metroCount	= 0;
	
	//	Incoming params
	globalNumCurves		= 0;
	globalNumShapes		= 0;
	globalNumPoints		= 0;
	globalAlphaAverage	= 0;
	globalAlphaTotal	= 0;
	globalColorTotalR	= 0;
	globalColorTotalG	= 0;
	globalColorTotalB	= 0;
	
	//	Load samples
	
	//	QUAD
	quad_w.load([[[NSBundle mainBundle] pathForResource:@"piano_4" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	quad_x.load([[[NSBundle mainBundle] pathForResource:@"piano_5ths_3" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	quad_y.load([[[NSBundle mainBundle] pathForResource:@"piano_2" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	quad_z.load([[[NSBundle mainBundle] pathForResource:@"piano_5ths_1" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);	
	
	
	//	STAR
	star_w.load([[[NSBundle mainBundle] pathForResource:@"12st_5ths_4" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	star_x.load([[[NSBundle mainBundle] pathForResource:@"12st_3" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	star_y.load([[[NSBundle mainBundle] pathForResource:@"12st_5ths_2" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	star_z.load([[[NSBundle mainBundle] pathForResource:@"12st_1" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);	
	
	
	//	TRI
	tri_w.load([[[NSBundle mainBundle] pathForResource:@"electric_odd_4" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	tri_x.load([[[NSBundle mainBundle] pathForResource:@"electric_3" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	tri_y.load([[[NSBundle mainBundle] pathForResource:@"electric_odd_2" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	tri_z.load([[[NSBundle mainBundle] pathForResource:@"electric_1" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline bool readArrayForIndex(NSArray* a, int i)	{
	bool trigger = false;
	for (NSPoint* p in a)	{
		if (p.x==i)	{
			trigger = true;
			break;
		}
	}
	return trigger;
}


inline void readTriggers	(int i)	{	
	//	QUAD
	if (readArrayForIndex(quadPoints_w, i))	{
		quad_w.trigger();
		quad_w_vol=1.0f;
	}
	if (readArrayForIndex(quadPoints_x, i))	{
		quad_x.trigger();		
		quad_x_vol=1.0f;
	}
	if (readArrayForIndex(quadPoints_y, i))	{		
		quad_y.trigger();
		quad_y_vol=1.0f;
	}
	if (readArrayForIndex(quadPoints_z, i))	{
		quad_z.trigger();
		quad_z_vol=1.0f;
	}
	
	//	STAR
	if (readArrayForIndex(starPoints_w, i))	{
		star_w.trigger();
		star_w_vol=1.0f;
	}
	if (readArrayForIndex(starPoints_x, i))	{
		star_x.trigger();		
		star_x_vol=1.0f;
	}
	if (readArrayForIndex(starPoints_y, i))	{		
		star_y.trigger();
		star_y_vol=1.0f;
	}
	if (readArrayForIndex(starPoints_z, i))	{
		star_z.trigger();
		star_z_vol=1.0f;
	}	
	
	//	TRI
	if (readArrayForIndex(triPoints_w, i))	{
		tri_w.trigger();
		tri_w_vol=1.0f;
	}
	if (readArrayForIndex(triPoints_x, i))	{
		tri_x.trigger();		
		star_x_vol=1.0f;
	}
	if (readArrayForIndex(triPoints_y, i))	{		
		tri_y.trigger();
		tri_y_vol=1.0f;
	}
	if (readArrayForIndex(triPoints_z, i))	{
		tri_z.trigger();
		tri_z_vol=1.0f;
	}	
}

inline void sustain	()	{
	//	QUAD
	quad_w_out*=0.9995;
	quad_x_out*=0.9995;
	quad_y_out*=0.9995;
	quad_z_out*=0.9995;
	//	STAR
	star_w_out*=0.9995;
	star_x_out*=0.9995;
	star_y_out*=0.9995;
	star_z_out*=0.9995;
	
	//	TRI
	tri_w_out*=0.9995;
	tri_x_out*=0.9995;
	tri_y_out*=0.9995;
	tri_z_out*=0.9995;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

#pragma mark USER RENDERING METHOD
float*	output	()	{
	sustain();
	
    render_output[0] = render_output[1] = 0;

	if ((int)metro.phasor(metroSpeed)>=1)	{
		metroCount++;
		if (metroCount>15)
			metroCount = 0;
		readTriggers(metroCount);
	}
	
	//	QUAD
	quad_w_out	= quad_w.playOnce()*quad_w_vol;
	quad_x_out	= quad_x.playOnce()*quad_x_vol;
	quad_y_out	= quad_y.playOnce()*quad_y_vol;
	quad_z_out	= quad_z.playOnce()*quad_z_vol;
	quadOut		= .25*(quad_w_out+quad_x_out+quad_y_out+quad_z_out);
	
	
	//	STAR
	star_w_out	= star_w.playOnce()*star_w_vol;
	star_x_out	= star_x.playOnce()*star_x_vol;
	star_y_out	= star_y.playOnce()*star_y_vol;
	star_z_out	= star_z.playOnce()*star_z_vol;
	starOut		= .25*(star_w_out + star_x_out + star_y_out + star_z_out);
	
	
	//	TRI
	tri_w_out	= tri_w.playOnce()*tri_w_vol;
	tri_x_out	= tri_x.playOnce()*tri_x_vol;
	tri_y_out	= tri_y.playOnce()*tri_y_vol;
	tri_z_out	= tri_z.playOnce()*tri_z_vol;
	triOut		= .25*(tri_w_out + tri_x_out + tri_y_out + tri_z_out);
	
	//	ELLIPSE
	
	render_output	[0] = .3*(starOut+triOut);
	render_output	[1] = .3*(quadOut+triOut);

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
	
	if (playback)
		NSLog(@"PLAYBACK");
	if (!playback)
		NSLog(@"!PLAYBACK");	
	/*
		Points and triggers
	 */
	starPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	starPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	starPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	starPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
	
	NSLog(@"STAR:	W POINTS: %i	X POINTS: %i	Y POINTS: %i	Z POINTS: %i", [starPoints_w count], [starPoints_x count], [starPoints_y count], [starPoints_z count]);
	
//	TRI TOTALS
	triPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:4]];
	triPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:5]];
	triPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:6]];
	triPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:7]];	

	NSLog(@"TRI:	W POINTS: %i	X POINTS: %i	Y POINTS: %i	Z POINTS: %i", [triPoints_w count], [triPoints_x count], [triPoints_y count], [triPoints_z count]);
	
//	QUAD TOTALS
	quadPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:8]];
	quadPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:9]];
	quadPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:10]];
	quadPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:11]];	
	
	NSLog(@"QUAD:	W POINTS: %i	X POINTS: %i	Y POINTS: %i	Z POINTS: %i", [quadPoints_w count], [quadPoints_x count], [quadPoints_y count], [quadPoints_z count]);	


	
//	for (int i = 0; i < 30; i++)	{
//		w_triggers[i] = 0.0f;
//		x_triggers[i] = 0.0f;
//		y_triggers[i] = 0.0f;
//		z_triggers[i] = 0.0f;
//	}
		
	/*
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
	 */

	/*
		Local curve totals
	 */
//	curves_w =	[[parameters objectAtIndex:4]intValue];
//	curves_x =	[[parameters objectAtIndex:5]intValue];
//	curves_y =	[[parameters objectAtIndex:6]intValue];
//	curves_z =	[[parameters objectAtIndex:7]intValue];

	/*
		Local point totals
	*/
	//	STAR
	starPoints_w_Total =	[starPoints_w count];
	starPoints_x_Total =	[starPoints_x count];
	starPoints_y_Total =	[starPoints_y count];
	starPoints_z_Total =	[starPoints_z count];
	 
//	/*
//	 Global totals
//	 */
//	
//	//	Shape stats
//	globalNumCurves		= [[parameters objectAtIndex:8]intValue];
//	globalNumShapes		= [[parameters objectAtIndex:9]intValue];
//	globalNumPoints		= [[parameters objectAtIndex:10]intValue];
//	
//	//	Color info
//	globalAlphaAverage	= [[parameters objectAtIndex:11]doubleValue];
//	globalAlphaTotal	= [[parameters objectAtIndex:12]doubleValue];
//	globalColorTotalR	= [[parameters objectAtIndex:13]doubleValue];
//	globalColorTotalG	= [[parameters objectAtIndex:14]doubleValue];
//	globalColorTotalB	= [[parameters objectAtIndex:15]doubleValue];
//		
//	//	Size info
//	globalShapeSizeAverage	= [[parameters objectAtIndex:16] doubleValue];
//	globalShapeSizeTotal	= [[parameters objectAtIndex:17] doubleValue];	
//	
//	/*
//		Set some local variables
//	 */
//	metroSpeed = 1.0 + (globalNumShapes * globalAlphaAverage);
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