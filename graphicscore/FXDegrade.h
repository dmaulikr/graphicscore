//
//  FXDegrade.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/03/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_FXDegrade_h
#define graphicscore_FXDegrade_h

class FXDegrade {
public:
	//	Master
	double	dry;
	double	wet;
	
	//	Crusher
	int		crushCounter;
	double	previousInput;
	
	double	degrade		(double input,	double amount, double mix)	{
		dry = input; 
		wet = input;
		
		//	Distortion
		wet = dry*floor(12.0f*amount);
		wet = wet > 1.0f ? 1.0f : wet;
		wet = wet < -1.0f? -1.0f: wet;
		
		//	Crusher
		amount = amount <= 1 ? 1 : amount;
		if (crushCounter>=floor(12*amount))	{
			crushCounter = 0;
		}
		else	{	
			wet = previousInput;	
		}
		crushCounter++;
		previousInput = wet;
		
		return ((wet*mix)	+	(dry*(1-mix)));
	}
};

#endif
