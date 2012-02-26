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
#import "GSShapePalette.h"
#import "CAController.h"
#import "Parameteriser.h"
#import "GSNetworkController.h"

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
	
	//	Palettes
	Palette			*userPalette;
	Palette			*remotePalette;
	
	//	Shape palette buttons
	UIButton	*selectShapeToDraw1;
	UIButton	*selectShapeToDraw2;
	UIButton	*selectShapeToDraw3;
	UIButton	*selectShapeToDraw4;
	
	//	Color palette buttons
	UIButton	*selectColorToDraw1;
	UIButton	*selectColorToDraw2;
	UIButton	*selectColorToDraw3;
	UIButton	*selectColorToDraw4;
	UIButton	*selectColorToDraw5;	
	
	//	Exit
	UIButton	*exitButton;
	UIImageView	*exitButtonImage;
}

@property (strong) id delegate;
@property UIImageView *exitButtonImage;
@property Parameteriser	*parameteriser;
@property CAController* audioController;

@property NSTimer *updateRemote;
@property GSNetworkController *networkController;

@end
