//
//  Palette.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 26/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "Palette.h"

@implementation Palette
@synthesize colors;

-(id)init	{
	self = [super init];
	if (self)	{
		//	Create the possible colors
		UIColor *color1		= [UIColor colorWithRed:0.1 green:0.7 blue:0.9 alpha:0.8];
		UIColor *color2		= [UIColor colorWithRed:0.3 green:0.9 blue:0.1 alpha:0.8];
		UIColor *color3		= [UIColor colorWithRed:0.5 green:0.1 blue:0.3 alpha:0.8];
		UIColor *color4		= [UIColor colorWithRed:0.7 green:0.3 blue:0.5 alpha:0.8];
		UIColor *color5		= [UIColor colorWithRed:0.9 green:0.5 blue:0.7 alpha:0.8];
		UIColor *color6		= [UIColor colorWithRed:0.1 green:0.7 blue:0.9 alpha:0.8];
		UIColor *color7		= [UIColor colorWithRed:0.1 green:0.9 blue:0.1 alpha:0.8];
		UIColor *color8		= [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:0.8];
		UIColor *color9		= [UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:0.8];
		UIColor *color10	= [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:0.8];
		UIColor *color11	= [UIColor colorWithRed:0.1 green:0.7 blue:0.9 alpha:0.8];
		UIColor *color12	= [UIColor colorWithRed:0.1 green:0.9 blue:0.1 alpha:0.8];
		
		availableRangeOfColors = [NSArray arrayWithObjects:color1, color2, color3, color4, color5, color6,
								  color7, color8, color9, color10, color11, color12,nil];
		
		colors = [[NSMutableArray alloc] initWithCapacity:5];
	}
	return self;
}

-(void)create	{
	memset(colorsTaken, 0, sizeof(int)*5);
	int colorToSelect = rand()%3;
	colorsTaken[0] = colorToSelect;
	//NSLog(@"Color Added:	%i", colorToSelect);
	[colors addObject:[availableRangeOfColors objectAtIndex:colorToSelect]];
	
	colorToSelect = 2+rand()%3;
	colorsTaken[1] = colorToSelect;
	//NSLog(@"Color Added:	%i", colorToSelect);	
	[colors addObject:[availableRangeOfColors objectAtIndex:colorToSelect]];

	colorToSelect = 4+rand()%2;
	colorsTaken[2] = colorToSelect;	
//	NSLog(@"Color Added:	%i", colorToSelect);	
	[colors addObject:[availableRangeOfColors objectAtIndex:colorToSelect]];
	
	colorToSelect = 6+rand()%2;
	colorsTaken[3] = colorToSelect;	
//	NSLog(@"Color Added:	%i", colorToSelect);	
	[colors addObject:[availableRangeOfColors objectAtIndex:colorToSelect]];
	
	colorToSelect = 8+rand()%2;
	colorsTaken[4] = colorToSelect;	
	//NSLog(@"Color Added:	%i", colorToSelect);
	[colors addObject:[availableRangeOfColors objectAtIndex:colorToSelect]];
}

-(Palette*)createOpposite	{
	Palette* p = [[Palette alloc] init];
	
	for (int i = 0; i < 12; i++)	{
		for (int j = 0; j < 5; j++)	{
			if (i==colorsTaken[j])
				break;
			if (j==4)	{
				[p.colors addObject:[availableRangeOfColors objectAtIndex:i]];
//				NSLog(@"Color Opposite Added:	%i", i);
//				NSLog(@"Opposite Count: %i", [p.colors count]);
			}
		}
	}
	
	return p;
}


@end
