//
//  FKFilters.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKFilters.h"

// Below is a list of classes in order of how you want them available in your app.
// These are just strings that will later be called by NSClassFromString when FKImageView is
// about to call processFilterChain

// If you plan to disable a filter, make sure to uncheck it from the framework so that it
// doesn't get compiled into the application.

NSString * const FKFilterList[] = {
    @"FKBlackWhiteFilter",
    @"FKSepia",
    @"FKBlueValentine",
//    @"FKLightLeakFilter",
    nil
};

