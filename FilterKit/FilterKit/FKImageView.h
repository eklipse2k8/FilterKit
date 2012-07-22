//
//  FKImageView.h
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKFilterChain;

@interface FKImageView : UIView

@property (retain, nonatomic) UIImage *image;

/**
 * filterChain is the chain of filters applied to the image in the view
 */
@property (retain, nonatomic) FKFilterChain *filterChain;

/**
 * because filters are asynchronously applied, the view may not have the filter applied yet
 * before it's ready to show the image
 */
@property (assign, readonly, nonatomic) BOOL filterApplied;

- (void)processFilterChain;

@end
