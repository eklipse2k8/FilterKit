//
//  FKBlackWhiteFilter.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKBlackWhiteFilter.h"
#import "FKGPUFilterGroup.h"

@implementation FKBlackWhiteFilter

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKGPUFilterGroup alloc] init];
    [self addFilterToChain:filter];
    
    return self;
}

- (void)dealloc
{
    
}

@end
