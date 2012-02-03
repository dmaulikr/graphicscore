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
}	

@property int index;
@property Palette *local;

-(void) reset;

@end
