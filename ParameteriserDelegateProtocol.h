//
//  ParameteriserDelegateProtocol.h
//  graphicscore
//
//  Created by Zebedee Pedersen on 05/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#ifndef graphicscore_ParameteriserDelegateProtocol_h
#define graphicscore_ParameteriserDelegateProtocol_h

@protocol ParameteriserDelegate <NSObject>

-(void)updatedParameters:(NSMutableArray*)parameters;

@end

#endif
