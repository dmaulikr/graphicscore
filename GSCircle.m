//
//  GSCircle.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 30/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSCircle.h"

@implementation GSCircle

- (id)initWithFrame:(CGRect)frame	{	
	self = [super initWithFrame:frame];
	if (self)	{
		label = @"Circle";
		shape_index = 2;
	}
	return self;
}

- (void)drawRect:(CGRect)rect	{
	[self setAlpha:self.alpha*0.99];
	[[[local colors] objectAtIndex:index]setFill];	
	CGContextRef ref = UIGraphicsGetCurrentContext();
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
	CGContextAddPath(ref, path);
	CGContextDrawPath(ref, kCGPathFill);
}

-(void) reset	{
	[self setAlpha:1];
}

@end



