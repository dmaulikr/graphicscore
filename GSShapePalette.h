//
//  GSShapePalette.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 03/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "Shapes.h"
@interface	GSShapePalette : UIView
@property	NSArray*	shapes;
- (id)initWithFrame:(CGRect)frame andColorPalette:(Palette*)p;
@end
