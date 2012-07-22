//
//  FKImageView.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKImageView.h"
#import "FKFilterChain.h"
#import "FKFilter.h"

@interface FKImageView ()
@property (assign, nonatomic) BOOL filterApplied;
@end

@implementation FKImageView {
    @private
    UIImageView *_imageView;
}

//@synthesize image = _image;
@synthesize filterChain = _filterChain;
@synthesize filterApplied = _filterApplied;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
    
    return self;
}

- (void)layoutSubviews
{
    _imageView.frame = self.bounds;
}

- (void)processFilterChain
{
    __block UIImage *image = self.image;
    NSArray *filters = _filterChain.filters;
    
    [filters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id <FKFilter>filter = (id <FKFilter>)obj;
        image = [filter imageWithFilterAppliedWithImage:image];
    }];
    
    self.image = image;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (UIImage *)image
{
    return _imageView.image;
}

@end
