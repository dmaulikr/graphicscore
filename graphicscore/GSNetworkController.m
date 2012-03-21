//
//  GSNetworkController.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 09/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSNetworkController.h"

@implementation GSNetworkController
@synthesize session_id, member_id, delegate;

/*
 GSNetworkController has a pair of overridden init methods. The addition to the 
 standard init method (listed first) is an automated call to 'request_id', which 
 populates the object's instance variables. 
 
 There is a second init override for the listen mode, which requests a different 
 script to be executed on the server – rather than returning the highest ID with 
 a free space, this method requests the highest ID with no spaces (as the listener
 wants to be in the audience for a full session).
 */

-(id)init	{
	self = [super init];
	if (self)	{
		[self request_id];
	}
	return self;
}

-(id)initForListener	{
	self = [super init];
	if (self)	{
		[self requestListenID];
	}
	return self;
}

/*
 The requestData method is called by objects wishing to update their shapesFromNetwork array. Once this 
 method has been called, the GSNetworkController instance will complete the transaction by updating
 its delegate with the resulting array.
 */

-(void)requestData	{	
	/*
	 The request_data script on the server requires the client to specify the session ID it wants data for,
	 and the URLRequest is therefore formatted with the local session_id variable.
	*/
	NSURL* serverAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://109.123.110.188/app/request_data.php?id=%i", session_id]];
	NSArray*	responseFromServer = [[NSArray alloc] initWithContentsOfURL:serverAddress];
	[delegate	processIncomingDataFromNetwork:responseFromServer];
}

/*
 URLGetStringForShape is used to create a correctly formatted argument string for submitting a given shape
 to the server. It is called below when the program iterates across the submitted shapes array.
 
 The index is used to format the string with the correct shape index required by the database (10* the local
 index value, to make room for the data rows). 
 */
-(NSString*)URLGetStringForShape:(GSShape*)g withIndex:(int)i	{
	NSString* getString = [[NSString alloc] init];
	
	int offset = (i*10)+1;

	/*
	 The properties of the shape are extracted and assigned to local variables.
	 These will be used to create the formatted PHP argument string. 
	 */
	int		index_s		=	[g shape_index];
	float	originX		=	[g frame].origin.x;
	float	originY		=	[g frame].origin.y;
	float	width		=	[g frame].size.width;
	float	height		=	[g frame].size.height;
	int		index_c		=	[g index];
	float	alpha		=	[g alpha];
	float	unique_1	=	0;
	float	unique_2	=	0;
	float	unique_3	=	0;

	//	The triangle has three extra properties, assigned to the 'unique' variables.
	if (index_s==4)	{
		unique_1 = [(GSTriangle*)g left];
		unique_2 = [(GSTriangle*)g peak];
		unique_3 = [(GSTriangle*)g right];
	}

	getString = [NSString stringWithFormat:@"&%i=%i&%i=%f&%i=%f&%i=%f&%i=%f&%i=%i&%i=%f&%i=%f&%i=%f&%i=%f"
				 ,offset, index_s, 
				 offset+1, originX, 
				 offset+2, originY,
				 offset+3, width,
				 offset+4, height,
				 offset+5, index_c,
				 offset+6, alpha,
				 offset+7, unique_1,
				 offset+8, unique_2,
				 offset+9, unique_3
				 ];
	
	/*
	 The string is formatted to contain the extracted data, plus the required PHP separator 
	 characters – for values of 15.4 and 23.2, for example:
	 
	 "&11=15.4&12=23.2"
	 */
	
	return getString;
}

/*
 submitData takes the data to be submitted (the shapes drawn to the screen by the user) and sends them
 to the server. Each shape is processed into a PHP argument string using the [URLGetStringForShape: atIndex:]
 method, which are concatenated and appended to the remote address of the submission script (submit.php).
 Again, session_id is used to identify the client to the server.
 
 The final submission string is used as an argument to an NSMutableURLRequest instance. Its delegate methods 
 are not implemented in this project – there is no response from the submission script.
 */
-(void)submitData:(NSMutableArray*)data	{
	NSString* URLSuffix = [NSString stringWithFormat:@"%@%@%@%@%@",
						   [self URLGetStringForShape:(GSShape*)[data objectAtIndex:((member_id-1)*5)]	withIndex:((member_id-1)*5)],
						   [self URLGetStringForShape:(GSShape*)[data objectAtIndex:((member_id-1)*5)+1]withIndex:((member_id-1)*5)+1],
						   [self URLGetStringForShape:(GSShape*)[data objectAtIndex:((member_id-1)*5)+2]withIndex:((member_id-1)*5)+2],
						   [self URLGetStringForShape:(GSShape*)[data objectAtIndex:((member_id-1)*5)+3]withIndex:((member_id-1)*5)+3],
						   [self URLGetStringForShape:(GSShape*)[data objectAtIndex:((member_id-1)*5)+4]withIndex:((member_id-1)*5)+4]
						   ];
	
	NSURL* serverAddress = [NSURL URLWithString:
							[NSString stringWithFormat:@"http://109.123.110.188/app/submit.php?id=%i%@", session_id, URLSuffix]];	
	
	NSMutableURLRequest* submit = [[NSMutableURLRequest alloc] initWithURL:serverAddress];
	NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:submit delegate:self];
	[conn start];
}

/*
 [request_id] is called during the init method for GSNetworkController. The return of the remote 'request_id' script 
 is two integer values, which are used to populate the responseFromServer NSMutableArray instance. 
 
 This array is queried for its size – if it is greater than 0, then the server can be assumed to have been reached.
 In this case, there will be two values in the returned array. If the array is of count zero, an error has occured 
 (this will trigger a dialog informing the user of an error, which is launched elsewhere).
 */

-(void)request_id	{
	NSURL* id_request = [NSURL URLWithString:@"http://109.123.110.188/app/request_id.php"];
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:id_request];
	
	session_id	= 0;
	member_id	= 0;
	
	if ([responseFromServer count]>0)	{
		session_id	= [[responseFromServer objectAtIndex:0]	intValue];
		member_id	= [[responseFromServer objectAtIndex:1] intValue];
	}
}
/*
 This is a secondary (non synthesized) getter for 'member_id', which is used where a zero-based
 value is needed, for example when addressing an array.
 */
-(int)fetchMemberIdForSession	{
	return member_id-1;
}

/*
 The ping function is used to test the connection to the server without transacting any
 data. The user is informed if the connection is dropped.
 */
-(BOOL)pingServerForConnection	{
	NSURL*		ping_request	= [NSURL URLWithString:@"http://109.123.110.188/app/ping.php"];	
	return [[NSArray arrayWithContentsOfURL:ping_request] count]>0;
}

/*
 [requestListenID] works in a similar manner to [requestID], however it calls a different script, one
 which returns the ID of the highest fully populated session.
 */
-(void)requestListenID	{
	NSURL*		listen_id_request	= [NSURL URLWithString:@"http://109.123.110.188/app/request_listen_id.php"];	
	NSArray*	response		= [NSArray arrayWithContentsOfURL:listen_id_request];
	session_id	= 0;
	if ([response count]>0)
		session_id = [[response objectAtIndex:0]intValue];
}

@end
