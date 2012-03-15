//
//  Parameteriser.mm
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "Parameteriser.h"

@implementation Parameteriser
@synthesize alpha_total, sc_red_total, sc_blue_total, sc_green_total;

-(id)initWithDelegate:(id)_delegate	{
	self = [super init];
	if (self)	{
		delegate	 = _delegate;

		sc_red_total = sc_green_total = sc_blue_total = 0.0f;
		
		numpoints		= 0;
		numshapes		= 0;
		numcurves		= 0;
		alpha_average	= 0.0f;
		
		totalEllipse	= 0;
		totalQuads		= 0;
		totalStars		= 0;
		totalTriangles	= 0;
		
		starPoints_w	= [[NSMutableArray alloc] init];	
		quadPoints_w	= [[NSMutableArray alloc] init];	
		triPoints_w		= [[NSMutableArray alloc] init];
		curves_w		= [[NSMutableArray alloc] init];
		
		starPoints_x	= [[NSMutableArray alloc] init];	
		quadPoints_x	= [[NSMutableArray alloc] init];	
		triPoints_x		= [[NSMutableArray alloc] init];
		curves_x		= [[NSMutableArray alloc] init];
		
		starPoints_y	= [[NSMutableArray alloc] init];	
		quadPoints_y	= [[NSMutableArray alloc] init];	
		triPoints_y		= [[NSMutableArray alloc] init];
		curves_y		= [[NSMutableArray alloc] init];
		
		starPoints_z	= [[NSMutableArray alloc] init];	
		quadPoints_z	= [[NSMutableArray alloc] init];	
		triPoints_z		= [[NSMutableArray alloc] init];
		curves_z		= [[NSMutableArray alloc] init];
		
		totalSize	= 0.0;	
		averageArea = 0.0;
		
		origins			= [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)addStarPointsFromArrayToParameterData:(NSArray*)a	{
	for (NSPoint* p in a)	{
		if (p.x!=0.0f)
			p.x=floorf(p.x/30);
		if (p.y<=80.0f)
			[starPoints_w addObject:p];
		if (p.y<=160.0f&&p.y>80.0f)
			[starPoints_x addObject:p];
		if (p.y<=240.0f&&p.y>160.0f)
			[starPoints_y addObject:p];
		if (p.y>240.0f)
			[starPoints_z addObject:p];
	}
}

-(void)addTrianglePointsFromArrayToParameterData:(NSArray*)a	{
	for (NSPoint* p in a)	{
		if (p.x!=0.0f)
			p.x=floorf(p.x/30);
		if (p.y<=80.0f)
			[triPoints_w addObject:p];
		if (p.y<=160.0f&&p.y>80.0f)
			[triPoints_x addObject:p];
		if (p.y<=240.0f&&p.y>160.0f)
			[triPoints_y addObject:p];
		if (p.y>240.0f)
			[triPoints_z addObject:p];
	}
}

-(void)addQuadPointsFromArrayToParameterData:(NSArray*)a	{
	for (NSPoint* p in a)	{
		if (p.x!=0.0f)
			p.x=floorf(p.x/30);
		if (p.y<=80.0f)
			[quadPoints_w addObject:p];
		if (p.y<=160.0f&&p.y>80.0f)
			[quadPoints_x addObject:p];
		if (p.y<=240.0f&&p.y>160.0f)
			[quadPoints_y addObject:p];
		if (p.y>240.0f)
			[quadPoints_z addObject:p];
	}
}

-(void)processTriangle:(GSTriangle*)t	{
	CGRect	r		= t.frame;
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;
	
	if (width>5)	{
	
		NSPoint*	left	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX, t.left)];
		NSPoint*	top		= [[NSPoint alloc] initWithCGPoint:CGPointMake(t.peak, originY)];
		NSPoint*	right	= [[NSPoint alloc] initWithCGPoint:CGPointMake(t.right, originY+height)];	
	
		const float* RGB = CGColorGetComponents([(UIColor*)[[[t local] colors] objectAtIndex:[t index]] CGColor]);
	
		alpha_total		+=	t.alpha;
		sc_red_total	+=	RGB[0];
		sc_green_total	+=	RGB[1];
		sc_blue_total	+=	RGB[2];

		NSArray*	trianglePoints = [[NSArray alloc] initWithObjects:left, top, right, nil];
	
		totalTriangles++;
	
		[self addTrianglePointsFromArrayToParameterData:trianglePoints];

		totalSize+=width;
	
		averageWidth	+=width;
		averageHeight	+=height;
	
		[origins addObject:left];
	}
}

