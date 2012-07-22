//
//  FKImagePickerController.h
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKImagePickerController;

@protocol FKImagePickerDelegate <NSObject>
@optional
- (void)imagePickerController:(FKImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(FKImagePickerController *)picker;
@end

@interface FKImagePickerController : UIViewController

@property (assign, nonatomic) id <FKImagePickerDelegate> delegate;

@end
