//
//  GSTriangle.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSTriangle.h"

@implementation GSTriangle
@synthesize left, right, peak, peakMod, leftMod, rightMod;

- (id)initWithFrame:(CGRect)frame	{
    self = [super initWithFrame:frame];
    if (self)	{
		label = @"Triangle";
		peak	= 1;
		left	= self.frame.size.height+1;
		right	= self.frame.size.width+1;
		
		peakMod	= 4.5;
		leftMod	= 2;
		rightMod = -1.5 ;
		shape_index = 4;
	}
    return self;
}

- (void)drawRect:(CGRect)rect	{
	if (left<-1.0f||left>self.frame.size.height)
		leftMod*=-1;
	if (right<-1.0f||right>self.frame.size.width)
		rightMod*=-1;
	if (peak<-1.0f||peak>self.frame.size.width)
		peakMod*=-1;	
	
	[self setAlpha:self.alpha*0.99];		
	[[[local colors] objectAtIndex:index]setFill];
	
	right+=rightMod;
	left +=leftMod;
	peak +=peakMod;
	
	CGContextRef		ref		= UIGraphicsGetCurrentContext();
	CGMutablePathRef	path	= CGPathCreateMutable();
	
	CGPathMoveToPoint	(path, NULL, 0,			left);
	CGPathAddLineToPoint(path, NULL, peak,		0);
	CGPathAddLineToPoint(path, NULL, right,		self.frame.size.height);
	
	CGContextAddPath	(ref, path);
	CGContextDrawPath	(ref, kCGPathFill);
}

-(void) reset	{
	[self setAlpha:1];
	[self setPeak:1.0f];
	[self setRight:self.frame.size.width];
	[self setLeft:self.frame.size.height];
}

@end
