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
    GPUImageOutput *lastFilter = _picture;
    GPUImageFilter *filter = nil;
    NSUInteger count = [_gpuFilters count];
    for (NSUInteger i = 0; i < count; i++) {
        filter = [_gpuFilters objectAtIndex:i];
        [lastFilter addTarget:filter];
        if ([lastFilter respondsToSelector:@selector(processImage)]) {
            [(GPUImagePicture *)lastFilter processImage];
        }
        lastFilter = filter;
    }
    return filter.imageFromCurrentlyProcessedOutput;
}

@end
