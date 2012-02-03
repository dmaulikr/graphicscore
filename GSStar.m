//
//  GSStar.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSStar.h"

@implementation GSStar

- (void)drawRect:(CGRect)rect	{
	[[[local colors] objectAtIndex:index]setFill];
	[self setAlpha:self.alpha*0.99];	
	CGContextRef		ref		= UIGraphicsGetCurrentContext();
	CGMutablePathRef	path	= CGPathCreateMutable();
	CGPathMoveToPoint	(path, NULL, self.frame.size.width*0.5, 0);									//	A
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.6,		self.frame.size.height*0.33);	//	B
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.9,		self.frame.size.height*0.33);	//	C
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.66,	self.frame.size.height*0.55);	//	D
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.75,	self.frame.size.height*0.88);	//	E
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.5,		self.frame.size.height*0.66);	//	F
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.25,	self.frame.size.height*0.88);	//	G
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.33,	self.frame.size.height*0.52);	//	H
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.1,		self.frame.size.height*0.33);	//	I
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.4,		self.frame.size.height*0.33);	//	J
	CGContextAddPath	(ref, path);
	CGContextDrawPath	(ref, kCGPathFill);
}

-(void) reset	{
	[self setAlpha:1];
}

@end
