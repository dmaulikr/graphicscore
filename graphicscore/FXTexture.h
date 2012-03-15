//
//  FXTexture.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/03/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_FXTexture_h
#define graphicscore_FXTexture_h

class FXTexture {
	maxiOsc am;	
public:
	double	texture		(double input, double amount, double mix)	{
		return ((input*(0.5*(1+(am.sinewave(amount*8))))*mix)+(input*(1-mix)));
	}
};

#endif
