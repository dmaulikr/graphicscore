//
//  GSShape.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSShape.h"

@implementation GSShape
@synthesize index, local, label, shape_index, origin, isBeingDrawn;

/*
 The GSShape default [initWithFrame:] method. 
 
 All of the generic GSShape variables are overridden by
 objects inheriting from it, however they all maintain a value
 of NO for [self userInteractionEnabled].
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		label = @"Generic";
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		shape_index = 0; 
		origin = 0;	//	0 = LOCAL – 1 = REMOTE
		isBeingDrawn = NO;
    }
    return self;
}

/*
 All GSShapes have a reset method which (at least) resets the alpha
 channel to full. This can be overriden by more complex shapes.
 */

-(void) reset	{
	[self setAlpha:1.0f];
}

@end

