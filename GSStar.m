//
//  GSStar.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSStar.h"

@implementation GSStar

/*
 As the points of the star are specified dynamically according to the
 shape frame, only the 'shape_index' and 'label' are overridden in the 
 [initWithFrame:] method for GSStar.
 */

-(id) initWithFrame:(CGRect)frame	{
	self = [super initWithFrame:frame];
	if (self)	{
		label = @"Star";
		shape_index = 3;
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
 
 GSStar draws a 5 pointed star dynamically within a given frame. This is 
 accomplished by specifying the coordinates of each star point as relative
 to the size of the frame. 
 
 Like other GSShapes, the GSStar sets its fill color to the color at 'index'
 in its [local colors] array, and reduces the value of its alpha channel at 
 each refresh.
 
 The shape itself is defined as a series of 9 CGPoints, connected by calls to
 CGPathAddLineToPoint. The final connection is made by the use of kCGPathFill, 
 which always adds a line returning to the origin of a given path.
 */


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

@end
