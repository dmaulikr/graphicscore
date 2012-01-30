//
//  GSCircle.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 30/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSCircle.h"

@implementation GSCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect	{
    // Drawing code
	[[UIColor colorWithRed:0.1 green:0.75 blue:0.75 alpha:1]setFill];
	CGContextRef ref = UIGraphicsGetCurrentContext();
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
	CGContextAddPath(ref, path);
	CGContextDrawPath(ref, kCGPathFill);
}


@end
