//
//  UserScreen.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchArea.h"
#import <QuartzCore/QuartzCore.h>

@protocol UserScreenDelegate <NSObject>

-(void)restoreMainScreenFromUserSession;

@end

@interface UserScreen : UIViewController	{
	//	Delegate
	id <UserScreenDelegate> delegate;
	
	
	//	Backround image setup
	UIImageView	*userBackground_imageView;
	UIImage		*userBackground_image;
	
	
	//	Touch control area
	TouchArea	*touchpad;
	
	
	//	Palette buttons
	UIButton	*selectBrown;
	UIButton	*selectBlue;
	UIButton	*selectYellow;
	UIButton	*selectRed;
	UIButton	*selectGreen;
	
	//	Exit
	UIButton	*exitButton;
	
}

@property (strong) id delegate;

@end
