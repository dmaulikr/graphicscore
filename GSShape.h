//
//  GSShape.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

/*
 **********	GSSHAPE	********** 
 
 GSShape is the parent class from which the shapes themselves inherit,
 extending the generic with their own unique properties.
 
 
 The properties of all GSShape library members are:
 
 (int)index:
	Determines the color the shape will be drawn with, the index value of 
	the color palette [colors] NSArray.
 
 (Palette*)local:
	A local copy of the color palette the shape will to be drawn with. 
	When shapes are created in the GSShapePalette, they are each assigned
	a local value, either the local palette for the user's own shapes, 
	the remote palette used by the opposite player, or a palette of black
	in the case of the buttons.
 
 (NSString*)label:
	The label is used as an easy identifier as to the type of the shape.
	Rather than using a third integer index value ('shape_index' and 'index'
	are already in use), storing the label as an NSString means that it can
	be compared using the [NSString: isEqualToString:] method.
 
 (int)shape_index:
	This second index value is used to identify the shape when it is stored
	and retrieved from the database. 
 
 (int)origin:
	The 'origin' of a GSShape determines which player has drawn it; it is set
	to zero for the local player, and one for the remote player.
 
 (BOOL)isBeingDrawn:
	if ([GSShape isBeingDrawn]) {
		Don't mutate the GSShape object. This variable prevents crashes.
	}
 
 Each GSShape member has a [reset] method, which is used to restore its default
 variables every time it is to be redrawn. This is much faster and more memory 
 efficient than destroying and recreating the object.
 */


#import <UIKit/UIKit.h>
#import "Palette.h"
#import <QuartzCore/QuartzCore.h>

@interface GSShape : UIView	{
	int			index;
	Palette		*local;
	NSString	*label;
	int			shape_index;
	int			origin;
}	

@property int		index;
@property Palette	*local;
@property NSString	*label;	
@property int		shape_index;
@property int		origin;
@property BOOL		isBeingDrawn;

-(void) reset;

@end