//
//  FKImagePickerController.m
//  FilterDemoApp
//
//  Created by Mohammed Jisrawi on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKImagePickerController.h"
#import "FKImageView.h"
#import "FKGPUFilterGroup.h"
#import <QuartzCore/QuartzCore.h>
#import "FKBlackWhiteFilter.h"

@interface FKImagePickerController ()
@property(nonatomic, strong) FKImageView *image;
@property(nonatomic, strong) FKImageView *filteredImage;
@property(nonatomic, strong) CALayer *filterMask;

- (void)didDragViewPort:(UIPanGestureRecognizer *)gestureRecognizer;
@end

@implementation FKImagePickerController

@synthesize image, filteredImage = _filteredImage;
@synthesize filterMask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragViewPort:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect imageFrame = CGRectMake(10, 90, 300, 300);
    
    self.image = [[FKImageView alloc] initWithFrame:imageFrame];
    self.image.image = [UIImage imageNamed:@"unfiltered.jpg"];
    [self.view addSubview:self.image];
    
    FKImageView *filteredImage = [[FKImageView alloc] initWithFrame:imageFrame];
    self.filteredImage = filteredImage;
    FKBlackWhiteFilter *filter = [[FKBlackWhiteFilter alloc] init];
    filteredImage.image = [UIImage imageNamed:@"unfiltered.jpg"];
    filteredImage.filterChain = filter;
    [filteredImage processFilterChain];
    [self.view addSubview:filteredImage];

    self.filterMask = [CALayer layer];
    self.filterMask.backgroundColor = [UIColor blackColor].CGColor;
    self.filterMask.frame = CGRectMake(0, 0, 400, 1000);
    self.filterMask.anchorPoint = CGPointMake(1.0, 1.0);
    self.filterMask.position = CGPointMake(0, imageFrame.size.height);
    self.filteredImage.layer.mask = filterMask;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 
#pragma mark - User Interaction

- (void)didDragViewPort:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint currentTranslation = [gestureRecognizer translationInView:self.view];
    CGFloat offset = currentTranslation.y/200;
    
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || 
       gestureRecognizer.state == UIGestureRecognizerStateCancelled){
        
        CATransform3D finalTransform;
        
        if(offset > 0.5){
            finalTransform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
        }else{
            finalTransform = CATransform3DIdentity;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.filterMask.transform = finalTransform;
        }];
        
    }else{
        
        CGFloat angle = MAX(0.0, MIN(M_PI_2*offset, M_PI_2));
        
        //    CATransform3D transform = CATransform3DMakeTranslation(currentTranslation.x, currentTranslation.y, 0.0);
        
        CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        self.filterMask.transform = transform;
        [CATransaction commit];
    }
}

@end
