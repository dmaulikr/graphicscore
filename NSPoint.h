//
//  NSPoint.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
  **********	NSPOINT		**********
 
 NSPoint is an Objective-C wrapper for handling CoreGraphics
 CGPoint C structs.
 
 They contain three members: the x and y coordinates of the 
 point, and the original CGPoint they were created from.
 
 Additionally, NSPoint defines a class convenience method
 for creating new instances from any CGPoint, and a matching
 method, which returns the boolean result of a comparison between
 a point instance and another given point.
 */

@interface NSPoint : NSObject	{
	float	x;
	float	y;
	CGPoint	source;
}

-(id)		initWithCGPoint:	(CGPoint) p;
-(BOOL)		matchesNSPoint:		(NSPoint*)p;
+(NSPoint*)	pointWithCGPoint:	(CGPoint) p;

@property float		x;
@property float		y;
@property CGPoint	source;

@end
