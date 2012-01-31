//
//  GSCircle.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 30/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GSShapes.h"
@interface GSCircle : UIView
@property (strong) UIColor *color;
@property CGFloat angleOfRotation;
@property int index;
@property Palette *local;
@end