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
#import "GPUImageView.h"
#import "GPUImageRawDataOutput.h"
#import "GPUImageUIElement.h"

@implementation FKGPUFilterGroup {
    @private
    NSMutableArray *_gpuFilters;
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
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    GPUImageOutput *lastFilter = picture;
    GPUImageFilter *filter = nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize processSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    NSUInteger count = [_gpuFilters count];
    for (NSUInteger i = 0; i < count; i++) {
        filter = [_gpuFilters objectAtIndex:i];
        [filter forceProcessingAtSize:processSize];
        [lastFilter removeAllTargets];
        [lastFilter addTarget:filter];
        lastFilter = filter;
    }
    
    //[lastFilter prepareForImageCapture];
    [picture processImage];
    return lastFilter.imageFromCurrentlyProcessedOutput;
}

@end
