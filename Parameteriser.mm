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
		
		curves_w = curves_x = curves_y = curves_z = 0;
		
		totalSize	= 0.0;	
		averageSize = 0.0;
	}
	return self;
}

-(void)addStarPointsFromArrayToParameterData:(NSArray*)a	{
	for (NSPoint* p in a)	{
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
}

-(void)processQuadrilateral:(GSQuadrilateral*)q	{
	CGRect	r		= q.frame;
	CGFloat	width	= r.size.width;
	CGFloat height	= r.size.height;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;	

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
}


-(void)processStar:(GSStar*)s	{
	CGRect r = s.frame;
	
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;

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
	
//	[self addPointsFromArrayToParameterData:starPoints];
	[self addStarPointsFromArrayToParameterData:starPoints];
	
	totalStars++;
	
	totalSize+=width;	
}

-(void)processCircle:(GSCircle*)c	{
	CGRect	r		= c.frame;
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;

	const float* RGB = CGColorGetComponents([(UIColor*)[[[c local] colors] objectAtIndex:[c index]] CGColor]);
	alpha_total		+=	c.alpha;
	sc_red_total	+=	RGB[0];
	sc_green_total	+=	RGB[1];
	sc_blue_total	+=	RGB[2];
	
	for (int i = originY; i < originY+height; i++){
		//	Calculate curve occurrence in each frequency band
		if (i<=80)
			[curves_w addObject:[NSNumber numberWithInt:i]];
		if (i<=160&&i>80)
			[curves_x addObject:[NSNumber numberWithInt:i]];
		if (i<=240&&i>160)
			[curves_y addObject:[NSNumber numberWithInt:i]];
		if (i>240)
			[curves_z addObject:[NSNumber numberWithInt:i]];
	}
	
	for (int i = originX; i < originX+width; i++)
		numcurves++;
	
	totalEllipse++;
	
	totalSize+=width;
}

-(void)resetLocalVariables	{
	//	Reset values
	sc_red_total = sc_green_total = sc_blue_total = alpha_total = 0.0f;
	
	numpoints		= 0;
	numshapes		= 0;
	numcurves		= 0;
	alpha_average	= 0.0f;
	
	curves_w = curves_x = curves_y = curves_z = 0;	
	
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
	averageSize = 0.0;
	
	totalStars = totalQuads = totalEllipse = totalTriangles = 0;
}

-(BOOL)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	andFromNetwork:(NSMutableArray*)n {
	NSMutableArray* combo = [[NSMutableArray alloc] init];
	
	[combo addObjectsFromArray:s];
	[combo addObjectsFromArray:n];

	for (GSShape* g in combo)	{		
		switch (g.shape_index) {
			case 0:		break;	//GSShape generic id
			case 1:		[self processQuadrilateral:(GSQuadrilateral*)g];	numshapes++;	break;
			case 2:		[self processCircle:(GSCircle*)g];					numshapes++;	break;
			case 3:		[self processStar:(GSStar*)g];						numshapes++;	break;
			case 4:		[self processTriangle:(GSTriangle*)g];				numshapes++;	break;
			default:	break;
		}
	}

	//	Prevent /0 error
	if (numshapes!=0)
		alpha_average = alpha_total/numshapes;
	
	//	Overall
	NSNumber	*NSNumShapes	= [[NSNumber alloc] initWithInt:numshapes];
	NSNumber	*NSNumCurves	= [[NSNumber alloc] initWithInt:numcurves];
	NSNumber	*NSNumPoints	= [[NSNumber alloc] initWithInt:
								   [starPoints_w count]+[starPoints_x count]+[starPoints_y count]+[starPoints_z count]+
								   [quadPoints_w count]+[quadPoints_x count]+[quadPoints_y count]+[quadPoints_z count]+
								   [triPoints_w count] +[triPoints_x count]	+[triPoints_y count] +[triPoints_z  count]
								   ];
	
	//	Alpha stats
	NSNumber	*NSAlphaAverage = [[NSNumber alloc] initWithFloat:alpha_average];
	NSNumber	*NSAlphaTotal	= [[NSNumber alloc] initWithFloat:alpha_total];
	
	//	Segmented curves
	NSNumber	*NSNumCurves_w	= [[NSNumber alloc] initWithInt:[curves_w count]];
	NSNumber	*NSNumCurves_x	= [[NSNumber alloc] initWithInt:[curves_x count]];
	NSNumber	*NSNumCurves_y	= [[NSNumber alloc] initWithInt:[curves_y count]];
	NSNumber	*NSNumCurves_z	= [[NSNumber alloc] initWithInt:[curves_z count]];
	
	
	//	Colors
	NSNumber	*NSTotalR		= [[NSNumber alloc] initWithFloat:sc_red_total];
	NSNumber	*NSTotalG		= [[NSNumber alloc] initWithFloat:sc_red_total];
	NSNumber	*NSTotalB		= [[NSNumber alloc] initWithFloat:sc_red_total];	
	
	//	Size
	averageSize = totalSize/numshapes;
	NSNumber	*NSSizeAverage	= [[NSNumber alloc] initWithFloat:averageSize];
	NSNumber	*NSSizeTotal	= [[NSNumber alloc] initWithFloat:totalSize];
	
	//	Shape totals
	NSNumber	*NSStarTotal	= [[NSNumber alloc] initWithInt:totalStars];
	NSNumber	*NSQuadTotal	= [[NSNumber alloc] initWithInt:totalQuads];
	NSNumber	*NSTriTotal		= [[NSNumber alloc] initWithInt:totalTriangles];
	NSNumber	*NSEllipseTotal	= [[NSNumber alloc] initWithInt:totalEllipse];
	
	NSArray		*parameters	 = [NSArray arrayWithObjects: 
								starPoints_w,	starPoints_x,	starPoints_y,	starPoints_z,
								triPoints_w,	triPoints_x,	triPoints_y,	triPoints_z,
								quadPoints_w,	quadPoints_x,	quadPoints_y,	quadPoints_z, nil];
//								NSNumCurves_w, NSNumCurves_x, NSNumCurves_y, NSNumCurves_z,								
//								NSNumCurves, NSNumShapes, NSNumPoints,
//								NSAlphaAverage, NSAlphaTotal,
//								NSTotalR, NSTotalG, NSTotalB,
//								NSSizeAverage, NSSizeTotal,
//								nil];
	
	[delegate updatedParameters:parameters];
	
	[self resetLocalVariables];	
	return YES;
}

@end
