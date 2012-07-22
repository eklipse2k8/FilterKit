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
    [_picture processImage];
    
    GPUImageOutput *lastFilter = _picture;
    GPUImageFilter *filter = nil;
    NSUInteger count = [_gpuFilters count];
    for (NSUInteger i = 0; i < count; i++) {
        filter = [_gpuFilters objectAtIndex:i];
        [filter forceProcessingAtSize:image.size];
        [lastFilter removeAllTargets];
        [lastFilter addTarget:filter];
        lastFilter = filter;
    }
    return lastFilter.imageFromCurrentlyProcessedOutput;
}


//- (UIImage *)imageWithFilterAppliedWithImage:(UIImage *)image
//{
//    GPUImageView *view = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    
// //   GPUImageRawDataOutput *raw = [[GPUImageRawDataOutput alloc] initWithImageSize:image.size resultsInBGRAFormat:YES];
//    
//    _picture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
//    GPUImageOutput *lastFilter = view;
//    GPUImageFilter *filter = nil;
//    NSUInteger count = [_gpuFilters count];
//    for (NSUInteger i = 0; i < count; i++) {
//        filter = [_gpuFilters objectAtIndex:i];
//        
//        //[lastFilter removeAllTargets];
//        [filter addTarget:lastFilter];
//        //[lastFilter addTarget:filter];
//        lastFilter = filter;
//    }
//    
//    [_picture addTarget:lastFilter];
//
//    if ([lastFilter respondsToSelector:@selector(processImage)]) {
//        [(GPUImagePicture *)lastFilter processImage];
//    }
//
// //   [lastFilter addTarget:raw];
//    
//   // NSData *bytes = [NSData dataWithBytes:[raw rawBytesForImage] length:(image.size.width * image.size.height * 4 * sizeof(GLubyte))];
//    //UIImage *imageFromBytes = [UIImage imageWithData:bytes];
//    //return filter.imageFromCurrentlyProcessedOutput;
//    
//    UIImage *result;
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return result;
//}

@end
