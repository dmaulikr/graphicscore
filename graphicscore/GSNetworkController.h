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

//	Touch area network connection methods
-(void)submitData:(NSMutableArray*)data;
-(NSMutableArray*)requestData;
-(int)fetchMemberIdForSession;

-(void)request_id;

-(id)init;

@property int	session_id;
@property int	member_id;

@end
