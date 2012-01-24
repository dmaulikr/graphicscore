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
//#import "NSPixel.h"

@protocol TouchAreaDelegate <NSObject>

//	DELEGATE METHODS HERE

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
	
	//	Playback Window
	NSMutableArray	*playbackWindowContents;
	UIView			*playbackWindow;
}
-(void)getCurrentPointsOnScreen;


@property			int	pathToDraw;
@property (strong)	NSMutableArray	*points_one;
@property (strong)	NSMutableArray	*points_two;
@property (strong)	NSMutableArray	*points_three;
@property (strong)	NSMutableArray	*points_four;
@property (strong)	NSMutableArray	*points_five;

@end