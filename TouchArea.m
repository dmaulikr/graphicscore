//
//  TouchArea.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "TouchArea.h"

@implementation TouchArea
@synthesize incoming_points, shape_index, color_index, currentShape, shapePalette, member_id, pingTimer;

-(void)callForSync	{
	[network requestData];
}

-(void)callForPing	{
	if (![network pingServerForConnection])	{
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Connection was lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alertView show];
	}
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

-(void) assignPaletteForLocal:(Palette*)p andRemote:(Palette*)r	{
	palette = p;
	remotePalette = r;
	shapePalette = [[GSShapePalette alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andColorPalette:p];
	GSShape* generic = [[GSShape alloc] init];
	[generic setOrigin:0];
	for (int i = 0; i < 10; i++)
		[shapesOnScreen addObject:generic];
	[network requestData];
	[delegate touchAreaHasBeenUpatedWithShapesOnScreen:shapesOnScreen andFromNetwork:shapesFromNetwork];
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_d andNetworkController:(id)nc	{
    self = [super initWithFrame:frame];
    if (self) {
		network		= nc;
		[(GSNetworkController*)network setDelegate: self];
		delegate	= _d;
		shape_index = 0;
		color_index = 0;
		self.backgroundColor = [UIColor clearColor];
		incoming_points = [[NSMutableArray alloc] init];
		shapesOnScreen	= [[NSMutableArray alloc] initWithCapacity:10];
		currentShape = [[GSShape alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		[self addSubview:currentShape];
		member_id = [network fetchMemberIdForSession];
		shapesFromNetwork = [[NSMutableArray alloc] initWithCapacity:10];
		pingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pollServerForUpdates) userInfo:nil repeats:YES];
		
		refreshLock = NO;
    }
    return self;
}

-(void)processTouches:(NSSet*)touches	{
	UITouch *touch = [touches anyObject];
	if (touch.view==self)	{
		[incoming_points addObject:[NSPoint pointWithCGPoint:[touch locationInView:self]]];
	}
}

-(void)touchesBegan:(NSSet*)touches		withEvent:(UIEvent*)event	{
	[incoming_points removeAllObjects];

	CGRect def = CGRectMake(0, 0, 0, 0);
	switch ([[[shapePalette shapes]objectAtIndex:shape_index]shape_index]) {
		case 1:	currentShape = [[GSQuadrilateral alloc] initWithFrame:def andLocal:palette andIndex:color_index]; break;
		case 2:	currentShape = [[GSCircle alloc]		initWithFrame:def]; break;
		case 3:	currentShape = [[GSStar alloc]			initWithFrame:def]; break;
		case 4:	currentShape = [[GSTriangle alloc]		initWithFrame:def]; break;			
		default:	break;
	}
	[currentShape setIsBeingDrawn:YES];

	[currentShape setOrigin:0];
	[currentShape setLocal:	palette];
	[currentShape setIndex:	color_index];

	for (GSShape* k in [self subviews])	{
		if((currentShape.index==k.index)&&(currentShape.origin==k.origin))	{
			[k removeFromSuperview];
		}
	}

	[self addSubview:currentShape];
	[self processTouches:touches];
}

-(void)touchesMoved:(NSSet*)touches		withEvent:(UIEvent*)event	{
	[self processTouches:touches];	
	[self performSelectorInBackground:@selector(createShapeWithUserCoordinateInput) withObject:nil];	
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event	{	[self processTouches:touches];	}

-(void)touchesEnded:(NSSet*)touches		withEvent:(UIEvent*)event	{		
	[currentShape	setIsBeingDrawn: NO];
	[currentShape	removeFromSuperview];	
	[shapesOnScreen replaceObjectAtIndex:color_index+(5*member_id) withObject:currentShape];
	[self addSubview:(GSShape*)[shapesOnScreen objectAtIndex:color_index+(5*member_id)]];
	
	BOOL parameterisationComplete = NO;
	
	while (!parameterisationComplete) {
		parameterisationComplete = [delegate touchAreaHasBeenUpatedWithShapesOnScreen:shapesOnScreen andFromNetwork:shapesFromNetwork];
	}

	[network submitData:shapesOnScreen];
	[network requestData];
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(id)createShapeUsingParameters:(NSMutableArray*)incoming withIndex:(int)index	{

	GSShape* g = [[GSShape alloc] init];

	int offset = 10 * index;

	int shape_id = [[incoming objectAtIndex:offset]intValue];
	
	CGFloat originX = [[incoming objectAtIndex:offset+1]floatValue];
	CGFloat originY = [[incoming objectAtIndex:offset+2]floatValue];

	CGFloat	width	= [[incoming objectAtIndex:offset+3]floatValue];
	CGFloat	height	= [[incoming objectAtIndex:offset+4]floatValue];

	CGRect	def = CGRectMake(originX, originY, width, height);

	switch (shape_id)	{
		case 1:
			g = [[GSQuadrilateral alloc]	initWithFrame:def	andLocal:remotePalette andIndex:[[incoming objectAtIndex:offset+5]intValue]]; 
			[g setLocal:remotePalette];	
			[g setOrigin:1];
			g.index = [[incoming objectAtIndex:offset+5]intValue];
			g.alpha = [[incoming objectAtIndex:offset+6]floatValue];
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
	return g;
}


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void)processIncomingDataFromNetwork:(NSMutableArray*)incoming	{
	int start = 0;
	start = member_id == 1 ? 0 : 5;
	if (!refreshLock)	{
		refreshLock = YES;
		
		//	Populate with generics
		GSShape* generic = [[GSShape alloc] init];	
		[shapesFromNetwork removeAllObjects];		
		for (int i = 0; i < 10; i++)
			[shapesFromNetwork addObject:generic];


		for (int i = start; i < start+5; i++)	{
			[shapesFromNetwork replaceObjectAtIndex:i withObject:
			[self createShapeUsingParameters:incoming withIndex:i]];
			[shapesOnScreen replaceObjectAtIndex:i withObject:[shapesFromNetwork objectAtIndex:i]];			
		}
		
		for (GSShape* k in [self subviews])	{					
			if (![k isBeingDrawn])	{
				[k removeFromSuperview];
			}
		}
		
		for (GSShape* k in shapesOnScreen)	{
			[self addSubview:k];
		}

		refreshLock = NO;
	}
	[delegate touchAreaHasBeenUpatedWithShapesOnScreen:shapesOnScreen andFromNetwork:shapesFromNetwork];	
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void)createShapeWithUserCoordinateInput	{	
	if (incoming_points.count>5)	{
		int minX, minY, maxX, maxY;
		minX = minY = 10000;
		maxX = maxY = 0;
		int i_max = incoming_points.count;
		for (int i = 0; i < i_max; i++)	{
			NSPoint* a = [incoming_points objectAtIndex:i];			
			if (a.x < minX)
				minX = a.x;
			if (a.y < minY)
				minY = a.y;
			if (a.x > maxX)
				maxX = a.x;
			if (a.y > maxY)
				maxY = a.y;
		}
		[currentShape setFrame:CGRectMake(minX, minY, maxX-minX, maxY-minY)];
		[currentShape setNeedsDisplay];
	}
	else
		[currentShape reset];
}

@end
