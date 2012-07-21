//
//  FKImageView.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKImageView.h"

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
    //self.layer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f].CGColor;
    
    return self;
}

- (void)layoutSubviews
{
    _imageView.frame = self.bounds;
}

- (void)processFilter
{
    
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
