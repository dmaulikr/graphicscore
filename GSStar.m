//
//  GSStar.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSStar.h"

@implementation GSStar
@synthesize index, local, angleOfRotation;

- (id)initWithFrame:(CGRect)frame	{
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = NO;
		[self setBackgroundColor:[UIColor clearColor]];
		angleOfRotation=0.4;
    }
    return self;
}

- (void)drawRect:(CGRect)rect	{
	[[[local colors] objectAtIndex:index]setFill];
	angleOfRotation+=0.05;
	[self setTransform:CGAffineTransformMakeRotation(angleOfRotation)];
//	[[UIColor redColor]setFill];
	CGContextRef		ref		= UIGraphicsGetCurrentContext();
	CGMutablePathRef	path	= CGPathCreateMutable();
	CGPathMoveToPoint	(path, NULL, self.frame.size.width*0.5, 0);									//	A
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.6,		self.frame.size.height*0.33);	//	B
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.9,		self.frame.size.height*0.33);	//	C
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.66,	self.frame.size.height*0.55);	//	D
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.75,		self.frame.size.height*0.88);	//	E
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.5,		self.frame.size.height*0.66);	//	F
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.25,	self.frame.size.height*0.88);	//	G
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.33,	self.frame.size.height*0.52);	//	H
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.1,		self.frame.size.height*0.33);	//	I
	CGPathAddLineToPoint(path, NULL, self.frame.size.width*0.4,		self.frame.size.height*0.33);	//	J
	CGContextAddPath	(ref, path);
	CGContextDrawPath	(ref, kCGPathFill);
}

@end
