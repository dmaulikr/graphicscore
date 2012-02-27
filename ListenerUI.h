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

@interface ListenerUI : UIViewController	{
	id <ListenerUIDelegate> delegate;
}

-(id)initWithDelegate:(id)_d;

@property id <ListenerUIDelegate> delegate;

@end