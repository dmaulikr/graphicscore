//
//  Palette.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 26/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "Palette.h"

#define scale 0.00392156862745

@implementation Palette
@synthesize colors;
/*
 **********	PALETTE	**********
 
 Each Palette instance contains a set of colors, which are used to
 set the drawing colors for GSShapes. 
 
 The Palette itself has only one member – an NSArray of UIColor 
 objects – and the Palette class provides three class convenience
 methods for creating the different types of palette used in the 
 application: 
 
 - Player one
 - Player two
 - Black (used for drawing the shape selection buttons)

 The colors are defined in RGB (0-255), and then scaled to match the 
 0.0-1.0 floating point UIColor scale. 
 */

+(Palette*)createPlayerOne	{
	Palette* p = [[Palette alloc] init];
	
	NSArray* local_colors = [[NSArray alloc] initWithObjects:
							 [UIColor colorWithRed:0*scale		green:100*scale		blue:255*scale	alpha:1.0],
							 [UIColor colorWithRed:100*scale	green:255*scale		blue:50*scale	alpha:1.0],
							 [UIColor colorWithRed:255*scale	green:0*scale		blue:50*scale	alpha:1.0],
							 [UIColor colorWithRed:0*scale		green:200*scale		blue:100*scale	alpha:1.0],
							 [UIColor colorWithRed:255*scale	green:100*scale		blue:0*scale	alpha:1.0]	 
							 , nil];
	
	[p setColors:local_colors];
	return p;
}

+(Palette*)createPlayerTwo	{
	Palette* p = [[Palette alloc] init];
	
	NSArray* remote_colors = [[NSArray alloc] initWithObjects:
							  [UIColor colorWithRed:0*scale		green:255*scale		blue:50*scale	alpha:1.0],
							  [UIColor colorWithRed:0*scale		green:100*scale		blue:255*scale	alpha:1.0],
							  [UIColor colorWithRed:255*scale	green:100*scale		blue:50*scale	alpha:1.0],
							  [UIColor colorWithRed:100*scale	green:0*scale		blue:100*scale	alpha:1.0],
							  [UIColor colorWithRed:240*scale	green:0*scale		blue:0*scale	alpha:1.0]
							  , nil];
							  
	[p setColors:remote_colors];
	return p;
}

+(Palette*)createBlack	{
	Palette* p = [[Palette alloc] init];
	
	NSArray* blacks = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor blackColor],[UIColor blackColor],
					   [UIColor blackColor],[UIColor blackColor],nil];
	
	[p setColors:blacks];
	
	return p;
}



@end
