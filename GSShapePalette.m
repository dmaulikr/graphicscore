//
//  GSShapePalette.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSShapePalette.h"

@implementation GSShapePalette
@synthesize shapes;

- (id)initWithFrame:(CGRect)frame andColorPalette:(Palette*)p	{
    self = [super initWithFrame:frame];
    if (self) {
		GSCircle			*circle = [[GSCircle alloc] initWithFrame:frame];
		[circle setLocal:p];
		
		GSQuadrilateral		*quad	= [[GSQuadrilateral alloc] initWithFrame:frame andLocal:p andIndex:2];
		
		GSStar				*star	= [[GSStar alloc] initWithFrame:frame];
		[star setLocal:p];
		
		GSTriangle			*tri	= [[GSTriangle alloc] initWithFrame:frame];
		[tri setLocal:p];
		
		shapes = [[NSArray alloc] initWithObjects:quad, circle, star, tri, nil];
    }
    return self;
}

@end
