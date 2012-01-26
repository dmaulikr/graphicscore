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
@synthesize pathToDraw, points_one, points_two, points_three, points_four, points_five;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//	Configure view
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		//	Path to draw is index 0 (brown)
		pathToDraw = 0;
		
		//	Init paths
		points_one	=	[[NSMutableArray alloc]	init];
		points_two	=	[[NSMutableArray alloc]	init];	
		points_three	=	[[NSMutableArray alloc] init];
		points_four	=	[[NSMutableArray alloc] init];
		points_five	=	[[NSMutableArray alloc] init];
		
		//	Load confirmation
		NSLog(@"LOADED TOUCHPAD");
    }
    return self;
}


-(void)addTouch:(CGPoint)p	{
	NSPoint *nsp = [[NSPoint alloc] initWithCGPoint:p];
	switch (pathToDraw) {
		case 0:
			[points_one addObject:nsp];
			break;
		case 1:
			[points_two addObject:nsp];
			break;
		case 2:
			[points_three addObject:nsp];
			break;
		case 3:
			[points_four addObject:nsp];
			break;
		case 4:
			[points_five addObject:nsp];
			break;
		default:
			break;
	}	
}


-(void)processTouches:(NSSet*)touches	{
	[self setNeedsDisplay];
	UITouch *touch = [touches anyObject];
	if (touch.view==self)	{
		[self addTouch:[touch locationInView:self]];
	}
}

-(void)removeObjectsFromExistingPathArray	{
	switch (pathToDraw) {
		case 0:
			[points_one removeAllObjects];
			break;
		case 1:
			[points_two removeAllObjects];
			break;
		case 2:
			[points_three removeAllObjects];
			break;
		case 3:
			[points_four removeAllObjects];
			break;
		case 4:
			[points_five removeAllObjects];
			break;
		default:
			break;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event	{
	//	When a touch event begins, first remove all
	//	of the points currently drawn to the screen
	[self removeObjectsFromExistingPathArray];
	
	//	Then, start adding new touches
	[self processTouches:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event	{
	[self processTouches:touches];	
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event	{
	[self processTouches:touches];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event	{
	[self processTouches:touches];	
	[self performSelectorInBackground:@selector(getPointsFromCurrentDrawnLines) withObject:nil];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect	{
	/*	
			GLOBAL SETTINGS FOR ALL PATHS
	*/
	//	Get graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	//	Set line width & cap
	CGContextSetLineWidth	(context,5.0f);
	CGContextSetLineCap		(context, kCGLineCapRound);
	
	/*
			PATH ONE
	*/
	
	//	Set line color
	[[UIColor colorWithRed:0.16 green:0.09 blue:0.0 alpha:0.22]setStroke];
//	[[UIColor colorWithRed:0.16 green:0.09 blue:0.0 alpha:1]setStroke];
	//	Get path ref
	CGMutablePathRef point_one_pathref = CGPathCreateMutable();
	
	//	Get points from storage
	for (int i = 0; i < points_one.count; i++)	{
		NSPoint* p = [points_one objectAtIndex:i];
		if (i==0)	{	CGPathMoveToPoint	(point_one_pathref, NULL, p.x, p.y);	}
		else		{	CGPathAddLineToPoint(point_one_pathref, nil, p.x, p.y);	}
	}
	//	Add path to context & draw
	CGContextAddPath(context, point_one_pathref);
	CGContextDrawPath(context, kCGPathStroke);	
	
	
	/*		
			PATH TWO
	*/
	
	//	Set line color
	[[UIColor colorWithRed:0.0 green:0.282 blue:0.63 alpha:0.22]setStroke];
//	[[UIColor colorWithRed:0.0 green:0.282 blue:0.63 alpha:1]setStroke];	
	//	Get path ref
	CGMutablePathRef point_two_pathref = CGPathCreateMutable();
	
	//	Get points from storage
	for (int i = 0; i < points_two.count; i++)	{
		NSPoint* p = [points_two objectAtIndex:i];
		if (i==0)	{	CGPathMoveToPoint	(point_two_pathref, NULL, p.x, p.y);	}
		else		{	CGPathAddLineToPoint(point_two_pathref, nil, p.x, p.y);	}
	}
	//	Add path to context & draw
	CGContextAddPath(context, point_two_pathref);	
	CGContextDrawPath(context, kCGPathStroke);
	
	/*		
	 PATH THREE
	 */
	
	//	Set line color
	[[UIColor colorWithRed:0.69 green:0.41 blue:00 alpha:0.22]setStroke];
//	[[UIColor colorWithRed:0.69 green:0.41 blue:00 alpha:1]setStroke];	
	//	Get path ref
	CGMutablePathRef point_three_pathref = CGPathCreateMutable();
	
	//	Get points from storage
	for (int i = 0; i < points_three.count; i++)	{
		NSPoint* p = [points_three objectAtIndex:i];
		if (i==0)	{	CGPathMoveToPoint	(point_three_pathref, NULL, p.x, p.y);	}
		else		{	CGPathAddLineToPoint(point_three_pathref, nil, p.x, p.y);	}
	}
	//	Add path to context & draw
	CGContextAddPath(context,	point_three_pathref);	
	CGContextDrawPath(context,	kCGPathStroke);
	
	
	
	/*		
	 PATH FOUR
	 */
	
	//	Set line color
	[[UIColor colorWithRed:0.78 green:0.0 blue:0.19 alpha:0.22]setStroke];
//	[[UIColor colorWithRed:0.78 green:0.0 blue:0.19 alpha:1]setStroke];	
	//	Get path ref
	CGMutablePathRef point_four_pathref = CGPathCreateMutable();
	
	//	Get points from storage
	for (int i = 0; i < points_four.count; i++)	{
		NSPoint* p = [points_four objectAtIndex:i];
		if (i==0)	{	CGPathMoveToPoint	(point_four_pathref, NULL, p.x, p.y);	}
		else		{	CGPathAddLineToPoint(point_four_pathref, nil, p.x, p.y);	}
	}
	//	Add path to context & draw
	CGContextAddPath(context,	point_four_pathref);	
	CGContextDrawPath(context,	kCGPathStroke);
	
	
	
	/*		
	 PATH FIVE
	 */
	
	//	Set line color
	[[UIColor colorWithRed:0.17 green:0.55 blue:00 alpha:0.22]setStroke];
//	[[UIColor colorWithRed:0.17 green:0.55 blue:00 alpha:1]setStroke];	
	//	Get path ref
	CGMutablePathRef point_five_pathref = CGPathCreateMutable();
	
	//	Get points from storage
	for (int i = 0; i < points_five.count; i++)	{
		NSPoint* p = [points_five objectAtIndex:i];
		if (i==0)	{	CGPathMoveToPoint	(point_five_pathref, NULL, p.x, p.y);	}
		else		{	CGPathAddLineToPoint(point_five_pathref, nil, p.x, p.y);	}
	}
	//	Add path to context & draw
	CGContextAddPath(context,	point_five_pathref);	
	CGContextDrawPath(context,	kCGPathStroke);
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void) getPointsFromCurrentDrawnLines	{
	int num_points	= 0;
	
	//	Only process lines with > 0 points
	if (points_one.count>0)	{
		/*
		 A point is any difference between X/Y value pairs
		 greater than 
		 
		 */
		
		
		
	}
	NSLog(@"Points on line 1: %i", num_points);
	NSLog(@"Length of lint 1: %i", points_one.count);
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

@end
