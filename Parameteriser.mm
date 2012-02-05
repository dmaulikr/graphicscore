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
		points		 = new float[480];
		memset(points, 0, sizeof(float)*480);
		curves		 = new float[480];
		memset(curves, 0, sizeof(float)*480);
		sc_red_total = sc_green_total = sc_blue_total = 0.0f;
		
		numpoints		= 0;
		numshapes		= 0;
		numcurves		= 0;
		alpha_average	= 0.0f;
	}
	return self;
}

-(void)printTriangle:(GSTriangle*)t	{
	CGRect	r		= t.frame;
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;
	
	CGFloat	topPointX,	 topPointY;
	CGFloat	leftPointX,	 leftPointY;
	CGFloat	rightPointX, rightPointY;
	
	leftPointX	= originX;
	leftPointY	= t.left;
	
	topPointX	= t.peak;
	topPointY	= originY;
	
	rightPointX	= t.right;
	rightPointY	= originY + height;
	
	const float* RGB = CGColorGetComponents([(UIColor*)[[[t local] colors] objectAtIndex:[t index]] CGColor]);
	
	NSLog(@"%@: \n"
		  "The size is			(%f * %f)	\n"
		  "and it starts at		(%f , %f)	\n"
		  "The points are at: \n"
		  "(%f, %f) \n"
		  "(%f, %f) \n"
		  "(%f, %f)	\n"
		  "The alpha channel is	%f \n"
		  "and the color is %f | %f | %f \n"
		  , t.label,
		  width, height,
		  originX, originY,
		  
		  leftPointX,	leftPointY,
		  topPointX,	topPointY,
		  rightPointX,	rightPointY,
		  
		  t.alpha,
		  RGB[0], RGB[1], RGB[2]
		  );
	
	alpha_total		+=	t.alpha;
	sc_red_total	+=	RGB[0];
	sc_green_total	+=	RGB[1];
	sc_blue_total	+=	RGB[2];
	
	points	[(int)leftPointX]	= 1.0f;
	points	[(int)topPointX]	= 1.0f;
	points	[(int)rightPointX]	= 1.0f;
}

-(void)printQuadrilateral:(GSQuadrilateral*)q	{
	CGRect	r		= q.frame;
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;

	const float* RGB = CGColorGetComponents([(UIColor*)[[[q local] colors] objectAtIndex:[q index]] CGColor]);
										
	NSLog(@"%@: \n"
		  "The size is			(%f * %f)	\n"
		  "and it starts at		(%f , %f)	\n"
		  "It is rotated at %f radians \n"
		  "The alpha channel is	%f \n"
		  "and the color is %f | %f | %f \n"
		  , q.label,
		  width, height,
		  originX, originY,
		  q.angleOfRotation, 
		  q.alpha,
		  RGB[0], RGB[1], RGB[2]
		  );
	
	alpha_total		+=	q.alpha;
	sc_red_total	+=	RGB[0];
	sc_green_total	+=	RGB[1];
	sc_blue_total	+=	RGB[2];
	
	points	[(int)originX]				= 1.0f;
	points	[(int)originX+(int)width]	= 1.0f;	
}


