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


/*
							**********	GSNETWORKCONTROLLER	**********
 The GSNetworkController registers itself as conforming to the TouchArea and RemoteMonitorNetworkConnection delegate
 protocols, as defined the the 'GSNetworkProtocols' header.
 
 The required methods are then declared below. GSNetworkController holds only two instance variables,
 containing the session and member ID values for the client.
 */
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
