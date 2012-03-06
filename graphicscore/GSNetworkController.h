//
//  GSNetworkController.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 09/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteMonitor.h"
#import "GSNetworkProtocols.h"

@interface GSNetworkController : NSObject	<TouchAreaNetworkConnection, RemoteMonitorNetworkConnection>

//	Touch area network connection methods
-(void)submitData:(NSMutableArray*)data;
-(void)requestData;
-(int)fetchMemberIdForSession;

-(void)request_id;
-(void)requestListenID;

-(id)initForListener;
-(id)init;

@property int	session_id;
@property int	member_id;
@property id	<GSNetworkCallbackDelegate> delegate;
@end
