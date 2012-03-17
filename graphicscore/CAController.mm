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
double		globalAlphaAverage	= 0.0f;
double		globalAlphaTotal	= 0.0f;	
double		globalColorTotalR	= 0.0f;
double		globalColorTotalG	= 0.0f;
double		globalColorTotalB	= 0.0f;
double		globalColorAverage	= 0.0f;
int			globalNumShapes		= 0;

int			numQuads			= 0;
int			numEllipses			= 0;
int			numStars			= 0;
int			numTriangles		= 0;

//	SAMPLE PLAYERS
//	QUAD
maxiSample	quad_w;
maxiSample	quad_x;
maxiSample	quad_y;
maxiSample	quad_z;
double		quad_w_out, quad_x_out, quad_y_out, quad_z_out;
double		quad_w_vol, quad_x_vol, quad_y_vol, quad_z_vol;
double		quadOut = 0.0f;

//	STAR
maxiSample	star_w;
maxiSample	star_x;
maxiSample	star_y;
maxiSample	star_z;
double		star_w_out, star_x_out, star_y_out, star_z_out;
double		star_w_vol, star_x_vol, star_y_vol, star_z_vol;
double		starOut = 0.0f;


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



//	Dry signal + delay
double			dryOut		= 0.0f;
double			dryDelOut	= 0.0f;
maxiDelayline	dryDel;
double			dryDelAmount= 0.33;
//double			dryDelFeedback  = 0.45;


//	Pad, plus modulation
double			padMix		= 0.0f;
double			padOut		= 0.0f;
double			padModLevel = 0.5;
double			padModSpeed	= 0.5;

maxiFilter		loPass, loPass2, loPass3;
maxiDelayline	pad, pad2, pad3;
maxiOsc			padMod1, padMod2, padMod3;
double			padMod1Out		= 0.0f;
double			padMod2Out		= 0.0f;
double			padMod3Out		= 0.0f;
double			padBrightness	= 0.4f;
double			padMod1Depth	= 0.5f;
double			padMod2Depth	= 0.5f;
double			padMod3Depth	= 0.5f;

//	Degrader
FXDegrade		degrader;
double			degradeAmount = 1;
double			degradeMix	  = 0.0f;

//	FLANGER
FXFlanger		flanger;
double			metal	= 1.0f;
FXFlanger		postFlanger;

//	TEXTURE
FXTexture		texture1;
double			texture1Mix	= 0.0f;
double			texture1Speed= 0.0f;
FXTexture		texture2;
double			texture2Mix	= 0.0f;
double			texture2Speed= 0.0f;
double			globalNumCurves = 0.0f;

maxiOsc			texturePan1, texturePan2;
double			texture1Pan = 1.0f;
double			texture2Pan = 1.0f;

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
	
	padBrightness = 0.5f;
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
	quad_w_vol*=0.99994;
	quad_x_vol*=0.99994;
	quad_y_vol*=0.99994;
	quad_z_vol*=0.99994;
	//	STAR
	star_w_vol*=0.99994;
	star_x_vol*=0.99994;
	star_y_vol*=0.99994;
	star_z_vol*=0.99994;
	
	//	TRI
	tri_w_vol *=0.99994;
	tri_x_vol *=0.99994;
	tri_y_vol *=0.99994;
	tri_z_vol *=0.99994;
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

double	combo	= 0.0f;
double	panLD	= 0.0f;
double	panRD	= 0.0f;
double	panLW	= 0.0f;
double	panRW	= 0.0f;

