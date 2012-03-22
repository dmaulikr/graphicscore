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

/*
 **********	GSTRIANGLE	**********  

 The GSTriangle [initWithFrame:] method sets the common
 GSShape variables (shape_index, label), and also the 
 unique values used in the drawing of a triangle declared
 in its header.
 */

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
 
 GSTriangle has two stages to its [drawRect:] override. The first is the 
 left/right/peakMod values, which move the points as drawing occurs.
 
 -'left' moves vertically along the left side of the frame
 -'right' moves horizontally along the bottom side of the frame
 -'peak' moves horizontally along the top of edge of the frame
 
 This is accomplished by adding to each value its 'mod'. When the point
 reaches a corner, the 'mod' value is inverted, so it begins moving to the
 other side of the frame.
 
 Secondly, the drawing itself. This is accomplished by specifying a point of 
 origin, the left, adding a line to another point, the peak, and another line
 from the peak to the right point. This draws the outline of a 'bottomless'
 triangle. To finish the triangle, the 'kCGPathFill' method is used when the 
 path is drawn to the graphics context, filling the space 'within' the path border.
 */


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

/*
 The [reset] method for GSTriangle sets the peak, left, and right values 
 back to their original positions within the shape frame.
 */

-(void) reset	{
	[self setAlpha:1];
	[self setPeak:1.0f];
	[self setRight:self.frame.size.width];
	[self setLeft:self.frame.size.height];
}

@end
