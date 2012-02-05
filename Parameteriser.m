//
//  Parameteriser.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "Parameteriser.h"

@implementation Parameteriser

-(id)initWithDelegate:(id)_delegate	{
	self = [super init];
	if (self)	{
		delegate = _delegate;
	}
	return self;
}

-(void)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	{
	int i = 0;
	for (GSShape* g in s)	{
		i++;
		NSLog(@"Shape %i is a %@", i, g.label);
	}
	
	NSMutableArray* parameters = [[NSMutableArray alloc] init];
	
	
	
	
	
	
	
	
	
	
	
	[delegate updatedParameters:parameters];
}

@end
