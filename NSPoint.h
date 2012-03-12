//
//  NSPoint.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPoint : NSObject	{
	float	x;
	float	y;
	CGPoint	source;
}

-(id)initWithCGPoint:(CGPoint)p;
-(BOOL)matchesNSPoint:(NSPoint*)p;
+(NSPoint*)pointWithCGPoint:(CGPoint)p;

@property float		x;
@property float		y;
@property CGPoint	source;

@end
