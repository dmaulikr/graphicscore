//
//  GSQuadrilateral.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSQuadrilateral.h"

@implementation GSQuadrilateral

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

-(void)drawRect:(CGRect)rect	{
	[self setBackgroundColor:[[local colors] objectAtIndex:index]];	
	[self setAlpha:self.alpha*0.98];
}

-(void) reset	{	[self setAlpha:1];	}

@end