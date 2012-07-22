//
//  FKToon.m
//  FilterKit
//
//  Created by Justin Zhang on 7/22/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKToon.h"
#import "FKGPUFilterGroup.h"
#import "GPUImage.h"


@implementation FKToon

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKGPUFilterGroup alloc] init];
    [self addFilterToChain:filter];
    
    GPUImageSmoothToonFilter *mono = [[GPUImageSmoothToonFilter alloc] init];
//    mono.color = (GPUVector4){0.5f, 0.5f, 0.5f, 1.f};
    [mono setBlurSize:.5];
    
    [filter addGPUFilter:mono];
    
    return self;
}

- (void)dealloc
{
    
}

- (NSString *)title
{
    return @"Toon";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Toon", @"Localized title for default filter chain.");
}
@end