-(void)processQuadrilateral:(GSQuadrilateral*)q	{
	CGRect	r		= q.frame;
	CGFloat	width	= r.size.width;
	CGFloat height	= r.size.height;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;	

	if (width>5)	{
		const float* RGB = CGColorGetComponents([(UIColor*)[[[q local] colors] objectAtIndex:[q index]] CGColor]);
	
		alpha_total		+=	q.alpha;
		sc_red_total	+=	RGB[0];
		sc_green_total	+=	RGB[1];
		sc_blue_total	+=	RGB[2];
	
		numpoints+=4;
	
		NSPoint* point_1 = [[NSPoint alloc] initWithCGPoint:CGPointMake(originX,		originY)];
		NSPoint* point_2 = [[NSPoint alloc] initWithCGPoint:CGPointMake(originX,		originY+height)];
		NSPoint* point_3 = [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width,	originY)];
		NSPoint* point_4 = [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width,	originY+height)];
	
		NSArray* quadPoints = [[NSArray alloc] initWithObjects:point_1, point_2, point_3, point_4, nil];
	
		[self addQuadPointsFromArrayToParameterData:quadPoints];

		totalQuads++;
	
		totalSize+=width;
	
		averageWidth	+=width;
		averageHeight	+=height;
	
		[origins addObject:[NSPoint pointWithCGPoint:CGPointMake(originX, originY)]];
	}
}


-(void)processStar:(GSStar*)s	{
	CGRect r = s.frame;
	
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;
	
	if (width > 5)	{

		NSPoint* one	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.5,	originY)];
		NSPoint* two	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.6,	originY+height*0.33)];
		NSPoint* three	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.9,	originY+height*0.33)];
		NSPoint* four	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.66,	originY+height*0.55)];
		NSPoint* five	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.75,	originY+height*0.88)];
		NSPoint* six	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.5,	originY+height*0.66)];
		NSPoint* seven	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.25,	originY+height*0.88)];
		NSPoint* eight	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.33,	originY+height*0.52)];
		NSPoint* nine	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.1,	originY+height*0.33)];
		NSPoint* ten	= [[NSPoint alloc] initWithCGPoint:CGPointMake(originX+width*0.4,	originY+height*0.33)];
	
		NSMutableArray* starPoints = [[NSMutableArray alloc] init];	
		[starPoints addObject:one];
		[starPoints addObject:two];
		[starPoints addObject:three];
		[starPoints addObject:four];
		[starPoints addObject:five];
		[starPoints addObject:six];
		[starPoints addObject:seven];
		[starPoints addObject:eight];
		[starPoints addObject:nine];
		[starPoints addObject:ten];	
	
		const float* RGB = CGColorGetComponents([(UIColor*)[[[s local] colors] objectAtIndex:[s index]] CGColor]);	
		alpha_total		+=	s.alpha;
		sc_red_total	+=	RGB[0];
		sc_green_total	+=	RGB[1];
		sc_blue_total	+=	RGB[2];		
	
		[self addStarPointsFromArrayToParameterData:starPoints];
	
		[origins addObject:nine];
	
		totalStars++;
	
		averageWidth	+=width;
		averageHeight	+=height;
	
		totalSize+=width;	
	}
}

-(void)processCircle:(GSCircle*)c	{
	CGRect	r		= c.frame;
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;

	if (width>5)	{
		const float* RGB = CGColorGetComponents([(UIColor*)[[[c local] colors] objectAtIndex:[c index]] CGColor]);
		alpha_total		+=	c.alpha;
		sc_red_total	+=	RGB[0];
		sc_green_total	+=	RGB[1];
		sc_blue_total	+=	RGB[2];
	
		for (int i = originY; i < originY+height; i++){
			NSPoint* p = [NSPoint pointWithCGPoint:CGPointMake(0.0f, 0.0f)];
			double x = .0f;
			//	Calculate curve occurrence in each frequency band
			if (i<=80)	{
				[p setX:	i];
				[p setY:	floor((80-i)/2.6)];	
				[curves_w	addObject:p];
			}
			if (i<=160&&i>80)	{
				x = i-80;
				[p setY:	floor((80-x)/2.6)];
				[curves_x	addObject:p];
			}
			if (i<=240&&i>160)	{
				x = i-160;
				[p setY:	floor((80-x)/2.6)];
				[curves_y	addObject:p];
			}
			if (i>240)	{
				x = i-240;
				[p setY:	floor((80-x)/2.6)];
				[curves_z	addObject:p];
			}
		}
	
		for (int i = originX; i < originX+width; i++)
			numcurves++;
	
		totalEllipse++;
	
		[origins addObject:[NSPoint pointWithCGPoint:CGPointMake(originX, originY)]];
	
		averageHeight	+=height;
		averageWidth	+=width;
	
		totalSize+=width;
	}
}

-(void)resetLocalVariables	{
	//	Reset values
	sc_red_total = sc_green_total = sc_blue_total = alpha_total = 0.0f;
	
	numpoints		= 0;
	numshapes		= 0;
	numcurves		= 0;
	alpha_average	= 0.0f;

	[curves_w	removeAllObjects];
	[curves_x	removeAllObjects];
	[curves_y	removeAllObjects];
	[curves_z	removeAllObjects];
	
	[starPoints_w removeAllObjects];
	[starPoints_x removeAllObjects];	
	[starPoints_y removeAllObjects];
	[starPoints_z removeAllObjects];
	
	[quadPoints_w removeAllObjects];
	[quadPoints_x removeAllObjects];
	[quadPoints_y removeAllObjects];
	[quadPoints_z removeAllObjects];
	
	[triPoints_w removeAllObjects];
	[triPoints_x removeAllObjects];
	[triPoints_y removeAllObjects];
	[triPoints_z removeAllObjects];
	
	totalSize	= 0.0;	
	averageHeight = averageWidth = averageArea = 0.0;
	
	totalStars = totalQuads = totalEllipse = totalTriangles = 0;
	
	[origins removeAllObjects];
	
	overlap = 0.0f;
}

