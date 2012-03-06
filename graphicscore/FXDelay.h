//
//  FXDelay.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 07/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//
#import "FXLibrary.h"
#ifndef graphicscore_FXDelay_h
#define graphicscore_FXDelay_h

#define sr 44100.0

class FXDelay {
	double			i;
	maxiDelayline	delay_one;
	maxiDelayline	delay_two;
	maxiDelayline	delay_three;
	maxiDelayline	delay_four;
	
	public:
		inline double	delay	(double input, double amount, double mix)	{
			i = input;
			input = delay_one.dl	(input, (.1*amount) * sr, amount);
			input = delay_two.dl	(input, (0.3*amount) * sr, amount);	
			input = delay_three.dl	(input, (0.4*amount)* sr, amount);
			input = delay_four.dl	(input, (0.6*amount) * sr, amount);	
			return (input*mix)+(i*(1.0f-mix));	
		}
};

#endif
