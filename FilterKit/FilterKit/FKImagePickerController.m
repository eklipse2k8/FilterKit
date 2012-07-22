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
    
    return self;
}

- (void)loadView
{
//    self.view = _filterPicker.view;
    
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
    if (!_showPicker) {
        [self presentModalViewController:_imagePicker animated:YES];
        _showPicker = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    FKCropAction *crop = [[FKCropAction alloc] init];
    CGRect cropRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    crop.origin = cropRect.origin;
    crop.cropSize = cropRect.size;
    UIImage *image = [crop imageWithActionAppliedWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    _filterPicker = [[FKFilterPickerController alloc] initWithImage:image];
    _filterPicker.view.frame = CGRectOffset(_filterPicker.view.frame, 0, -20);
    [self.view addSubview:_filterPicker.view];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:NO];
}


@end