-(void)printStar:(GSStar*)s	{
	CGRect r = s.frame;
	
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;
	CGPoint one, two, three, four, five, six, seven, eight, nine, ten;

	//	Get the points of the star
	one.x = originX+width*0.5;		one.y = originY;
	two.x = originX+width*0.6;		two.y = originY+height*0.33;
	three.x = originX+width*0.9;	three.y = originY+height*0.33;
	four.x = originX+width*0.66;	four.y = originY+height*0.55;
	five.x = originX+width*0.75;	five.y = originY+height*0.88;
	six.x = originX+width*0.5;		six.y = originY+height*0.66;	
	seven.x = originX+width*0.25;	seven.y = originY+height*0.88;		
	eight.x = originX+width*0.33;	eight.y = originY+height*0.52;
	nine.x = originX+width*0.1;		nine.y = originY+height*0.33;
	ten.x = originX+width*0.4;		ten.y = originY+height*0.33;
	
	const float* RGB = CGColorGetComponents([(UIColor*)[[[s local] colors] objectAtIndex:[s index]] CGColor]);	
	
	NSLog(@"%@:	\n"
		  "The size is		(%f * %f)	\n"
		  "and it starts at	(%f , %f)	\n"
		  "The alpha channel is %f\n"
		  "There are points at: \n"
		  "(%f, %f),\n (%f, %f),\n (%f, %f),\n (%f, %f),\n (%f, %f),\n"
		  "(%f, %f),\n (%f, %f),\n (%f, %f),\n (%f, %f),\n (%f, %f)\n"
		  "The color is %f | %f | %f\n"
		  "\n\n"
		  , s.label, width, height, 
		  originX, originY, s.alpha,
		  one.x, one.y, two.x, two.y,
		  three.x, three.y, four.x, four.y,
		  five.x, five.y, six.x, six.y,
		  seven.x, seven.y, eight.x, eight.y,
		  nine.x, nine.y, ten.x, ten.y,
		  RGB[0], RGB[1], RGB[2]		  
		  );
	alpha_total		+=	s.alpha;
	sc_red_total	+=	RGB[0];
	sc_green_total	+=	RGB[1];
	sc_blue_total	+=	RGB[2];		
	
	points [(int)one.x]		= 1;
	points [(int)two.x]		= 1;	
	points [(int)three.x]	= 1;
	points [(int)four.x]	= 1;
	points [(int)five.x]	= 1;
	points [(int)six.x]		= 1;
	points [(int)seven.x]	= 1;
	points [(int)eight.x]	= 1;
	points [(int)nine.x]	= 1;
	points [(int)ten.x]		= 1;	
}

-(void)printCircle:(GSCircle*)c	{
	CGRect	r		= c.frame;
	CGFloat	height	= r.size.height;
	CGFloat	width	= r.size.width;
	CGFloat	originX = r.origin.x;
	CGFloat	originY = r.origin.y;

	const float* RGB = CGColorGetComponents([(UIColor*)[[[c local] colors] objectAtIndex:[c index]] CGColor]);
	
	NSLog(@"%@: \n"
		  "The size is			(%f * %f)	\n"
		  "and it starts at		(%f , %f)	\n"
		  "The alpha channel is	%f \n"
		  "and the color is %f | %f | %f \n"
		  , c.label,
		  width, height,
		  originX, originY,
		  c.alpha,
		  RGB[0], RGB[1], RGB[2]
		  );
	alpha_total		+=	c.alpha;
	sc_red_total	+=	RGB[0];
	sc_green_total	+=	RGB[1];
	sc_blue_total	+=	RGB[2];
	
	int		j	= (int)width  * 0.5;
	int		k	= (int)height * 0.5;
	float	inc	= 2.0f / (float)j;
	
	for (int i = 0; i < k; i++)	{
		curves	[i+(int)originX] = i * inc;
		curves	[((int)width+(int)originX)-i] = i * inc;
		numcurves++;
	}
}

-(void)touchAreaHasBeenUpatedWithShapesOnScreen:(NSMutableArray*)s	{
	for (GSShape* g in s)	{
		switch (g.shape_index) {
			case 0:		break;
			case 1:		[self printQuadrilateral:(GSQuadrilateral*)g];	numshapes++;	break;
			case 2:		[self printCircle:(GSCircle*)g];				numshapes++;	break;
			case 3:		[self printStar:(GSStar*)g];					numshapes++;	break;
			case 4:		[self printTriangle:(GSTriangle*)g];			numshapes++;	break;
			default:	break;
		}
	}
	
	for (int i = 0; i < 480; i++)	{
		if (points[i]>0.0f)	{
			NSLog(@"Points at %i:		%f", i, points[i]);
			numpoints++;
		}
	}
	
	NSLog(@"There are %i points and %i shapes", numpoints, numshapes);
	
	NSLog(@"There are %i curves", numcurves);	
	
	NSLog(@"\nColor totals for		R:	%f		G:	%f		B:	%f		A:	%f", sc_red_total, sc_green_total, sc_blue_total, alpha_total);

	alpha_average = alpha_total/numshapes;
	NSLog(@"\nAlpha average: %f", alpha_average);
	
	//	Reset values
	sc_red_total = sc_green_total = sc_blue_total = alpha_total = 0.0f;
	for (int i = 0; i < 480; i++)	{
		points[i] = 0.0f;
		curves[i] =	0.0f;
	}
	numpoints		= 0;
	numshapes		= 0;
	numcurves		= 0;
	alpha_average	= 0.0f;	
	
	NSMutableArray* parameters = [[NSMutableArray alloc] init];
	[delegate updatedParameters:parameters];
}

@end
