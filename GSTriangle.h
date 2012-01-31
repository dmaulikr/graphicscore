//
//  GSTriangle.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 31/01/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSTriangle : UIView	{
	CGFloat lowerLeftMod, 
			lowerRightMod, 
			peakMod;
}
@property (strong) UIColor *color;
@property CGFloat peakPoint;
@property CGFloat lowerLeft;
@property CGFloat lowerRight;
@property CGFloat angleOfRotation;
@end
