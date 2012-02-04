//
//  GSQuadrilateral.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "Shapes.h"
@interface GSQuadrilateral : GSShape
@property CGFloat angleOfRotation;
- (id)initWithFrame:(CGRect)frame andLocal:(Palette*)l;
@end
