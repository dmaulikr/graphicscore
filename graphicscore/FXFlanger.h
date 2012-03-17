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
