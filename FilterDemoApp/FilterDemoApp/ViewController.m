//
//  ViewController.m
//  FilterDemoApp
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "ViewController.h"
#import "GPUImagePicture.h"
#import "FilterKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    FilterKit *fk = [[FilterKit alloc] init];
    NSLog(@"%@", fk);
    
    GPUImagePicture *ip = [[GPUImagePicture alloc] init];
    NSLog(@"%@", ip);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