-(double)calculateOverlapWithOrigins:(NSArray*)_origins	averageShapeWidth:(float)_averageSizeW 	andAverageShapeHeight:(float)_averageSizeH	{
	double	overlapFactor = .0f;
		
	for (int i = 0; i < [_origins count]; i++)	{
		NSPoint* p = [_origins objectAtIndex:i];		
		for (int j = i; j < [_origins count]; j++)	{
			NSPoint* o = [_origins objectAtIndex:j];

			float	overlapX = 0.0;
			float	overlapY = 0.0;

			if (![p matchesNSPoint:o])	{			
				float	lowestX		= p.x > o.x ? o.x : p.x;
				float	highestX	= p.x > o.x ? p.x : o.x;
				float	lowestY		= p.y > o.y ? o.y : p.y;
				float	highestY	= p.y > o.y ? p.y : o.y;

				float	endX		= lowestX + _averageSizeW;
				float	endY		= lowestY + _averageSizeH;

				overlapX	= 0.0f;
				overlapY	= 0.0f;

				overlapX = endX-highestX;
				overlapY = endY-highestY;

				float	overlapArea	= 0.0f;

				if ((overlapY>0.0f)&&(overlapX>0.0f))	{
					overlapArea = overlapY*overlapX;
					overlapFactor+=(overlapArea*0.000005);
				}
			}
		}
	}
	return	overlapFactor;
}

-(BOOL)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	andFromNetwork:(NSMutableArray*)n {
	NSMutableArray* combo = [[NSMutableArray alloc] init];
	
	[combo addObjectsFromArray:s];
	[combo addObjectsFromArray:n];

	for (GSShape* g in combo)	{		
		switch (g.shape_index) {
			case 0:		break;	//GSShape generic id
			case 1:		[self processQuadrilateral:(GSQuadrilateral*)g];	break;
			case 2:		[self processCircle:(GSCircle*)g];					break;
			case 3:		[self processStar:(GSStar*)g];						break;
			case 4:		[self processTriangle:(GSTriangle*)g];				break;
			default:	break;
		}
		if (g.frame.size.width>1&&![[g label] isEqualToString:@"Generic"])
			numshapes++;
	}

	//	Prevent /0 error
	if (numshapes!=0)	{
		alpha_average	= alpha_total/numshapes;
		averageHeight	= averageHeight/numshapes;
		averageWidth	= averageWidth/numshapes;
	}
	
	//	CALCULATE BUSY-NESS/OVERLAP USING DIFF BETWEEN ORIGINS + AVERAGE SIZE 
	overlap = [self calculateOverlapWithOrigins:origins averageShapeWidth:averageWidth andAverageShapeHeight:averageHeight];
	
	//	Overall
	NSNumber	*NSNumShapes	= [[NSNumber alloc] initWithInt:numshapes];
	NSNumber	*NSNumQuads		= [[NSNumber alloc] initWithInt:totalQuads];
	NSNumber	*NSNumStars		= [[NSNumber alloc] initWithInt:totalStars];
	NSNumber	*NSNumEllipses	= [[NSNumber alloc] initWithInt:totalEllipse];
	NSNumber	*NSNumTriangles	= [[NSNumber alloc] initWithInt:totalTriangles];	
	
	//	Alpha stats
	NSNumber	*NSAlphaAverage = [[NSNumber alloc] initWithFloat:alpha_average];
	
	//	Colors
	NSNumber	*NSTotalR		= [[NSNumber alloc] initWithFloat:sc_red_total];
	NSNumber	*NSTotalG		= [[NSNumber alloc] initWithFloat:sc_green_total];
	NSNumber	*NSTotalB		= [[NSNumber alloc] initWithFloat:sc_blue_total];	
	
	averageArea = averageHeight*averageWidth;
	NSNumber	*NSOverlap		= [[NSNumber alloc] initWithFloat:overlap];
	
	NSArray		*parameters		= [NSArray arrayWithObjects: 
								//	Triggers
								starPoints_w,	starPoints_x,	starPoints_y,	starPoints_z,
								triPoints_w,	triPoints_x,	triPoints_y,	triPoints_z,
								quadPoints_w,	quadPoints_x,	quadPoints_y,	quadPoints_z,
								
								//	Busy, bold
								NSOverlap,		NSAlphaAverage, 
								
								//	Soft
								curves_w,		curves_x,		curves_y,		curves_z,
								
								//	Colors
								NSTotalR, NSTotalG, NSTotalB,	
								
								//	NumShapes
								NSNumShapes, 
								
								NSNumQuads, NSNumEllipses,	NSNumStars,  NSNumTriangles,
								nil];
	
	[delegate updatedParameters:parameters];
	
	[self resetLocalVariables];	
	return YES;
}

@end
