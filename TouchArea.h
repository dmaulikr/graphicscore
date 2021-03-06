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
#import "Shapes.h"
#import "GSShapePalette.h"
#import "GSNetworkController.h"


@interface TouchArea : UIView <GSNetworkCallbackDelegate, UIAlertViewDelegate>	{
	//	Points incoming from user
	NSMutableArray	*incoming_points;
	
	//	Palette (from parent)
	Palette	*palette;
	Palette *remotePalette;
	
	//	Track shapes on screen
	NSMutableArray	*shapesOnScreen;	
	
	//	Receive from the network
	NSMutableArray*	shapesFromNetwork;
	
	id <TouchAreaDelegate> delegate;
	
	id <TouchAreaNetworkConnection> network;
	
	//	Ping
	int	pollCountdown;
	NSTimer* pingTimer;
	
	BOOL refreshLock;
}

- (id)	initWithFrame:(CGRect)frame andDelegate:(id)_d andNetworkController:(id)nc;
- (void)assignPaletteForLocal:(Palette*)p andRemote:(Palette*)r;


@property	NSMutableArray		*incoming_points;
@property	int					shape_index;
@property	int					color_index;
@property	GSShape				*currentShape;
@property	GSShapePalette		*shapePalette;

@property	NSTimer*			pingTimer;

@property	int					member_id;

@end