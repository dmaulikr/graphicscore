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

@interface CAController : NSObject <ParameteriserDelegate>  {
    AudioComponentInstance		outputUnit;
}

-(void)initAudioController;
-(void)startAudioUnit;
-(void)togglePlayback;

OSStatus renderAudioOutput (void *inRefCon,AudioUnitRenderActionFlags *ioActionFlags,  const AudioTimeStamp *inTimeStamp,  UInt32 inBusNumber, UInt32 inNumberFrames,  AudioBufferList *ioData);

float*	output	(void);

@end
