//
//  GSTriangle.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

/*
  **********	GSTRIANGLE	**********  
 
 GSTriangle requires six unique variables to create its
 drawing behaviours. 
 
 As the shape is drawn, its points move about its frame,
 creating different skews of triangle. This is accomplished
 by modifying the coordinates of the left, right, and peak
 points of the shape as it is being drawn.
 */

#import "Shapes.h"
@interface GSTriangle : GSShape
@property CGFloat peak;
@property CGFloat left;
@property CGFloat right;
@property CGFloat leftMod;
@property CGFloat rightMod;
@property CGFloat peakMod;
@end