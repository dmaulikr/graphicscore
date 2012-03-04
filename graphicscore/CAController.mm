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
float*	w_pitches	= new float [480];

float*	x_triggers	= new float [30];
float*	x_pitches	= new float [480];

float*	y_triggers	= new float [30];
float*	y_pitches	= new float [480];

float*	z_triggers	= new float [30];
float*	z_pitches	= new float [480];

//	MAXI OBJECT DECLARATION

maxiOsc		metro;
int			metroCount;
double		metroOut;
double		metroSpeed;

maxiSample	sample;
double		sampleSpeed;

maxiOsc		testOsc;
double		testFreq	= 0.0f;
double		testVol		= 0.0f;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void initLocalVariables	(void)	{	
	memset(w_pitches,	0, sizeof(float)*480);
	memset(w_triggers,	0, sizeof(float)*16);
	memset(x_pitches,	0, sizeof(float)*480);
	memset(x_triggers,	0, sizeof(float)*16);
	memset(y_pitches,	0, sizeof(float)*480);
	memset(y_triggers,	0, sizeof(float)*16);
	memset(z_pitches,	0, sizeof(float)*480);
	memset(z_triggers,	0, sizeof(float)*16);	
}

//	MAXI SETUP

double w_out, x_out, y_out, z_out;

inline void maxiSetup		(void)	{
	initLocalVariables();
	
	sampleSpeed = 0;
	sample.load([[[NSBundle mainBundle] pathForResource:@"voice_one" ofType:@"wav"]cStringUsingEncoding:NSUTF8StringEncoding]);
	
	testVol	 = 1.0f;
	testFreq = 0.0f;
	
	metroSpeed	= 2.0f;
	metroOut	= 0.0f;
	metroCount	= 0;
	
	w_out = x_out = y_out = z_out = 0.0f;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

float	trigger_index = 0;
float	triggerIncrement = 0.0018;

inline void readTriggers	(int i)	{	
	if (w_triggers[i]>=0.01f)	{
		sampleSpeed = 2.0f+(0.25f*w_pitches[i]);
		sample.trigger();
		testFreq	= 880.0f + (110.0f*w_pitches[i]);
		testVol		= 1.0f;
		NSLog(@"W");
	}

	if (x_triggers[i]>=0.01f)	{
		sampleSpeed = 1.0f+(0.125*x_pitches[i]);
		sample.trigger();
		testFreq	= 440.0f + (55.0f*x_pitches[i]);
		testVol = 1.0f;	
		NSLog(@"X");
	}

	if (y_triggers[i]>=0.01f)	{
		sampleSpeed = 0.5+(0.0625*y_pitches[i]);
		sample.trigger();
		testFreq	= 220.0f + (27.5f*y_pitches[i]);
		testVol = 1.0f;		
		NSLog(@"Y");	
	}
	
	if (z_triggers[i]>=0.01f)	{
		sampleSpeed = 0.25+(0.03125*z_pitches[i]);
		sample.trigger();
		testFreq	= 110.0f + (13.75f*z_pitches[i]);
		testVol =	1.0f;
		NSLog(@"Z");
	}
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

#pragma mark USER RENDERING METHOD
float*	output	()	{
    render_output[0] = render_output[1] = w_out = x_out = y_out = z_out = 0.0f;
	
	if ((int)metro.phasor(metroSpeed)>=1)	{
		metroCount++;
		if (metroCount>15)
			metroCount = 0;
		readTriggers(metroCount);
	}
	
	if (testVol>0.0f)
		testVol-=0.0001;

	w_out	= testVol*sample.playOnce(sampleSpeed);

	render_output	[0] = w_out + x_out + y_out + z_out;
	render_output	[1] = w_out + x_out + y_out + z_out;
	
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
		w_pitches[(int)p.x] = (int)floorf((80.0f-p.y)/8);
		w_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_x)	{
		p.x = p.x*0.03f;		
		x_pitches[(int)p.x] = (int)floorf((160.0f-p.y)/8);
		x_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_y)	{
		p.x = p.x*0.03f;		
		y_pitches[(int)p.x] = (int)floorf((240.0f-p.y)/8);
		y_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_z)	{
		p.x = p.x*0.03f;		
		z_pitches[(int)p.x] = (int)floorf((320.0f-p.y)/8);
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