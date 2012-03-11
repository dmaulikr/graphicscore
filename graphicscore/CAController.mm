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


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void initLocalVariables	(void)	{	
	//	Create trigger buffers
	
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
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void readTriggers	(int i)	{	
//	if (w_triggers[i]>=0.01f)	{
//		w_vol = 1.0f;
//		sample_w.trigger();
//	}
//
//	if (x_triggers[i]>=0.01f)	{
//		x_vol = 1.0f;		
//		sample_x.trigger();		
//	}
//
//	if (y_triggers[i]>=0.01f)	{
//		sample_y.trigger();
//		y_vol = 1.0f;
//	}
//	
//	if (z_triggers[i]>=0.01f)	{
//		sample_z.trigger();
//		z_vol =	1.0f;
//	}
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////


#pragma mark USER RENDERING METHOD
float*	output	()	{
    render_output[0] = render_output[1] = 0;
	
	if ((int)metro.phasor(metroSpeed)>=1)	{
		metroCount++;
		if (metroCount>15)
			metroCount = 0;
		readTriggers(metroCount);
	}
	
	render_output	[0] = .0f;
	render_output	[1] = .0f;

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
	NSArray*	starPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	NSArray*	starPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	NSArray*	starPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	NSArray*	starPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
	
	NSLog(@"STAR:	W POINTS: %i	X POINTS: %i	Y POINTS: %i	Z POINTS: %i", [starPoints_w count], [starPoints_x count], [starPoints_y count], [starPoints_z count]);
	
//	TRI TOTALS
	NSArray*	triPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:4]];
	NSArray*	triPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:5]];
	NSArray*	triPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:6]];
	NSArray*	triPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:7]];	

	NSLog(@"TRI:	W POINTS: %i	X POINTS: %i	Y POINTS: %i	Z POINTS: %i", [triPoints_w count], [triPoints_x count], [triPoints_y count], [triPoints_z count]);
	
//	QUAD TOTALS
	NSArray*	quadPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:8]];
	NSArray*	quadPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:9]];
	NSArray*	quadPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:10]];
	NSArray*	quadPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:11]];	

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