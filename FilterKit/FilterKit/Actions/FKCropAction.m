//
//  FKCropAction.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKCropAction.h"

@implementation FKCropAction

@synthesize origin = _origin;
@synthesize cropSize = _cropSize;

- (UIImage *)imageWithActionAppliedWithImage:(UIImage *)image
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect cropRect = CGRectMake(_origin.x * scale, _origin.y * scale,
                                 _cropSize.width * scale, _cropSize.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

@end
