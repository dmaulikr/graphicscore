//
//  GSCircle.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 30/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSCircle.h"

@implementation GSCircle
@synthesize color, angleOfRotation, index, local;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		color = [[UIColor alloc] init];
		[self setColor:[UIColor orangeColor]];
		//color = [UIColor colorWithRed:0.5 green:0.5 blue:0.1 alpha:1];
		angleOfRotation = 0.1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect	{
//	[color setFill];
	[[[local colors] objectAtIndex:index]setFill];	
	CGContextRef ref = UIGraphicsGetCurrentContext();
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
	CGContextAddPath(ref, path);
	CGContextDrawPath(ref, kCGPathFill);
}


@end
