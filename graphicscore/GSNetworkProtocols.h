//
//  GSNetworkProtocols.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 06/03/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_GSNetworkProtocols_h
#define graphicscore_GSNetworkProtocols_h

@protocol GSNetworkCallbackDelegate <NSObject>
-(void)processIncomingDataFromNetwork:(NSArray*)incoming;
@end

@protocol TouchAreaDelegate <NSObject>
-(BOOL)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	andFromNetwork:(NSMutableArray*)n;
@end

@protocol TouchAreaNetworkConnection <NSObject>
-(int)fetchMemberIdForSession;
-(void)submitData:(NSMutableArray*)data;
-(void)requestData;
-(BOOL)pingServerForConnection;
@end

@protocol RemoteMonitorDelegate <NSObject>
-(BOOL)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	andFromNetwork:(NSMutableArray*)n;
@end

@protocol RemoteMonitorNetworkConnection <NSObject>
-(BOOL)pingServerForConnection;
-(NSMutableArray*)requestData;
@end

#endif
