//
//  FXFlanger.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 07/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_FXFlanger_h
#define graphicscore_FXFlanger_h
#include "FXLibrary.h"

/*
 **********	FXFlanger	**********

 This object is an audio DSP flanger, used to add a metallic effect
 to any audio signal it is passed.
 
 The flanger takes the audio signal and a control value as its 
 arguments – the control value is used to set the breadth and metallic
 quality of the effect.
 
 A metallic feel is created by allowing more feedback signal into the 
 signal path, creating a metallic ringing. The 'amount' also sets the
 speed of the osciallator which controls the frequency sweep.
 */

class FXFlanger {
	maxiDelayline	flanger;
	maxiOsc			flangerCTL;
	double			controlSignal;
	double			flangedOut;
	double			flangeFeedback;
	
	public:
		FXFlanger (void);
	
		double	flange	(double input, double amount)	{
			controlSignal	= 0.5*(1+flangerCTL.sinewave(0.1*amount));
			flangeFeedback	= amount > 0.9 ? 0.9 : amount;
			flangeFeedback	= flangeFeedback < 0.1 ? 0.1 : flangeFeedback;
			flangedOut		= flanger.dl(input, (882*controlSignal)+10, flangeFeedback);
			return flangedOut;
		}
};

#endif

FXFlanger::FXFlanger (void)	{
	controlSignal	= 0.0f;
	flangedOut		= 0.0f;
	flangeFeedback	= 0.1f;
}
