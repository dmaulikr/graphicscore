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

@protocol TouchAreaDelegate <NSObject>
-(void)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s;
@end

@protocol TouchAreaNetworkConnection <NSObject>
-(int)fetchMemberIdForSession;
-(void)submitData:(NSMutableArray*)data;
-(NSMutableArray*)requestData;
@end

@interface TouchArea : UIView	{
	//	Points incoming from user
	NSMutableArray	*incoming_points;
	
	//	Palette (from parent)
	Palette	*palette;
	
	//	Track shapes on screen
	NSMutableArray	*shapesOnScreen;	
	
	id <TouchAreaDelegate> delegate;
	
	id <TouchAreaNetworkConnection> network;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_d andNetworkController:(id)nc;

-(void) assignPalette:(Palette*)p;

@property	NSMutableArray		*incoming_points;
@property	int					shape_index;
@property	int					color_index;
@property	GSShape				*currentShape;
@property	GSShapePalette		*shapePalette;

@property	int					member_id;

@end