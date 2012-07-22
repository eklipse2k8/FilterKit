//
//  FKSepia.m
//  FilterKit
//
//  Created by Justin Zhang on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKSepia.h"
#import "GPUImage.h"
#import "FKGPUFilterGroup.h"



@implementation FKSepia


- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKGPUFilterGroup alloc] init];
    [self addFilterToChain:filter];
    
    GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc] init];    
    
//    [sepia forceProcessingAtSize:CGSizeMake(600, 600)];
    [filter addGPUFilter:sepia];
    
    return self;
}

- (void)dealloc
{
    
}

- (NSString *)title
{
    return @"Sepia";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Black & White", @"Localized title for default filter chain.");
}



@end
