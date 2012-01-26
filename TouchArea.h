//
//  TouchArea.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>
#import "NSPoint.h"
#import "Palette.h"

@protocol TouchAreaDelegate <NSObject>

//	DELEGATE METHODS HERE
-(void)fillWithColor:(int) i;

@end

@interface TouchArea : UIView	{
	id <TouchAreaDelegate> delegate;
	//	Path index
	int				pathToDraw;
	
	//	First path
	NSMutableArray	*points_one;
	
	//	Second path
	NSMutableArray	*points_two;
	
	//	Third path
	NSMutableArray	*points_three;
	
	//	Fourth path
	NSMutableArray	*points_four;
	
	//	Fifth
	NSMutableArray	*points_five;
	
	//	Mode (blur / paint / fill)
	NSString *mode;
	
	//	Palette (from parent)
	Palette	*palette;
}

-(void) getPointsFromCurrentDrawnLines;


@property			int	pathToDraw;
@property (strong)	NSMutableArray	*points_one;
@property (strong)	NSMutableArray	*points_two;
@property (strong)	NSMutableArray	*points_three;
@property (strong)	NSMutableArray	*points_four;
@property (strong)	NSMutableArray	*points_five;
@property (strong)	id <TouchAreaDelegate> delegate;
@property (strong)	NSString	*mode;
@property (strong)	Palette		*palette;

@end