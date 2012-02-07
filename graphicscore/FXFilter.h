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
	
	double	lowpass		(double input, double res)	{
		input = low_pass.lores(input, 100+(2000*res), 0.95-res);	
		return input;	
	}
	
	double	highpass	(double input, double res)	{
		input = high_pass.hires(input, 100+(3000*res), 0.95-res);
		return input;	
	}
};

#endif
