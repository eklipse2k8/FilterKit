//
//  ViewController.m
//  FilterDemoApp
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "ViewController.h"
#import "FKFilterPickerController.h"
#import "FKImagePickerController.h"

@interface ViewController () <FKImagePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 200, 300, 80);
    [button setTitle:NSLocalizedString(@"Show Picker", @"") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)showPicker:(id)sender
{
    FKImagePickerController *imagePicker = [[FKImagePickerController alloc] init];
    [self presentModalViewController:imagePicker animated:YES];
}

#pragma mark - FKImagePickerDelegate

- (void)imagePickerController:(FKImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

- (void)imagePickerControllerDidCancel:(FKImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
