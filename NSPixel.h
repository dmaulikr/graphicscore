//
//  NSPixel.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 18/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPixel : NSObject

@property int r;
@property int g;
@property int b;
@property int a;

-(id)initWithRed:(int)_r Green:(int)_g Blue:(int)_b andAlpha:(int)_a;

@end
