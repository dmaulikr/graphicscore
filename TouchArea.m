//
//  TouchArea.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 15/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "TouchArea.h"

CGImageRef UIGetScreenImage(void);

@implementation TouchArea
@synthesize pathToDraw, points_one, points_two, points_three, points_four, points_five, mode, delegate;

-(void) assignPalette:(Palette*)p	{
	palette = p;
	[circle setLocal:palette];
	[quad	setLocal:palette];
	[tri	setLocal:palette];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//	Configure view
		self.backgroundColor = [UIColor clearColor];
		
		//	Path to draw is index 0 (brown)
		pathToDraw = 0;
		
		//	Init paths
		points_one	=	[[NSMutableArray alloc]	init];
		points_two	=	[[NSMutableArray alloc]	init];	
		points_three	=	[[NSMutableArray alloc] init];
		points_four	=	[[NSMutableArray alloc] init];
		points_five	=	[[NSMutableArray alloc] init];
	
		//	Set mode
		mode = @"Draw";
		
		//	Init GSShapes
		circle	= [[GSCircle alloc] init];
		quad	= [[GSQuadrilateral alloc] init];
		tri		= [[GSTriangle alloc] init];
		
		//	Set shape index
		[circle setIndex:0];
		[quad	setIndex:1];
		[tri	setIndex:2];
		
		//	Add to view
		[self addSubview:circle];
		[self addSubview:quad];
		[self addSubview:tri];
    }
    return self;
}


-(void)addTouch:(NSPoint*)nsp	{	
	switch (pathToDraw) {
		case 0:	[points_one		addObject:nsp];		break;
		case 1:	[points_two		addObject:nsp];		break;
		case 2:	[points_three	addObject:nsp];		break;
		case 3:	[points_four	addObject:nsp];		break;
		case 4:	[points_five	addObject:nsp];		break;
		default:	break;
	}	
}


-(void)processTouches:(NSSet*)touches	{
	[self setNeedsDisplay];
	UITouch *touch = [touches anyObject];
	if (touch.view==self)	{
		NSPoint *pp = [[NSPoint alloc] initWithCGPoint:[touch locationInView:self]];
		[self performSelectorInBackground:@selector(addTouch:) withObject:pp];
	}
}

-(void)removeObjectsFromExistingPathArray	{
	switch (pathToDraw) {
		case 0:	[points_one		removeAllObjects];		break;
		case 1:	[points_two		removeAllObjects];		break;
		case 2:	[points_three	removeAllObjects];		break;
		case 3:	[points_four	removeAllObjects];		break;
		case 4:	[points_five	removeAllObjects];		break;
		default:	break;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event	{
	if ([mode isEqualToString:@"Fill"])	{
		[delegate fillWithColor:pathToDraw];
		NSLog(@"Fill");
	}
	
	
	if ([mode isEqualToString:@"Draw"])	{
		//	When a touch event begins, first remove all
		//	of the points currently drawn to the screen
		[self removeObjectsFromExistingPathArray];

		//	Then, start adding new touches
		[self processTouches:touches];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event	{
	if ([mode isEqualToString:@"Draw"])	
		[self processTouches:touches];	
	[self performSelectorInBackground:@selector(getPointsFromCurrentDrawnLines) withObject:nil];			
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event	{
	if ([mode isEqualToString:@"Draw"])
		[self processTouches:touches];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event	{
	if ([mode isEqualToString:@"Draw"])	{
		[self processTouches:touches];	
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void) getPointsFromCurrentDrawnLines	{
	switch (pathToDraw) {
		case 0:		[self processPointsForShapeOne];	break;
		case 1:		[self processPointsForShapeTwo];	break;
		case 2:		[self processPointsForShapeThree];	break;			
		default:	break;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void) processPointsForShapeOne	{
	[circle setColor:[palette.colors objectAtIndex:0]];
	
	if (points_one.count>1)	{
		int minX, minY, maxX, maxY;
		minX = minY = 10000;
		maxX = maxY = 0;
		
		int i_max = points_one.count;
		
		for (int i = 0; i < i_max; i++)	{
			NSPoint* a = [points_one objectAtIndex:i];			
			if (a.x < minX)
				minX = a.x;
			if (a.y < minY)
				minY = a.y;
			if (a.x > maxX)
				maxX = a.x;
			if (a.y > maxY)
				maxY = a.y;
		}
		circle.frame = CGRectMake(minX, minY, maxX-minX, maxY-minY);
		[circle setAlpha:circle.alpha*0.99];
		[circle setAngleOfRotation:circle.angleOfRotation+0.05];
//		[circle setTransform:CGAffineTransformMakeRotation(circle.angleOfRotation)];				
		[circle setNeedsDisplay];
	}
	
	if (points_one.count<=5)	{
		[circle setAlpha:1];
//		[circle setTransform:CGAffineTransformMakeRotation(0)];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void) processPointsForShapeTwo	{
	UIColor* c = [palette.colors objectAtIndex:1];
	[quad setColor:c];	
	
	if (points_two.count>1)	{
		int minX, minY, maxX, maxY;
		minX = minY = 10000;
		maxX = maxY = 0;
		
		int i_max = points_two.count;
		
		for (int i = 0; i < i_max; i++)	{
			NSPoint* a = [points_two objectAtIndex:i];			
			if (a.x < minX)
				minX = a.x;
			if (a.y < minY)
				minY = a.y;
			if (a.x > maxX)
				maxX = a.x;
			if (a.y > maxY)
				maxY = a.y;
		}
		quad.frame = CGRectMake(minX, minY, maxX-minX, maxY-minY);
		[quad setAlpha:quad.alpha*0.98];
		if (quad.layer.cornerRadius<200)
			[quad.layer setCornerRadius:quad.layer.cornerRadius*1.095];
		[quad setAngleOfRotation: quad.angleOfRotation+0.05];
		[quad setTransform:CGAffineTransformMakeRotation([quad angleOfRotation])];
		[quad setNeedsDisplay];
	}
	
	if (points_two.count<=5)	{
		[quad setAlpha:1];
		[quad.layer setCornerRadius:5.0f];
		[quad setTransform:CGAffineTransformMakeRotation(0)];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void) processPointsForShapeThree	{
	[tri setColor:[palette.colors objectAtIndex:2]];	
	
	if (points_three.count>1)	{
		int minX, minY, maxX, maxY;
		minX = minY = 10000;
		maxX = maxY = 0;
		
		int i_max = points_three.count;
		
		for (int i = 0; i < i_max; i++)	{
			NSPoint* a = [points_three objectAtIndex:i];			
			if (a.x < minX)
				minX = a.x;
			if (a.y < minY)
				minY = a.y;
			if (a.x > maxX)
				maxX = a.x;
			if (a.y > maxY)
				maxY = a.y;
		}
		tri.frame = CGRectMake(minX, minY, maxX-minX, maxY-minY);
		[tri setAlpha:tri.alpha*0.99];
		[tri setNeedsDisplay];
	}
	
	if (points_three.count<=5)	{
		[tri setAlpha:1];
		[tri setPeakPoint:1.0f];
		[tri setLowerRight:tri.frame.size.width];
		[tri setLowerLeft:tri.frame.size.height];
		//[tri setTransform:CGAffineTransformMakeRotation(0)];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

@end
