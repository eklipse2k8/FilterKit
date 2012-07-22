//
//  FKImagePickerController.m
//  FilterKit
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKImagePickerController.h"
#import "FKFilterPickerController.h"
#import "FKCropAction.h"

@interface FKImagePickerController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation FKImagePickerController {
    @private
    UIImagePickerController *_imagePicker;
    FKFilterPickerController *_filterPicker;
    BOOL _showPicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (!self)
        return nil;
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    _filterPicker = [[FKFilterPickerController alloc] init];
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View Loaded");
    
    if (!_showPicker) {
        [self presentModalViewController:_imagePicker animated:YES];
        _showPicker = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        FKCropAction *crop = [[FKCropAction alloc] init];
        CGRect cropRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        crop.origin = cropRect.origin;
        crop.cropSize = cropRect.size;
        _filterPicker.image = [crop imageWithActionAppliedWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        
        [self presentModalViewController:_filterPicker animated:NO];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:NO];
}


@end
