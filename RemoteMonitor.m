//
//  RemoteMonitor.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 28/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "RemoteMonitor.h"

@implementation RemoteMonitor
@synthesize shape_index, color_index, shapePalette, pingTimer;

-(void)callForSync	{
	[self processIncomingDataFromNetwork:[network requestData]];
	pollCountdown = 0;	
}

-(void)callForPing	{
	if ([network pingServerForConnection])
		NSLog(@"Connection confirmed");
	else
		NSLog(@"Connection broken");
}

-(void)pollServerForUpdates	{
	if (pollCountdown==0)
		[self performSelectorInBackground:@selector(callForPing) withObject:nil];

	pollCountdown++;

	if (pollCountdown>=2)
		[self performSelectorInBackground:@selector(callForSync) withObject:nil];
}

////////////////////////////////////
////////////////////////////////////

-(void)fadeElementsFromScreen	{
	for (GSShape* g in [self subviews])	{
		g.alpha = [g alpha]*0.999;
		if (g.alpha<0.01)
			[g removeFromSuperview];
	}
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_d andNetworkController:(id)nc	{
    self = [super initWithFrame:frame];
    if (self) {
		delegate	= _d;
		network		= nc;
		
//		[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(fadeElementsFromScreen) userInfo:nil repeats:YES];
		
		//	Ping
		pollCountdown = 0;
		pingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pollServerForUpdates) userInfo:nil repeats:YES];
		NSLog(@"RemoteMonitor loaded");
		
		palette			= [Palette createPlayerOne];
		remotePalette	= [Palette createPlayerTwo];
		
		refreshLock = NO;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(id)createShapeUsingParameters:(NSMutableArray*)incoming withIndex:(int)index andOrigin:(int)o	{
	GSShape* g = [[GSShape alloc] init];
	
	int offset = 10 * index;
	
	int shape_id = [[incoming objectAtIndex:offset]intValue];
	
	CGFloat originX = [[incoming objectAtIndex:offset+1]floatValue];
	CGFloat originY = [[incoming objectAtIndex:offset+2]floatValue];
	
	CGFloat	width	= [[incoming objectAtIndex:offset+3]floatValue];
	CGFloat	height	= [[incoming objectAtIndex:offset+4]floatValue];
	
	CGRect	def = CGRectMake(originX, originY, width, height);
	
//	switch (shape_id)	{
//		case 1:
//			g = [[GSQuadrilateral alloc]	initWithFrame:def	andLocal:remotePalette]; 
//			float angle = [[incoming objectAtIndex:offset+7]floatValue];
//			[(GSQuadrilateral*)g setAngleOfRotation:angle];
//			break;
//			
//		case 2:	g = [[GSCircle alloc]			initWithFrame:def]; break;			
//			
//		case 3:	g = [[GSStar alloc]				initWithFrame:def]; break;
//			
//		case 4:	
//			g = [[GSTriangle alloc]			initWithFrame:def]; 
//			float l = [[incoming objectAtIndex:offset+7]floatValue];
//			float p = [[incoming objectAtIndex:offset+8]floatValue];
//			float r = [[incoming objectAtIndex:offset+9]floatValue];
//			[(GSTriangle*)g setLeft: l];
//			[(GSTriangle*)g setPeak: p];
//			[(GSTriangle*)g setRight:r];
//			break;			
//		default:	break;
//	}
	switch (shape_id)	{
		case 1:
			g = [[GSQuadrilateral alloc]	initWithFrame:def	andLocal:remotePalette andIndex:[[incoming objectAtIndex:offset+5]intValue]]; 
			[g setLocal:remotePalette];	
			[g setOrigin:1];
			g.index = [[incoming objectAtIndex:offset+5]intValue];
			g.alpha = [[incoming objectAtIndex:offset+6]floatValue];
			//			float angle = [[incoming objectAtIndex:offset+7]floatValue];
			break;
			
		case 2:
			g = [[GSCircle alloc]			initWithFrame:def]; 
			[g setLocal:remotePalette];	
			[g setOrigin:1];
			g.index = [[incoming objectAtIndex:offset+5]intValue];
			g.alpha = [[incoming objectAtIndex:offset+6]floatValue];
			break;			
			
		case 3:	
			g = [[GSStar alloc]				initWithFrame:def];
			[g setLocal:remotePalette];	
			[g setOrigin:1];
			g.index = [[incoming objectAtIndex:offset+5]intValue];
			g.alpha = [[incoming objectAtIndex:offset+6]floatValue];
			break;
			
		case 4:	
			g = [[GSTriangle alloc]			initWithFrame:def]; 
			[g setLocal:remotePalette];	
			[g setOrigin:1];
			g.index = [[incoming objectAtIndex:offset+5]intValue];
			g.alpha = [[incoming objectAtIndex:offset+6]floatValue];
			float l = [[incoming objectAtIndex:offset+7]floatValue];
			float p = [[incoming objectAtIndex:offset+8]floatValue];
			float r = [[incoming objectAtIndex:offset+9]floatValue];
			[(GSTriangle*)g setLeft: l];
			[(GSTriangle*)g setPeak: p];
			[(GSTriangle*)g setRight:r];
			break;			
		default:	break;
	}

	
	
	if (o==0)
		[g setLocal:palette];	
	else
		[g setLocal:remotePalette];
	
	[g setOrigin:o];
	
	g.index = [[incoming objectAtIndex:offset+5]intValue];
	g.alpha = [[incoming objectAtIndex:offset+6]floatValue];
	
	return g;
}


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void)processIncomingDataFromNetwork:(NSMutableArray*)incoming	{
	NSLog(@"Received data!");
	
	if (!refreshLock)	{
		refreshLock = YES;
		for (GSShape* g in [self subviews])	{
			if (g.shape_index)	{
				[g removeFromSuperview];
			}
		}
		refreshLock = NO;
	}
	
	for (int i = 0; i < 5; i++)	{
		GSShape* k = [self createShapeUsingParameters:incoming withIndex:i andOrigin:0];
		[self addSubview:k];
	}
	for (int i = 5; i < 10; i++)	{
		GSShape* k = [self createShapeUsingParameters:incoming withIndex:i andOrigin:1];
		[self addSubview:k];
	}

	NSMutableArray* shapesOnScreen	= [[NSMutableArray alloc] init];	
	NSMutableArray*	dummy			= [[NSMutableArray alloc] init];
	
	if (!refreshLock)	{
		refreshLock = YES;
		for (GSShape* g in [self subviews])	{
			if (![g.label isEqualToString:@"Generic"])
				[shapesOnScreen addObject:g];
		}
		refreshLock = NO;
	}
	
	[delegate touchAreaHasBeenUpatedWithShapesOnScreen:shapesOnScreen andFromNetwork:dummy];
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////


@end
