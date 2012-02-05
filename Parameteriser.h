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

@interface Parameteriser : NSObject <TouchAreaDelegate>	{
	id <ParameteriserDelegate> delegate;
}

-(id)initWithDelegate:(id)_delegate;

@end
