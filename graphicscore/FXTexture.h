//
//  FXTexture.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/03/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_FXTexture_h
#define graphicscore_FXTexture_h

/*
 **********	FXTEXTURE	**********

 FXTexture is an amplitude modulation object which alters the volume
 of a signal (input) by a speed (amount). This effected signal is then
 blended with the dry input signal according to the value of 'mix'.
 */

class FXTexture {
	maxiOsc am;	
public:
	double	texture		(double input, double amount, double mix)	{
		return ((input*(0.5*(1+(am.sinewave(amount*8))))*mix)+(input*(1-mix)));
	}
};

#endif
