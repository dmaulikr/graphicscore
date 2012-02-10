//
//  GSNetworkController.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 09/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSNetworkController.h"

@implementation GSNetworkController
@synthesize session_id;

-(id)init	{
	self = [super init];
	if (self)	{
		[self request_id];
		NSLog(@"Session ID: %i", session_id);
	}
	return self;
}

-(void)requestUpdate	{
//	NSURL* serverAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://109.123.110.188/app/submit.php?id=%i", session_id]];
	NSURL* serverAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://109.123.110.188/app/submit.php?id=%i", 0]];
	NSLog(@"Submitted request to: %@", serverAddress);
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:serverAddress];
	for (NSString* r in responseFromServer)	{
		NSLog(@"Vals: %@", r);
	}
}

-(void)submitData:(NSMutableArray*)data	{
//	NSURL* serverAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://109.123.110.188/app/submit.php?id=%i", session_id]];
	NSURL* serverAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://109.123.110.188/app/submit.php?id=%i", 0]];	
	NSLog(@"Submitted request to: %@", serverAddress);
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:serverAddress];
	for (NSString* r in responseFromServer)	{
		NSLog(@"Vals: %@", r);
	}
}

-(void)request_id	{
	NSURL* id_request = [NSURL URLWithString:@"http://109.123.110.188/app/request.php"];
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:id_request];
	
	session_id = 0;
	
	if ([responseFromServer count]>0)	{
		session_id = [[responseFromServer objectAtIndex:0]intValue];
	}
}

@end
