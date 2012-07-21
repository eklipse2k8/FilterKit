//
//  ViewController.m
//  FilterDemoApp
//
//  Created by Matt Jarjoura on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "ViewController.h"
#import "FKImageView.h"
#import "FKGPUFilterGroup.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FKGPUFilterGroup *group = [[FKGPUFilterGroup alloc] init];
    
    FKImageView *image = [[FKImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    image.image = [group imageWithFilterAppliedWithImage:[UIImage imageNamed:@"mean_cat.jpg"]];
    [self.view addSubview:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
