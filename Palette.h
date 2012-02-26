//
//  Palette.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 26/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Palette : NSObject
@property NSArray *colors;
+(Palette*)createPlayerOne;
+(Palette*)createPlayerTwo;
+(Palette*)createBlack;
@end
