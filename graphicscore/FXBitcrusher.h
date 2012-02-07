//
//  FXBitcrusher.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 07/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//
#import "FXLibrary.h"
#ifndef graphicscore_FXBitcrusher_h
#define graphicscore_FXBitcrusher_h

class FXBitcrusher {
public:
	FXBitcrusher (void);
	
	int		crushCounter;
	double	previousInput;
	
	double	bitcrusher		(double input, double amount)	{
		if (crushCounter>=floor(24*amount))
			crushCounter = 0;
		else	input = previousInput;
		crushCounter++;	
		previousInput = input;
		return input;	
	}
};

#endif

FXBitcrusher::FXBitcrusher (void)	{
	crushCounter = 0;
	previousInput = 0.0f;
}