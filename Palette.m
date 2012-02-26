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

+(Palette*)createPlayerOne	{
	Palette* p = [[Palette alloc] init];
	
	NSArray* local_colors = [[NSArray alloc] initWithObjects:
							 [UIColor colorWithRed:19*scale		green:231*scale		blue:64*scale alpha:0.8],
							 [UIColor colorWithRed:255*scale	green:70*scale		blue:135*scale alpha:0.8],
							 [UIColor colorWithRed:15*scale		green:173*scale		blue:247*scale alpha:0.8],
							 [UIColor colorWithRed:255*scale	green:70*scale		blue:70*scale alpha:0.8],
							 [UIColor colorWithRed:251*scale	green:214*scale		blue:9*scale alpha:0.8]							 
							 , nil];
	
	[p setColors:local_colors];
	return p;
}

+(Palette*)createPlayerTwo	{
	Palette* p = [[Palette alloc] init];
	
	NSArray* remote_colors = [[NSArray alloc] initWithObjects:
							  [UIColor colorWithRed:247*scale	green:124*scale		blue:15*scale alpha:0.8],
							  [UIColor colorWithRed:245*scale	green:247*scale		blue:15*scale alpha:0.8],
							  [UIColor colorWithRed:19*scale	green:204*scale		blue:231*scale alpha:0.8],
							  [UIColor colorWithRed:19*scale	green:231*scale		blue:129*scale alpha:0.8],
							  [UIColor colorWithRed:9*scale		green:251*scale		blue:249*scale alpha:0.8]
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
