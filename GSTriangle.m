//
//  GSTriangle.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSTriangle.h"

@implementation GSTriangle
@synthesize color, peakPoint, lowerLeft, lowerRight, angleOfRotation;

- (id)initWithFrame:(CGRect)frame	{
    self = [super initWithFrame:frame];
    if (self)	{
		[self setBackgroundColor:[UIColor clearColor]];
		color		= [UIColor colorWithRed:0.7 green:0.1 blue:0.5 alpha:1];
		peakPoint	= 1.0f;
		lowerLeft	= self.frame.size.height;
		lowerRight	= self.frame.size.width;
		lowerLeftMod = lowerRightMod = peakMod = 2.5;
		[self setUserInteractionEnabled:NO];
		angleOfRotation = 0.1;
	}
    return self;
}

- (void)drawRect:(CGRect)rect	{
	if (lowerLeft<1||lowerLeft>self.frame.size.height)
		lowerLeftMod*=-1;
	if (lowerRight<1||lowerRight>self.frame.size.width)
		lowerRightMod*=-1;
	if (peakPoint<1||peakPoint>self.frame.size.width)
		peakMod*=-1;	
	
	angleOfRotation+=0.05;
	
	[color setFill];
	
	lowerRight	+=lowerRightMod;
	lowerLeft	-=lowerLeftMod;
	peakPoint	+=peakMod;
	
	CGContextRef		ref		= UIGraphicsGetCurrentContext();
	CGMutablePathRef	path	= CGPathCreateMutable();
	CGPathMoveToPoint	(path, NULL, 0, lowerLeft);
	CGPathAddLineToPoint(path, NULL, peakPoint, 0);
	CGPathAddLineToPoint(path, NULL, lowerRight, self.frame.size.height);
	CGContextAddPath	(ref, path);
	CGContextDrawPath	(ref, kCGPathFill);
	
	[self setTransform:CGAffineTransformMakeRotation(angleOfRotation)];
}

@end
