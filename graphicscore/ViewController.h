//
//  ViewController.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserScreen.h"
#import "ListenerUI.h"

@interface ViewController : UIViewController <UserScreenDelegate, ListenerUIDelegate>	{
	UIImageView		*mainScreenBackground_ImageView;
	UIImage			*mainScreenBackground_Image;
	
	UIImageView		*logo_ImageView;
	UIImage			*logo_Image;
	
	UIButton		*startButton;
	UIButton		*listenModeButton;
}

@end
