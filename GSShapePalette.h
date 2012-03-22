//
//  GSShapePalette.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//
/*
 **********	GSShapePallete	**********
 
 The shape palette holds an NSArray (shapes) which contains instances
 of each of the shapes in the GSShape library. The GSShapePalette can be 
 assigned a 'Palette' object in its [init] method, which defines the colors
 of the shapes in the 'shapes' NSArray.
 
 There are several occasions where a different group of shapes needs to be
 drawn, and rather than manage individual GSShapes (individually assigning colors
 etc…), GSShapePalette allows groups of shapes to be defined and used.
 */


#import "Shapes.h"
@interface	GSShapePalette : UIView
@property	NSArray*	shapes;
- (id)initWithFrame:(CGRect)frame andColorPalette:(Palette*)p;
@end
