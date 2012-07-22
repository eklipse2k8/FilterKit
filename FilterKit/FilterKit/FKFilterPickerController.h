//
//  FKFilterPickerController.h
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKFilterPickerController;

@protocol FKFilterPickerDelegate <NSObject>
@optional
- (void)filterPicker:(FKFilterPickerController *)picker didFinishPickingFilterWithInfo:(NSDictionary *)info;
- (void)filterPickerDidCancel:(FKFilterPickerController *)picker;
@end

@interface FKFilterPickerController : UIViewController

@property (nonatomic, assign) id <FKFilterPickerDelegate> delegate;
@property (nonatomic, retain) UIImage *image;
- (id)initWithImage:(UIImage *)image;

@end
