//
//  FKGPUFilterGroup.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKGPUFilterGroup.h"
#import "GPUImageFilterGroup.h"
#import "GPUImageFilter.h"
#import "GPUImagePicture.h"

#import "GPUImageMonochromeFilter.h"

@implementation FKGPUFilterGroup {
    @private
    NSMutableArray *_gpuFilters;
    GPUImagePicture *_picture;
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _gpuFilters = [[NSMutableArray alloc] initWithCapacity:1];
    
    return self;
}

- (void)dealloc
{
    _gpuFilters = nil;
}

- (void)addGPUFilter:(GPUImageFilter *)filter
{
    [_gpuFilters addObject:filter];
}

- (UIImage *)imageWithFilterAppliedWithImage:(UIImage *)image
{
    _picture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageMonochromeFilter *mono = [[GPUImageMonochromeFilter alloc] init];
    mono.color = (GPUVector4){0.5f, 0.5f, 0.5f, 1.f};
    //[mono forceProcessingAtSize:CGSizeMake(600, 600)];
    [_picture addTarget:mono];
    
    //return [_picture imageByFilteringImage:image];
    
    [_picture processImage];
    return mono.imageFromCurrentlyProcessedOutput;
}

@end
