//
//  UserScreen.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchArea.h"
#import "Palette.h"
#import <QuartzCore/QuartzCore.h>

@protocol UserScreenDelegate <NSObject>

-(void)restoreMainScreenFromUserSession;

@end

@interface UserScreen : UIViewController <TouchAreaDelegate>	{
	//	Delegate
	id <UserScreenDelegate> delegate;
	
	//	Backround image setup
	UIImageView	*userBackground_imageView;
	UIImage		*userBackground_image;
	
	
	//	Touch control area
	TouchArea	*touchpad;
	
	//	Palette
	Palette		*userPalette;
	Palette		*remotePalette;
	
	//	Palette buttons
	UIButton	*selectColor1;
	UIButton	*selectColor2;
	UIButton	*selectColor3;
	UIButton	*selectColor4;
	UIButton	*selectColor5;
	
	//	Exit
	UIButton	*exitButton;
	
	//	Mode selection
	UIButton	*selectDrawMode;
	UIButton	*selectFillMode;
}

@property (strong) id delegate;

@end
