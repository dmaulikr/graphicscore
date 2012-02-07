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
	
	sampleSpeed = 0;
	sample.load([[[NSBundle mainBundle] pathForResource:@"voice_one" ofType:@"wav"]cStringUsingEncoding:NSUTF8StringEncoding]);
	
	testVol	 = 1.0f;
	testFreq = 0.0f;
	
	metroSpeed	= 480.0f/5.0f;
	metroOut	= 0.0f;
	metroCount	= 0;
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
	}

	if (x_triggers[i]>=0.01f)	{
		sampleSpeed = 1.0f+(0.125*x_pitches[i]);
		sample.trigger();
		testFreq	= 440.0f + (55.0f*x_pitches[i]);
		testVol = 1.0f;		
	}

	if (y_triggers[i]>=0.01f)	{
		sampleSpeed = 0.5+(0.0625*y_pitches[i]);
		sample.trigger();
		testFreq	= 220.0f + (27.5f*y_pitches[i]);
		testVol = 1.0f;		
	}
	
	if (z_triggers[i]>=0.01f)	{
		sampleSpeed = 0.25+(0.03125*z_pitches[i]);
		sample.trigger();
		testFreq	= 110.0f + (13.75f*z_pitches[i]);
		testVol = 1.0f;
	}
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

maxiFilter high_pass;
maxiFilter low_pass;

maxiSample samplePlayer;

maxiDelayline delay_one;
maxiDelayline delay_two;
maxiDelayline delay_three;
maxiDelayline delay_four;

maxiDelayline	flanger;
maxiOsc			flangerCTL;

maxiOsc am;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline double	distortion		(double input, double amount)	{
	input*=floor(24*amount);
	input = input > 1 ? 1	: input;
	input = input < -1 ? -1 : input;
	return input * 0.6;	
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

int		crushCounter = 0;
double	previousInput = 0.0f;
inline double	bitcrusher		(double input, double amount)	{
	if (crushCounter>=floor(16*amount))
		crushCounter = 0;
	else	input = previousInput;
	crushCounter++;	
	previousInput = input;
	return input;	
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline double	lowpass		(double input, double res)	{
	input = low_pass.lores(input, 100+(2000*res), 0.95-res);	
	return input;	
}

//	HIPASS
inline double	highpass	(double input, double res)	{
	input = high_pass.hires(input, 100+(3000*res), 0.95-res);
	return input;	
}


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

double	i;
inline double	delay	(double input, double amount, double mix)	{
	i = input;
	input = delay_one.dl	(input, (.25*amount) * sampleRate, amount);
	input = delay_two.dl	(input, (0.5*amount) * sampleRate, amount);	
	input = delay_three.dl	(input, (0.75*amount)* sampleRate, amount);
	input = delay_four.dl	(input, (0.1*amount) * sampleRate, amount);	
	return (input*mix)+(i*(1.0f-mix));	
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

inline double	amp_mod		(double input, double amount)	{
	return input*(0.5*(1+(am.sinewave(amount*8))));
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

double controlSignal = 0.0f;
double flangedOut = 0.0f;
double flangeFeedback = 0.1f;

inline double	flange	(double input, double amount)	{
	controlSignal	= 0.5*(1+flangerCTL.sinewave(0.25*amount));
	flangeFeedback	= amount > 0.95 ? 0.95 : amount;
	flangeFeedback	= flangeFeedback < 0.01 ? 0.01 : flangeFeedback;
	flangedOut		= flanger.dl(input, (882*controlSignal)+10, flangeFeedback);
	return sqrt(0.5)*(flangedOut+input);
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

double monoOut = 0.0f;

maxiOsc delayMixer;
maxiOsc flangeFeedbackMod;

#pragma mark USER RENDERING METHOD
float*	output	()	{
    render_output[0] = render_output[1] = monoOut = 0.0f;
	
	if ((int)metro.phasor(metroSpeed)>=1.0)	{
		metroCount++;
		if (metroCount>480)
			metroCount = 0;
		readTriggers(metroCount);
	}
	
	if (testVol>0.0f)
		testVol-=0.0001;

	monoOut = testVol*sample.playOnce(sampleSpeed);
	monoOut = bitcrusher(monoOut, 0.2);
	monoOut = distortion(monoOut, 0.5);
	monoOut = amp_mod(monoOut, 0.1);
	monoOut = flange(monoOut, 0.5*(1+flangeFeedbackMod.sinewave(0.55)));
	monoOut = delay(monoOut, 0.5*(1+delayMixer.sinewave(0.5)), 0.5);

	render_output	[0] = monoOut;
	render_output	[1] = monoOut;
	
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
	initLocalVariables();
	
	NSArray*	points_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	NSArray*	points_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	NSArray*	points_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	NSArray*	points_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
	
	for (NSPoint* p in points_w)	{
		w_pitches[(int)p.x] = (int)floorf((80.0f-p.y)/8);
		w_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_x)	{
		x_pitches[(int)p.x] = (int)floorf((160.0f-p.y)/8);
		x_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_y)	{
		y_pitches[(int)p.x] = (int)floorf((240.0f-p.y)/8);
		y_triggers[(int)p.x] = 1.0f;
	}
	
	for (NSPoint* p in points_z)	{
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

@end