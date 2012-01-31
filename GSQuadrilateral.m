//
//  GSQuadrilateral.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSQuadrilateral.h"

@implementation GSQuadrilateral
@synthesize color, angleOfRotation, index, local;

- (id)initWithFrame:(CGRect)frame	{
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = NO;
		self.layer.cornerRadius = 15.0f;
		color = [[UIColor alloc] init];
		[self setColor:[UIColor blueColor]];
		[self setBackgroundColor:color];
		angleOfRotation=1;
    }
    return self;
}

-(void)drawRect:(CGRect)rect	{
	//[[[local colors] objectAtIndex:index]setFill];
	[self setBackgroundColor:[[local colors] objectAtIndex:index]];
}

@end