//
//  NSPixel.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 18/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "NSPixel.h"

@implementation NSPixel
@synthesize r, g, b, a;

-(id)initWithRed:(int)_r Green:(int)_g Blue:(int)_b andAlpha:(int)_a	{
	self = [super init];
	if (self)	{
		r = _r;
		g = _g;
		b = _b;
		a = _a;
	}
	return self;
}

@end
