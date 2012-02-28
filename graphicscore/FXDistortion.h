//
//  FXDistortion.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 07/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#include "FXLibrary.h"
#ifndef graphicscore_FXDistortion_h
#define graphicscore_FXDistortion_h

class FXDistortion {
public:
	double	dry;
	
	double	distortion		(double input, double amount, double mix)	{
		dry = input;
		input*=floor(24*amount);
		input = input > 1 ? 1	: input;
		input = input < -1 ? -1 : input;
		return (input*mix)+(dry*(1-mix));
	}
};

#endif
