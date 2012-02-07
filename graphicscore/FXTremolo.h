//
//  FXTremolo.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 07/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//
#include "FXLibrary.h"
#ifndef graphicscore_FXTremolo_h
#define graphicscore_FXTremolo_h

class FXTremolo {
	maxiOsc am;	
	public:
		double	tremolo		(double input, double amount)	{
			return input*(0.5*(1+(am.sinewave(amount*8))));
		}
};

#endif
