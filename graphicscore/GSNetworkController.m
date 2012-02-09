//
//  GSNetworkController.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 09/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSNetworkController.h"

@implementation GSNetworkController

-(void)ping	{
	NSURL* serverAddress = [NSURL URLWithString:@"http://109.123.110.188/app/submit.php"];
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:serverAddress];
	for (NSString* r in responseFromServer)	{
		NSLog(@"Vals: %@", r);
	}
}

@end
