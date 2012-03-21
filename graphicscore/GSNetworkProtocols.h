//
//  GSNetworkProtocols.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 06/03/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_GSNetworkProtocols_h
#define graphicscore_GSNetworkProtocols_h

/*
					**********	GSNETWORKPROTOCOLS	**********
 
 Communication between the GSNetworkController and the various drawing/processing objects
 is facilitated by a series of delegation protocols. Their definition in a separate header
 file is necessary to appease the compiler when building C/C++/Objective-C projects.
 */


/*
 GSNetworkCallbackDelegate declares that the conforming object is able to receive data which
 has been downloaded from the server in an NSArray format. This is called on the drawing class
 by the network controller when it has received updated information from the remote location.
 */
@protocol GSNetworkCallbackDelegate <NSObject>
-(void)processIncomingDataFromNetwork:(NSArray*)incoming;
@end

/*
 The Parameteriser object conforms to the TouchAreaDelegate protocol, which declares that it is
 able to receive two NSMutableArrays containing the locally drawn 'shapesOnScreen' as well as the
 remotely loaded 'shapesFromNetwork'. It returns a boolean value which is used to prevent any memory
 conflicts potentially caused by re-calling the method before the first call has been completed.
 */
@protocol TouchAreaDelegate <NSObject>
-(BOOL)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	andFromNetwork:(NSMutableArray*)n;
@end

/*
 TouchAreaNetworkConnection defines the methods required to set up a session, submit data, request data,
 and ping the server to check the connection is still available. The fetchMemberID transaction are an integral part
 of the setup process for each session, as it provides the application instance with its unique ID value,
 used to identify itself in each subsequent request/submission.
 */
@protocol TouchAreaNetworkConnection <NSObject>
-(int)fetchMemberIdForSession;
-(void)submitData:(NSMutableArray*)data;
-(void)requestData;
-(BOOL)pingServerForConnection;
@end

/*
 RemoteMonitorNetworkConnection is a stripped out version of the TouchAreNetworkConnection delegate protocol.
 As it is used by the 'listen mode', it only needs to test the connection and request data from the server.
 */

@protocol RemoteMonitorNetworkConnection <NSObject>
-(BOOL)pingServerForConnection;
-(NSMutableArray*)requestData;
@end

#endif
