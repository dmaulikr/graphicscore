//
//  ListenerUI.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 27/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListenerUIDelegate <NSObject>
-(void)restoreMainScreenFromUserSession;
@end

#import <UIKit/UIKit.h>
#import "TouchArea.h"
#import "Palette.h"
#import "GSShapePalette.h"
#import "CAController.h"
#import "Parameteriser.h"
#import "GSNetworkController.h"
#import "RemoteMonitor.h"

@interface ListenerUI : UIViewController	{
	//	Delegate
	id <ListenerUIDelegate> delegate;
	
	//	Backround image setup
	UIImageView	*userBackground_imageView;
	UIImage		*userBackground_image;
	
	//	Palettes
	Palette			*userPalette;
	Palette			*remotePalette;
	
	//	Exit
	UIButton	*exitButton;
	UIImageView	*exitButtonImage;
	
	RemoteMonitor* remote;
}

@property id delegate;
@property UIImageView *exitButtonImage;
@property Parameteriser	*parameteriser;
@property CAController* audioController;

@property NSTimer *updateRemote;
@property GSNetworkController *networkController;

@end
