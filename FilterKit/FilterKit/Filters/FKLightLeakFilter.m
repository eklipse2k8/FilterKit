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
#import "GPUImageScreenBlendFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageOverlayBlendFilter.h"

@interface FKLightLeakFilterGroup : FKGPUFilterGroup

@end

@implementation FKLightLeakFilterGroup

- (UIImage *)imageWithFilterAppliedWithImage:(UIImage *)image
{
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];

    GPUImageGaussianBlurFilter * gausFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [gausFilter setBlurSize:5];
    
    [pic addTarget:gausFilter];
    
    [pic processImage];
    
    UIImage *blur = gausFilter.imageFromCurrentlyProcessedOutput;
    GPUImagePicture *blurPic = [[GPUImagePicture alloc] initWithImage:blur smoothlyScaleOutput:YES];
    [blurPic processImage];

    GPUImageOverlayBlendFilter *bloomBlendFilter = [[GPUImageOverlayBlendFilter alloc] init];
    [blurPic addTarget:bloomBlendFilter];
    
    GPUImagePicture *pic2 = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    [pic2 addTarget:bloomBlendFilter];
    
    [pic2 processImage];
    UIImage *bloom = bloomBlendFilter.imageFromCurrentlyProcessedOutput;
    GPUImagePicture *bloomPic = [[GPUImagePicture alloc] initWithImage:bloom smoothlyScaleOutput:YES];
    [bloomPic processImage];
    
//    GPUImageBrightnessFilter *brightFilter = [[GPUImageBrightnessFilter alloc] init];
//    [brightFilter setBrightness:-.05];
//    [bloomPic addTarget:brightFilter];
    
//    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
//    [contrastFilter setContrast:1.5];
//    
//    [bloomPic addTarget:contrastFilter];
    
    
    /// monochrome
    GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];    
    [monoFilter setColor:(GPUVector4){0.0f, 0.5f, 1.0f, 1.0f}];
    [monoFilter setIntensity:.1f];
    [bloomPic addTarget:monoFilter];
    
    GPUImagePicture *tintPic = [[GPUImagePicture alloc] initWithImage:monoFilter.imageFromCurrentlyProcessedOutput smoothlyScaleOutput:YES];
    [tintPic processImage];
    
    /// lightleak image
    GPUImagePicture *lightleakPic = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lightleak-2.jpg"] smoothlyScaleOutput:YES];
    [lightleakPic processImage];
    
    GPUImageScreenBlendFilter *lightleakBlendFilter = [[GPUImageScreenBlendFilter alloc] init];
    [lightleakPic addTarget:lightleakBlendFilter];

    [tintPic addTarget:lightleakBlendFilter];
    
    
    //NSParameterAssert(gausFilter.imageFromCurrentlyProcessedOutput != nil);
    //UIImage *img = [UIImage imageWithCGImage:[pic imageFromCurrentlyProcessedOutput].CGImage];
    return lightleakBlendFilter.imageFromCurrentlyProcessedOutput;
}

@end


@implementation FKLightLeakFilter


- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKLightLeakFilterGroup alloc] init];
    [self addFilterToChain:filter];

    
    
    
//    [filter addGPUFilter:gausFilter];
//    
//    // I need UIImage from this filter'd group
//    
//    UIImage *bloomImg = [filter imageWithFilterAppliedWithImage:[UIImage imageNamed:@"unfiltered.jpg"]];
//    
//    // bloom
//    GPUImagePicture *bloomPic = [[GPUImagePicture alloc] initWithImage:bloomImg smoothlyScaleOutput:YES];
//    [bloomPic processImage];
//    
//    GPUImageScreenBlendFilter *bloomBlendFilter = [[GPUImageScreenBlendFilter alloc] init];
//    [bloomPic addTarget:bloomBlendFilter];
//
//    FKGPUFilterGroup *filter2 = [[FKGPUFilterGroup alloc] init];
//    [filter2 addGPUFilter:bloomBlendFilter];
//    
//    
//    GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
//    
//    [monoFilter setColor:(GPUVector4){0.0f, 0.5f, 1.0f, 1.0f}];
//    [monoFilter setIntensity:0.7f];
//    
//    //[filter2 addGPUFilter:monoFilter];
//
//    [self addFilterToChain:filter2];
    
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
