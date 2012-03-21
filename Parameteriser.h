//
//  Parameteriser.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shapes.h"
#import "CAController.h"
#import "TouchArea.h"
#import "ParameteriserDelegateProtocol.h"
#import "RemoteMonitor.h"

@interface Parameteriser : NSObject <TouchAreaDelegate>	{//, RemoteMonitorDelegate>	{
	id <ParameteriserDelegate> delegate;

	int		numpoints;
	int		numshapes;
	int		numcurves;
	float	alpha_average;
	
	int		totalStars;
	int		totalQuads;
	int		totalEllipse;
	int		totalTriangles;
	
	NSMutableArray*	starPoints_w;	
	NSMutableArray*	quadPoints_w;	
	NSMutableArray*	triPoints_w;		
	NSMutableArray*	curves_w;
	
	NSMutableArray*	starPoints_x;	
	NSMutableArray*	quadPoints_x;	
	NSMutableArray*	triPoints_x;		
	NSMutableArray*	curves_x;
	
	NSMutableArray*	starPoints_y;	
	NSMutableArray*	quadPoints_y;	
	NSMutableArray*	triPoints_y;		
	NSMutableArray*	curves_y;

	NSMutableArray*	starPoints_z;	
	NSMutableArray*	quadPoints_z;	
	NSMutableArray*	triPoints_z;		
	NSMutableArray*	curves_z;
	
	double	totalSize;
	double	averageArea;
	double	averageWidth;
	double	averageHeight;
	
	//	all origins (distances)
	NSMutableArray*	origins;
	double	overlap;
}

@property	float			alpha_total;
@property	float			sc_red_total;
@property	float			sc_blue_total;
@property	float			sc_green_total;

-(id)initWithDelegate:(id)_delegate;

@end
