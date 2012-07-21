//
//  FKFilterChain.h
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FKFilter;

@interface FKFilterChain : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *localizedTitle;

- (void)addFilterToChain:(id <FKFilter>)filter;

@end
