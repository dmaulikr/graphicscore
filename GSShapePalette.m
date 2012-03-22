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

/*
 The GSShapePalette is initialised with a Palette object, which defines the scheme
 drawn by the shapes within the GSShapePalette instance. For example, the buttons
 which are drawn at the top of the user screen are drawn from a GSShapePalette initialised
 with a Palette of black, while the shapes drawn to the screen are initialised with their
 respective player palettes (local and remote).
 */

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
