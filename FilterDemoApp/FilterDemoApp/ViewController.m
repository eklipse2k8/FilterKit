//
//  ViewController.m
//  FilterDemoApp
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "ViewController.h"
#import "FKImagePickerController.h"

@interface ViewController ()

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
    FKImagePickerController *imagePickerController = [[FKImagePickerController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:imagePickerController animated:YES];
}

@end
