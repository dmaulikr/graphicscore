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
	
	double dry;
	
	public:
		FXFlanger (void);
	
		double	flange	(double input, double amount, double mix)	{
			dry = input;
			controlSignal	= 0.5*(1+flangerCTL.sinewave(0.1*amount));
			flangeFeedback	= amount > 0.99 ? 0.99 : amount;
			flangeFeedback	= flangeFeedback < 0.01 ? 0.01 : flangeFeedback;
			flangedOut		= flanger.dl(input, (882*controlSignal)+10, flangeFeedback);
			return sqrt(0.5)*((flangedOut*mix)+(dry*(1-mix)));
		}
};

#endif

FXFlanger::FXFlanger (void)	{
	controlSignal	= 0.0f;
	flangedOut		= 0.0f;
	flangeFeedback	= 0.1f;
}
