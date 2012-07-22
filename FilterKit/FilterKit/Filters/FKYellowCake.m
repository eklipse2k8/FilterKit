//
//  FKYellowCake.m
//  FilterKit
//
//  Created by Justin Zhang on 7/22/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKYellowCake.h"

#import "GPUImage.h"
#import "FKGPUFilterGroup.h"

@implementation FKYellowCake

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKGPUFilterGroup alloc] init];
    [self addFilterToChain:filter];
    
    /// filters
    ///
    GPUImageSaturationFilter *saturFilter = [[GPUImageSaturationFilter alloc] init];
    [saturFilter setSaturation:0.5];
    
    GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
    [monoFilter setColor:(GPUVector4){1.0f, 1.0f, 0.0f, 1.0f}];
    [monoFilter setIntensity:0.2];
    
    GPUImageVignetteFilter *vigFilter = [[GPUImageVignetteFilter alloc] init];
    [vigFilter setVignetteEnd:0.6];
    
    GPUImageExposureFilter *expoFilter = [[GPUImageExposureFilter alloc] init];
    [expoFilter setExposure:0.3];
    
    [filter addGPUFilter:expoFilter];
    [filter addGPUFilter:monoFilter];
    [filter addGPUFilter:saturFilter];
    [filter addGPUFilter:vigFilter];
    
    return self;
}

- (void)dealloc
{
    
}

- (NSString *)title
{
    return @"Blue Valentine";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Blue Valentine", @"Localized title for default filter chain.");
}



@end
