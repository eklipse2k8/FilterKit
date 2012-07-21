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
    
}

@synthesize image = _image;
@synthesize filterChain = _filterChain;
@synthesize filterApplied = _filterApplied;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    return self;
}

- (void)processFilter
{
    
}

@end
