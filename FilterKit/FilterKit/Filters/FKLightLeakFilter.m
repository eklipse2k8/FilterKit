//
//  FKLightLeakFilter.m
//  FilterKit
//
//  Created by Justin Zhang on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKLightLeakFilter.h"
#import "FKGPUFilterGroup.h"

#import "GPUImageMonochromeFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageView.h"
#import "GPUImagePicture.h"
#import "GPUImageGaussianBlurFilter.h"

@implementation FKLightLeakFilter


- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKGPUFilterGroup alloc] init];
    [self addFilterToChain:filter];
    
    GPUImageGaussianBlurFilter * gausFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [gausFilter setBlurSize:7.0];
    

    
    [filter addGPUFilter:gausFilter];
    
    
    
//    GPUImageMonochromeFilter *mono = [[GPUImageMonochromeFilter alloc] init];
//    [mono forceProcessingAtSize:CGSizeMake(600, 600)];
    // mono.color = (GPUVector4){0.5f, 0.5f, 0.5f, 1.f};
    
        
    
    
    return self;
}


- (NSString *)title
{
    return @"Light Leak";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Light Leak", @"Localized title for default filter chain.");
}

@end
