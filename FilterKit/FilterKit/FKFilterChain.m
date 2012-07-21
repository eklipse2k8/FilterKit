//
//  FKFilterChain.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKFilterChain.h"

@implementation FKFilterChain {
    @private
    NSMutableArray *_filters;
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _filters = [[NSMutableArray alloc] initWithCapacity:1];
    
    return self;
}

- (void)dealloc
{
    [_filters removeAllObjects];
}

- (NSString *)title
{
    return @"Filter Chain";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Filter Chain", @"Localized title for default filter chain.");
}

- (void)addFilterToChain:(id <FKFilter>)filter
{
    [_filters addObject:filter];
}

@end
