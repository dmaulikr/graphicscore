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

NSArray*	curvesW;
NSArray*	curvesX;
NSArray*	curvesY;
NSArray*	curvesZ;

//	MAX OBJECT DECLARATION

#pragma mark METRONOME
maxiOsc		metro;
int			metroCount;
double		metroOut;
double		metroSpeed;
int			oddMod = 1;

#pragma mark PARAMETERS

//	Band outputs
double w_out, x_out, y_out, z_out;

//	Overlap
double overlap;

//	Globals
//	…color
double		globalAlphaAverage;
double		globalAlphaTotal;
double		globalColorTotalR;
double		globalColorTotalG;
double		globalColorTotalB;

//	SAMPLE PLAYERS
//	QUAD
maxiSample	quad_w;
maxiSample	quad_x;
maxiSample	quad_y;
maxiSample	quad_z;
double		quad_w_out, quad_x_out, quad_y_out, quad_z_out;
double		quad_w_vol, quad_x_vol, quad_y_vol, quad_z_vol;
double		quadOut;

//	STAR
maxiSample	star_w;
maxiSample	star_x;
maxiSample	star_y;
maxiSample	star_z;
double		star_w_out, star_x_out, star_y_out, star_z_out;
double		star_w_vol, star_x_vol, star_y_vol, star_z_vol;
double		starOut;


//	TRI
maxiSample	tri_w;
maxiSample	tri_x;
maxiSample	tri_y;
maxiSample	tri_z;
double		tri_w_out, tri_x_out, tri_y_out, tri_z_out;
double		tri_w_vol, tri_x_vol, tri_y_vol, tri_z_vol;
double		triOut;


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
	
	curvesW		 = [[NSArray alloc] init];
	curvesX		 = [[NSArray alloc] init];
	curvesY		 = [[NSArray alloc] init];
	curvesZ		 = [[NSArray alloc] init];
}

inline void maxiSetup		(void)	{
	initLocalVariables();
	
	//	Metronome setup
	metroSpeed	= 2.0f;
	metroOut	= 0.0f;
	metroCount	= 0;
	
	//	Incoming params
	globalAlphaAverage	= 0;
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
	tri_w.load([[[NSBundle mainBundle] pathForResource:@"evp_4" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	tri_x.load([[[NSBundle mainBundle] pathForResource:@"evp_3" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	tri_y.load([[[NSBundle mainBundle] pathForResource:@"evp_2" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	tri_z.load([[[NSBundle mainBundle] pathForResource:@"evp_1" ofType:@"wav"] cStringUsingEncoding:NSUTF8StringEncoding]);
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

	NSLog(@"I: %i", i);
}

inline void sustain	()	{
	//	QUAD
	quad_w_vol*=0.99993;
	quad_x_vol*=0.99993;
	quad_y_vol*=0.99993;
	quad_z_vol*=0.99993;
	//	STAR
	star_w_vol*=0.99993;
	star_x_vol*=0.99993;
	star_y_vol*=0.99993;
	star_z_vol*=0.99993;
	
	//	TRI
	tri_w_vol *=0.99993;
	tri_x_vol *=0.99993;
	tri_y_vol *=0.99993;
	tri_z_vol *=0.99993;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////


double			dryOut		= 0.0f;
double			dryDelOut	= 0.0f;
double			dryTremOut	= 0.0f;
double			dryTremSpeed= 0.66;
maxiDelayline	dryDel;
maxiOsc			dryTrem;
double			dryDelLength	= 0.33;
double			dryDelFeedback  = 0.45;

double			padOut		= 0.0f;
double			padModLevel = 0.5;
double			padModSpeed	= 0.5;
maxiFilter		loPass, loPass2, loPass3;
maxiDelayline	pad, pad2, pad3;
maxiOsc			padMod1, padMod2, padMod3;
maxiOsc			padTrem;
double			padTremSpeed = 0.5f;

#pragma mark USER RENDERING METHOD
float*	output	()	{
	sustain();

	if ((int)metro.phasor(metroSpeed)>=1)	{
		metroCount+=2;
		if (metroCount>15)	{
			metroCount	= oddMod;
			if (!oddMod)	{
				oddMod = 1;
			}
			else	{
				oddMod = 0;
			}
		}
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
		
	//	PAD
	dryOut		= padOut = (triOut+starOut+quadOut);
	padOut		= pad.dl		(padOut, 44100*(0.33 + (padModLevel*padMod1.sinewave(padModSpeed*0.5))),   0.9);
	padOut		= loPass.lopass (padOut, 0.09);
	padOut		= pad2.dl		(padOut, 44100*(0.5  + (padModLevel*padMod2.sinewave(padModSpeed*0.33))),  0.925);
	padOut		= loPass2.lopass(padOut, 0.09);	
	padOut		= pad3.dl		(padOut, 44100*(0.66 + (padModLevel*padMod3.sinewave(padModSpeed*0.66))),  0.9);	
	padOut		= loPass3.lopass(padOut, 0.09);	
//	padOut		= padOut*(1+0.25*(padTrem.sinewave(padTremSpeed)));
	
	
	//	DRY
	dryDelOut	= dryDel.dl(dryOut, 44100*dryDelLength, dryDelFeedback);
//	dryTremOut	= 1+(0.2*dryTrem.sinewave(dryTremSpeed));
	dryOut		= 0.5*(dryDelOut+dryOut);
	
	render_output	[0] = padOut*globalAlphaAverage+((1-globalAlphaAverage)*dryOut);
	render_output	[1] = padOut*globalAlphaAverage+((1-globalAlphaAverage)*dryOut);

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
	starPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:0]];
	starPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:1]];
	starPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:2]];
	starPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:3]];	
		
//	TRI TOTALS
	triPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:4]];
	triPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:5]];
	triPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:6]];
	triPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:7]];	
	
//	QUAD TOTALS
	quadPoints_w = [NSArray arrayWithArray:[parameters objectAtIndex:8]];
	quadPoints_x = [NSArray arrayWithArray:[parameters objectAtIndex:9]];
	quadPoints_y = [NSArray arrayWithArray:[parameters objectAtIndex:10]];
	quadPoints_z = [NSArray arrayWithArray:[parameters objectAtIndex:11]];	
	
	overlap				= [[parameters objectAtIndex:12]doubleValue];
	globalAlphaAverage	= [[parameters objectAtIndex:13]doubleValue];	
	
	/*
		Local curve totals
	 */
	curvesW =	[NSMutableArray arrayWithArray:[parameters objectAtIndex:14]];
	curvesX =	[NSMutableArray arrayWithArray:[parameters objectAtIndex:15]];
	curvesY =	[NSMutableArray arrayWithArray:[parameters objectAtIndex:16]];
	curvesZ =	[NSMutableArray arrayWithArray:[parameters objectAtIndex:17]];
	
//	COLOR INFO
	globalColorTotalR	= [[parameters objectAtIndex:18]doubleValue];
	globalColorTotalG	= [[parameters objectAtIndex:19]doubleValue];
	globalColorTotalB	= [[parameters objectAtIndex:20]doubleValue];
	globalAlphaAverage	= [[parameters objectAtIndex:21]doubleValue];
	
	metroSpeed = 0.5;
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