//
//  CAController.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import "Parameteriser.h"
#import "ParameteriserDelegateProtocol.h"

/*
  **********	CACONTROLLER		********** 
 
 CAController is the audio output controller used by the application.

 It has three main functions:
 - Host sample playback and synthesis/FX
 - Create and manage the audio rendering process
 - Accept and apply the parameterised controls
 
 Each of these is implemented in a different language – data handling is 
 performed using Objective-C, the synthesis and audio FX use C++, and the
 CoreAudio instance is in C.
 
 CAController is the last stage in the user-input/audio-output chain, and is 
 the delegate for the parameteriser object.
 
 It has a series of Audio Unit instance management functions, for initialising
 the AU instance, starting and stopping the audio stream, toggling playback,
 and closing the audio unit.
 */


@interface CAController : NSObject <ParameteriserDelegate>  {
    AudioComponentInstance		outputUnit;
}

-(void)initAudioController;
-(void)startAudioUnit;
-(void)closeAudioUnit;
-(void)togglePlayback;

OSStatus renderAudioOutput (void *inRefCon,AudioUnitRenderActionFlags *ioActionFlags,  const AudioTimeStamp *inTimeStamp,  UInt32 inBusNumber, UInt32 inNumberFrames,  AudioBufferList *ioData);

float*	output	(void);

@end
