//
//  GSCircle.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 30/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSCircle.h"

@implementation GSCircle

/*	
  **********	GSCIRCLE	********** 
 
 The ellipse shape (GSCircle) overrides only the 
 label and shape_index of the GSShape parent class in 
 its [initWithFrame:] method.
*/
- (id)initWithFrame:(CGRect)frame	{	
	self = [super initWithFrame:frame];
	if (self)	{
		label = @"Circle";
		shape_index = 2;
	}
	return self;
}

/*
 [drawRect:] is the Quartz/CoreGraphics rendering method, and is executed
 whenever [setNeedsDisplay] is called on a UIView subclass (such as the 
 GSShape library members).
 
 Within [drawRect:], the drawing options are set. In all GSShapes, the alpha
 value is multiplied by 0.99, creating the fade-out effect seen by the user.
 Each shape sets the fill color to the color at 'index' in the color palette 
 'local' (when the value of 'index' is changed, the color fill changes).
 
 The CoreGraphics drawing process is as follows:
	1.	Get a reference to the current graphics context (the view as it 
		appears on the screen).
	2.	Create a CGMutablePathRef to which features can be drawn.
	3.	Add features (paths, curves, points, shapes) to the PathRef
	4.	Add the path to the graphics context
	5.	Draw the context back to the screen (with options, in this case
		'CGPathFill' to create a solid shape).
 
 Where each GSShape differs is at the third point – adding features.
 
 GSCircle adds an ellipse inside a given frame; in this case the frame is set to the 
 full width and height of the GSCircle's CGRect frame.
 */

- (void)drawRect:(CGRect)rect	{
	[self setAlpha:self.alpha*0.99];
	[[[local colors] objectAtIndex:index]setFill];	
	CGContextRef ref = UIGraphicsGetCurrentContext();
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
	CGContextAddPath(ref, path);
	CGContextDrawPath(ref, kCGPathFill);
}

@end



