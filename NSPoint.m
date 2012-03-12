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

-(id)initWithCGPoint:(CGPoint)p	{
	self = [super init];
	if	(self)	{
		x		=	p.x;
		y		=	p.y;
		source	=	p;
	}
	return self;
}

-(BOOL)matchesNSPoint:(NSPoint *)p	{
	return (p.x==x&&p.y==y);
}

+(NSPoint*)pointWithCGPoint:(CGPoint)p	{
	NSPoint* nsp = [[NSPoint alloc] initWithCGPoint:p];
	return nsp;
}

@end
