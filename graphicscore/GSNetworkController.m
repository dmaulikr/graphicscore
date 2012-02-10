//
//  GSNetworkController.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 09/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "GSNetworkController.h"

@implementation GSNetworkController
@synthesize session_id, member_id;

-(id)init	{
	self = [super init];
	if (self)	{
		[self request_id];
		NSLog(@"Session ID: %i", session_id);
		NSLog(@"Member ID: %i", member_id);
	}
	return self;
}

-(NSMutableArray*)requestData	{	
	NSURL* serverAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://109.123.110.188/app/request_data.php?id=%i", session_id]];
	NSLog(@"Request from: %@", serverAddress);
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:serverAddress];
	return responseFromServer;
}

-(NSString*)URLGetStringForShape:(GSShape*)g withIndex:(int)i	{
	NSString* getString = [[NSString alloc] init];
	
	int offset = (i*10)+1;

	int index_s		=	[g shape_index];
	int originX		=	[g frame].origin.x;
	int originY		=	[g frame].origin.y;
	int width		=	[g frame].size.width;
	int height		=	[g frame].size.height;
	int index_c		=	[g index];
	int alpha		=	(int)[g alpha]*100;
	int	unique_1	=	0;
	int	unique_2	=	0;
	int	unique_3	=	0;

	//	Quadrilateral
	if (index_s==1)
		unique_1 = [(GSQuadrilateral*)g angleOfRotation]*100.0f;
	//	Triangle
	if (index_s==4)	{
		unique_1 = [(GSTriangle*)g left];
		unique_2 = [(GSTriangle*)g peak];
		unique_3 = [(GSTriangle*)g right];
	}

	
	getString = [NSString stringWithFormat:@"&%i=%i&%i=%i&%i=%i&%i=%i&%i=%i&%i=%i&%i=%i&%i=%i&%i=%i&%i=%i"
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
	
	return getString;
}

-(void)submitData:(NSMutableArray*)data	{
	NSLog(@"Submitting");
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

-(void)request_id	{
	NSLog(@"Requesting ID...");
	NSURL* id_request = [NSURL URLWithString:@"http://109.123.110.188/app/request_id.php"];
	NSMutableArray*	responseFromServer = [[NSMutableArray alloc] initWithContentsOfURL:id_request];
	
	session_id = 0;
	member_id = 0;
	
	if ([responseFromServer count]>0)	{
		session_id = [[responseFromServer objectAtIndex:0]intValue];
		member_id = [[responseFromServer objectAtIndex:1] intValue];
	}
}

-(int)fetchMemberIdForSession	{
	return member_id-1;
}

@end
