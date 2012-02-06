//
//  CAController.mm
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "CAController.h"
#import "maximilian.h"

////////////////////////////////////////////////////////////
const		Float64		sampleRate = 44100.0;
float*		bufferL;
float*		bufferR;
float*		j = new float [2];
float*		render_output = new float [2];

bool		playback;	//	YES if noise is desired
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

float*	w_triggers	= new float [480];
float*	w_pitches	= new float [480];

float*	x_triggers	= new float [480];
float*	x_pitches	= new float [480];

float*	y_triggers	= new float [480];
float*	y_pitches	= new float [480];

float*	z_triggers	= new float [480];
float*	z_pitches	= new float [480];

//	MAXI OBJECT DECLARATION

maxiSample	sample;
double		sampleSpeed;

bool	wTrig, xTrig, yTrig, zTrig;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline void initLocalVariables	(void)	{	
	memset(w_pitches,	0, sizeof(float)*480);
	memset(w_triggers,	0, sizeof(float)*480);
	memset(x_pitches,	0, sizeof(float)*480);
	memset(x_triggers,	0, sizeof(float)*480);
	memset(y_pitches,	0, sizeof(float)*480);
	memset(y_triggers,	0, sizeof(float)*480);
	memset(z_pitches,	0, sizeof(float)*480);
	memset(z_triggers,	0, sizeof(float)*480);	
}

//	MAXI SETUP

inline void maxiSetup		(void)	{
	initLocalVariables();
	wTrig = xTrig = yTrig = zTrig = true;
	
	sampleSpeed = 0;
	sample.load([[[NSBundle mainBundle] pathForResource:@"voice_one" ofType:@"wav"]cStringUsingEncoding:NSUTF8StringEncoding]);
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

float	trigger_index = 0;
float	triggerIncrement = 0.0018;

inline void readTriggers	(int i)	{	
	if (w_triggers[i]>=0.01f && wTrig)	{
		sampleSpeed = 1.5;//+(0.5*(80/w_pitches[i]));
		sample.trigger();
		wTrig = false;
	}
	else if (!w_triggers[i]>=0.01f)
		wTrig = true;
	
	if (x_triggers[i]>=0.01f && xTrig)	{
		sampleSpeed = 1.0;//+(0.5*(80/x_pitches[i]));
		sample.trigger();
		xTrig = false;	
	}
	else if (!x_triggers[i]>=0.01f)
		xTrig = true;

	if (y_triggers[i]>=0.01f && yTrig)	{
		sampleSpeed = 0.5;//+(0.5*(80/y_pitches[i]));
		sample.trigger();
		yTrig = false;
	}
	else if (!y_triggers[i]>=0.01f)
		yTrig = true;
	
	if (z_triggers[i]>=0.01f && zTrig)	{
		sampleSpeed = 0.2;//+(0.5*z_pitches[i]);
		sample.trigger();
		zTrig = false;
	}
	else if (!z_triggers[i]>=0.01f)
		zTrig = true;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

#pragma mark USER RENDERING METHOD
float*	output	()	{
    render_output[0]= 0.0f;
    render_output[1]= 0.0f;
	
	trigger_index+=triggerIncrement;
	if (trigger_index>480.0f)	{
		trigger_index = 0.0;
	}
	readTriggers(floorf(trigger_index));
	
	render_output[0] = render_output [1] = sample.playOnce(sampleSpeed);
	
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

-(void)updatedParameters:(NSMutableArray*)parameters	{
//	NSLog(@"Parameters received by audio controller: ");	
	initLocalVariables();
	
	NSArray*	points_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	NSArray*	points_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	NSArray*	points_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	NSArray*	points_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
	
	for (NSPoint* p in points_w)	{
//		NSLog(@"W trigger at %f with pitch %f", p.x, 80.0f-p.y);
		w_pitches[(int)p.x] = 80.0f-p.y;
		w_triggers[(int)p.x] = 1.0f;
	}
//	NSLog(@"\n\n");	
	
	for (NSPoint* p in points_x)	{
//		NSLog(@"X trigger at %f with pitch %f", p.x, 160.0f-p.y);
		x_pitches[(int)p.x] = 160.0f-p.y;
		x_triggers[(int)p.x] = 1.0f;
	}
//	NSLog(@"\n\n");
	
	for (NSPoint* p in points_y)	{
//		NSLog(@"Y trigger at %f with pitch %f", p.x, 240.0f-p.y);
		y_pitches[(int)p.x] = 240.0f-p.y;
		y_triggers[(int)p.x] = 1.0f;
	}
//	NSLog(@"\n\n");
	
	for (NSPoint* p in points_z)	{
//		NSLog(@"Z trigger at %f with pitch %f", p.x, 320.0f-p.y);
		z_pitches[(int)p.x] = 320.0f-p.y;
		z_triggers[(int)p.x] = 1.0f;
	}
//	NSLog(@"\n\n");
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

@end