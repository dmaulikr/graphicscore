//
//  RemoteMonitor.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 28/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>
#import "NSPoint.h"
#import "Palette.h"
#import "Shapes.h"
#import "GSShapePalette.h"
#import "GSNetworkProtocols.h"
#import "GSNetworkController.h"

@interface RemoteMonitor : UIView <GSNetworkCallbackDelegate>	{
	//	Points incoming from user
	NSMutableArray	*incoming_points;

	//	Palette (from parent)
	Palette	*palette;
	Palette *remotePalette;

	id <TouchAreaDelegate> delegate;

	id <RemoteMonitorNetworkConnection> network;

	//	Ping
	int			pollCountdown;
	NSTimer*	pingTimer;
	
	BOOL		refreshLock;
}

- (id)	initWithFrame:(CGRect)frame andDelegate:(id)_d andNetworkController:(id)nc;

@property	int					shape_index;
@property	int					color_index;
@property	GSShapePalette		*shapePalette;
@property	NSTimer*			pingTimer;

@end