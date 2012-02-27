//
//  GSShape.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSShape.h"

@implementation GSShape
@synthesize index, local, label, shape_index, origin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		label = @"Generic";
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		shape_index = 0; 
		origin = 0;	//	0 = LOCAL – 1 = REMOTE
    }
    return self;
}

//	Overridden in subclasses
-(void) reset	{	}

@end

