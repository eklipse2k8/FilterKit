//
//  FKBlackWhiteFilter.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKBlackWhiteFilter.h"
#import "FKGPUFilterGroup.h"

#import "GPUImageMonochromeFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageView.h"
#import "GPUImagePicture.h"

@implementation FKBlackWhiteFilter

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    FKGPUFilterGroup *filter = [[FKGPUFilterGroup alloc] init];
    [self addFilterToChain:filter];
    
    GPUImageMonochromeFilter *mono = [[GPUImageMonochromeFilter alloc] init];
    [mono forceProcessingAtSize:CGSizeMake(600, 600)];
    mono.color = (GPUVector4){0.5f, 0.5f, 0.5f, 1.f};

    [filter addGPUFilter:mono];
    
    return self;
}

- (void)dealloc
{
    
}

- (NSString *)title
{
    return @"Black & White";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Black & White", @"Localized title for default filter chain.");
}

@end
