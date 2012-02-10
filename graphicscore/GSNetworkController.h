//
//  GSNetworkController.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 09/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchArea.h"

@interface GSNetworkController : NSObject	<TouchAreaNetworkConnection>

-(void)submitData:(NSMutableArray*)data;
-(void)request_id;
-(void)requestUpdate;

-(id)init;

@property int session_id;

@end
