//
//  GSQuadrilateral.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSQuadrilateral.h"

@implementation GSQuadrilateral
@synthesize angleOfRotation;

- (id)initWithFrame:(CGRect)frame andLocal:(Palette*)l	{
    self = [super initWithFrame:frame];
    if (self) {
//		self.layer.cornerRadius = 15.0f;
		label = @"Quadrilateral";
		index = 2;
		local = l;
		[self setBackgroundColor:[[local colors] objectAtIndex:index]];
		angleOfRotation=1;
		shape_index = 1;
    }
    return self;
}

-(void)drawRect:(CGRect)rect	{
		[self setBackgroundColor:[[local colors] objectAtIndex:index]];	
	[self setAlpha:self.alpha*0.98];
//	if (self.layer.cornerRadius<200)
//		[self.layer setCornerRadius:self.layer.cornerRadius*1.095];
	[self setAngleOfRotation: self.angleOfRotation+0.05];
	[self setTransform:CGAffineTransformMakeRotation([self angleOfRotation])];
}

-(void) reset	{
	[self setAlpha:1];
//	[self.layer setCornerRadius:5.0f];
	[self setTransform:CGAffineTransformMakeRotation(0)];
}

@end