#pragma mark USER RENDERING METHOD
float*	output	()	{
	sustain();

	if ((int)metro.phasor(metroSpeed)>=1)	{
		metroCount+=2;
		if (metroCount>15)	{
			metroCount	= oddMod;
			if (!oddMod)
				oddMod = 1;
			else
				oddMod = 0;
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
		
	//	MIX
	dryOut		= padOut = ((triOut+starOut+quadOut)*globalAlphaAverage);
	
	//	DEGRADER
	dryOut		= degrader.degrade(dryOut, degradeAmount, degradeMix*0.75);

	//	PAD
	padMod1Out	= padMod1Depth*(1+padMod1.saw	(padModSpeed*0.99));
	padMod2Out	= padMod2Depth*(1+padMod2.saw	(padModSpeed*0.66));
	padMod3Out	= padMod3Depth*(1+padMod3.saw	(padModSpeed*0.33));	

	padOut		= pad.dl		(padOut, 22050+(44100*(padMod1Out*0.33)),	0.75+(0.2*padMod1Out));
	padOut		= loPass.lopass (padOut, padBrightness);
	padOut		= pad2.dl		(padOut, 11025+(44100*(padMod2Out*0.66)),  0.75+(0.2*padMod2Out));
	padOut		= loPass2.lopass(padOut, padBrightness*0.75);
	padOut		= pad3.dl		(padOut, 11025+(44100*(padMod3Out*0.5)),  0.75+(0.2*padMod3Out));
	padOut		= loPass3.lopass(padOut, padBrightness*0.33);
	
	//	DRY
	dryDelOut	= dryDel.dl(dryOut, 1+(44100*(1-dryDelAmount)), dryDelAmount);
	dryOut		= (dryDelOut+dryOut);
	
	//	FLANGER
//	dryOut		= (dryOut*(1-metal)+(metal*postFlanger.flange(padOut, metal)));
	padOut		= (padOut*(1-metal)+(metal*postFlanger.flange(padOut, metal)));

	//	Texture 1
	dryOut		= texture1.texture(dryOut, texture1Speed, texture1Mix);

	//	Texture 2
	padOut		= texture2.texture(padOut, texture2Speed, texture2Mix);
	
	//	Rectify, scale
	texture1Pan = 1+(0.5*texturePan1.sinewave(texture1Speed));
	texture2Pan = 1+(0.5*texturePan2.sinewave(texture2Speed));
	
	padOut *=	padMix;
	dryOut *=	(0.75-padMix);
	
	combo	=	(padOut+dryOut);
	
	panLD	=	(texture1Pan*dryOut);
	panRD	=	((1-texture2Pan)*dryOut);
	
	panLW	=	((1-texture1Pan)*padOut);
	panRW	=	(texture2Pan*padOut);

	render_output	[0] =	1.5*(panLD+panLW+combo) > .95f ? .95f : 2.0*(panLD+panLW+combo);
	render_output	[1] =	1.5*(panRD+panRW+combo) > .95f ? .95f : 2.0*(panRD+panRW+combo);

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
	globalNumCurves = [curvesW count] + [curvesX count] + [curvesY count] + [curvesZ count];
	
//	COLOR INFO
	globalColorTotalR	= [[parameters objectAtIndex:18]doubleValue];
	globalColorTotalG	= [[parameters objectAtIndex:19]doubleValue];
	globalColorTotalB	= [[parameters objectAtIndex:20]doubleValue];
	if (globalColorTotalB>0.0f&&globalColorTotalG>0.0f&&globalColorTotalR>0.0f&&globalNumShapes>0)	{
		globalColorAverage	= (((globalColorTotalB+globalColorTotalG+globalColorTotalR)/3)/globalNumShapes);		
	}
	else {
		globalColorAverage = 0.1;
	}	
	
	metroSpeed = 0.5;
	
	//	Num shapes
	globalNumShapes		= [[parameters objectAtIndex:21]intValue];
	numQuads			= [[parameters objectAtIndex:22]intValue];
	numEllipses			= [[parameters objectAtIndex:23]intValue];
	numStars			= [[parameters objectAtIndex:24]intValue];
	numTriangles		= [[parameters objectAtIndex:25]intValue];
	
	//	DRY SIG
	dryDelAmount	=	overlap		 > 0.88 ? 0.88 : overlap;
	dryDelAmount	=	dryDelAmount < 0.0f ? 0.0f : dryDelAmount;

	
	//	PAD SIG	+ BRIGHTNESS
	padMod1Depth	=	0.2 + (0.25*numTriangles	> 1.0f ? 1.0f : 0.25*numTriangles);
	padMod2Depth	=	0.2 + (0.25*numQuads		> 1.0f ? 1.0f : 0.25*numQuads);
	padMod3Depth	=	0.2 + (0.25*numEllipses		> 1.0f ? 1.0f : 0.25*numEllipses);
	
	padMix			=	0.05+(overlap*1.85 > .975f ? .975f : overlap*1.85);
	padBrightness	=	0.1+(globalColorAverage * globalAlphaAverage);
	
	if (globalNumShapes>0)	{
	//	DEGRADER	
		degradeMix		=	0.01+(globalColorTotalR/globalNumShapes)*globalAlphaAverage > 1 
		? 1.0f : (globalColorTotalR/globalNumShapes)*globalAlphaAverage;
		
		degradeAmount	=	0.01+(globalColorTotalR/globalNumShapes)*globalAlphaAverage > 1 
		? 1.0f : (globalColorTotalR/globalNumShapes)*globalAlphaAverage;

	//	FLANGER
		metal		=	0.075+(globalColorTotalG/globalNumShapes) > .9f
		? .9f : 0.075+(globalColorTotalG/globalNumShapes);	 
		
	//	TEXTURE
		texture1Mix = 0.01+(globalColorTotalB/globalNumShapes)*globalAlphaAverage > 0.75f
		? 0.75f : (globalColorTotalB/globalNumShapes)*globalAlphaAverage;
		texture1Mix = texture1Mix < 0.5 ? 0.5 : texture1Mix;
		
		texture1Speed = 0.01+0.77*(globalNumCurves*0.0065);

		texture2Speed = 0.01+0.5*(globalColorTotalB/globalNumShapes)*globalAlphaAverage;

		texture2Mix = 0.01+(0.66*(globalNumCurves*0.0065) > 0.75 ? 0.75 : 0.66*(globalNumCurves*0.0065));
		texture2Mix = texture2Mix < 0.5 ? 0.5 : texture2Mix;
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