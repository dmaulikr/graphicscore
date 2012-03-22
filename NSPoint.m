//
//  NSPoint.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "NSPoint.h"

@implementation NSPoint
@synthesize x, y, source;

/*
 The NSPoint [init] override defines the instance variables
 for x, y, and the original CGPoint.
 */

-(id)initWithCGPoint:(CGPoint)p	{
	self = [super init];
	if	(self)	{
		x		=	p.x;
		y		=	p.y;
		source	=	p;
	}
	return self;
}

/*
 [matchesNSPoint:] returns the boolean result of a comparison between
 a point instance and another given point.
 */

-(BOOL)matchesNSPoint:(NSPoint *)p	{
	return (p.x==x&&p.y==y);
}

/*
 [NSPoint pointWithCGPoint:] is a convenience method for creating, initialising,
 and defining an NSPoint using a given CGPoint struct.
 */

+(NSPoint*)pointWithCGPoint:(CGPoint)p	{
	NSPoint* nsp = [[NSPoint alloc] initWithCGPoint:p];
	return nsp;
}

@end
