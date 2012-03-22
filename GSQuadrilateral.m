//
//  GSQuadrilateral.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSQuadrilateral.h"

@implementation GSQuadrilateral

/*
  **********	GSQUADRILATERAL		**********  
 
 Because GSQuadrilateral uses a different approach to drawing than the 
 other GSShapes, its Palette and index variables must be set in the init
 method. Without this, the first frame will be drawn with a black fill, which
 creates a poor presentation to the user.
 */

- (id)initWithFrame:(CGRect)frame andLocal:(Palette*)l andIndex:(int)_i	{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.cornerRadius = 15.0f;
		label = @"Quadrilateral";
		index = _i;
		local = l;
		[self setBackgroundColor:[[local colors] objectAtIndex:index]];
		shape_index = 1;
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
 
 GSQuadrilateral does not need to use direct CoreGraphics calls like the other
 GSShapes, as it simply fills its frame with color. Because of this, the 
 convenience method [setBackgroundColor:] can be used.
 */


-(void)drawRect:(CGRect)rect	{
	[self setBackgroundColor:[[local colors] objectAtIndex:index]];	
	[self setAlpha:self.alpha*0.99];
}
@end