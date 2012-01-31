//
//  GSQuadrilateral.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSQuadrilateral.h"

@implementation GSQuadrilateral
@synthesize color, angleOfRotation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = NO;
		self.layer.cornerRadius = 15.0f;
		color = [UIColor colorWithRed:0.8 green:0.4 blue:0.0 alpha:1];
		[self setBackgroundColor:color];
		angleOfRotation=1;
    }
    return self;
}

@end