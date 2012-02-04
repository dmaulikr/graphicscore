//
//  GSShape.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"
#import <QuartzCore/QuartzCore.h>

@interface GSShape : UIView	{
	int			index;
	Palette		*local;
	NSString	*label;
	int			shape_index;
}	

@property int index;
@property Palette	*local;
@property NSString	*label;	
@property int shape_index;

-(void) reset;

@end