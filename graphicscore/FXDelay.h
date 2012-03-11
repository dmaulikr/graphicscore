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
			amount	= amount	> 0.75 ? 0.75 : amount;
			mix		= mix		> 0.75 ? 0.75 : mix;			
			input	= delay_one.dl	(input, (.22*amount)  * sr, amount);
			input	= delay_two.dl	(input, (0.44*amount) * sr, amount);	
			input	= delay_three.dl(input, (0.66*amount) * sr, amount);
			input	= delay_four.dl	(input, (0.88*amount) * sr, amount);	
			return	(input*mix)+(i*(1.0f-mix));	
		}
};

#endif
