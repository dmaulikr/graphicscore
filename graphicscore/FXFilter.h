//
//  FXFilter.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 07/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//
#include "FXLibrary.h"
#ifndef graphicscore_FXFilter_h
#define graphicscore_FXFilter_h

class FXFilter {

public:
	maxiFilter high_pass;
	maxiFilter low_pass;
	
	double dry;
	
	double	filter		(double input, double hi, double lo, double outputMix)	{
		dry = input;
		
		double hiOut = high_pass.hires	(input, 100+(2000*hi),	1-lo);
		double loOut = low_pass.lores	(input, 100+(300*lo),	1-hi);
		
		return (
				(outputMix*dry)+
				(((1-outputMix)*0.5)*hiOut)+
				(((1-outputMix)*0.5)*loOut)
		);
	}
};

#endif
