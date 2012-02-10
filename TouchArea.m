//
//  TouchArea.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "TouchArea.h"

@implementation TouchArea
@synthesize incoming_points, shape_index, color_index, currentShape, shapePalette, member_id;

-(void) assignPalette:(Palette*)p	{
	palette = p;
	shapePalette = [[GSShapePalette alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andColorPalette:p];
	GSShape* generic = [[GSShape alloc] init];
	for (int i = 0; i < 10; i++)
		[shapesOnScreen addObject:generic];
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_d andNetworkController:(id)nc	{
    self = [super initWithFrame:frame];
    if (self) {
		network		= nc;
		delegate	= _d;
		shape_index = 0;
		color_index = 0;
		self.backgroundColor = [UIColor clearColor];
		incoming_points = [[NSMutableArray alloc] init];
		shapesOnScreen	= [[NSMutableArray alloc] initWithCapacity:10];
		currentShape = [[GSShape alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		[self addSubview:currentShape];
		member_id = [network fetchMemberIdForSession];
    }
    return self;
}


-(void)processTouches:(NSSet*)touches	{
	UITouch *touch = [touches anyObject];
	if (touch.view==self)	{
		NSPoint *pp = [[NSPoint alloc] initWithCGPoint:[touch locationInView:self]];
		[incoming_points addObject:pp];		
	}
}

-(void)touchesBegan:(NSSet*)touches		withEvent:(UIEvent*)event	{
	[incoming_points removeAllObjects];
	
	CGRect def = CGRectMake(0, 0, 0, 0);
	switch ([[[shapePalette shapes]objectAtIndex:shape_index]shape_index]) {
		case 1:	currentShape = [[GSQuadrilateral alloc] initWithFrame:def andLocal:palette]; break;
		case 2:	currentShape = [[GSCircle alloc] initWithFrame:def]; break;
		case 3:	currentShape = [[GSStar alloc] initWithFrame:def]; break;
		case 4:	currentShape = [[GSTriangle alloc] initWithFrame:def]; break;			
		default:	break;
	}
	
	[currentShape setLocal:palette];
	[currentShape setIndex:color_index];
	
	for (GSShape* k in [self subviews])	{
			if(currentShape.index==k.index)
				[k removeFromSuperview];
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
	[currentShape removeFromSuperview];	
	[shapesOnScreen replaceObjectAtIndex:color_index+(5*member_id) withObject:currentShape];
	[self addSubview:(GSShape*)[shapesOnScreen objectAtIndex:color_index+(5*member_id)]];
	[delegate touchAreaHasBeenUpatedWithShapesOnScreen:shapesOnScreen];
	
	[network submitData:shapesOnScreen];
	[self processIncomingDataFromNetwork:[network requestData]];
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
	CGFloat	height	= [[incoming objectAtIndex:offset+3]floatValue];

	CGRect	def = CGRectMake(originX, originY, width, height);

	switch (shape_id)	{
		case 1:
			g = [[GSQuadrilateral alloc]	initWithFrame:def	andLocal:palette]; 
			float angle = [[incoming objectAtIndex:7]floatValue];
			[(GSQuadrilateral*)g setAngleOfRotation:angle];
		break;

		case 2:	g = [[GSCircle alloc]			initWithFrame:def]; break;			
			
		case 3:	g = [[GSStar alloc]				initWithFrame:def]; break;
			
		case 4:	
			g = [[GSTriangle alloc]			initWithFrame:def]; 
			float l = [[incoming objectAtIndex:7]floatValue];
			float p = [[incoming objectAtIndex:8]floatValue];
			float r = [[incoming objectAtIndex:9]floatValue];
			[(GSTriangle*)g setLeft: l];
			[(GSTriangle*)g setPeak: p];
			[(GSTriangle*)g setRight:r];
		break;			
		default:	break;
	}

	g.index = [[incoming objectAtIndex:5]intValue];
	g.alpha = 0.01f * [[incoming objectAtIndex:6] floatValue];

	return g;
}


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void)processIncomingDataFromNetwork:(NSMutableArray*)incoming	{
	NSLog(@"Received data!");
	NSMutableArray*	shapesFromNetwork = [[NSMutableArray alloc] init];

	for (int i = 0; i < 10; i++)	{
		[shapesFromNetwork addObject:[self createShapeUsingParameters:incoming withIndex:i]];
	}
	
	for (GSShape* g in shapesFromNetwork)	{
		NSLog(@"%@", [g label]);
	}
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
