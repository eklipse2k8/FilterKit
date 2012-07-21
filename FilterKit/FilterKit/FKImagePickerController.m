//
//  FKImagePickerController.m
//  FilterDemoApp
//
//  Created by Mohammed Jisrawi on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import "FKImagePickerController.h"
#import "FKImageView.h"
#import "FKBlackWhiteFilter.h"
#import <QuartzCore/QuartzCore.h>

@interface FKImagePickerController ()
@property(nonatomic, strong) FKImageView *image;
@property(nonatomic, strong) FKImageView *filteredImage;
@property(nonatomic, strong) CALayer *filterMask;

- (void)didDragViewPort:(UIPanGestureRecognizer *)gestureRecognizer;
@end

@implementation FKImagePickerController

@synthesize image, filteredImage;
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
    
    self.filteredImage = [[FKImageView alloc] initWithFrame:imageFrame];
    self.filteredImage.image = [UIImage imageNamed:@"filtered.jpg"];
    [self.view addSubview:self.filteredImage];

    self.filterMask = [CALayer layer];
    self.filterMask.backgroundColor = [UIColor blackColor].CGColor;
    self.filterMask.frame = CGRectMake(0, 0, 400, 1000);
    self.filterMask.anchorPoint = CGPointMake(1.0, 1.0);
    self.filterMask.position = CGPointMake(0, imageFrame.size.height);

//    [self.view.layer addSublayer:self.filterMask];
    self.filteredImage.layer.mask = filterMask;
    
    //    FKBlackWhiteFilter *bwFilter = [[FKBlackWhiteFilter alloc] init];
    //    image.filterChain = bwFilter;
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
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || 
       gestureRecognizer.state == UIGestureRecognizerStateCancelled){
        
        
        
    }else{
        CGPoint currentTranslation = [gestureRecognizer translationInView:self.view];
        
        //    CATransform3D transform = CATransform3DMakeTranslation(currentTranslation.x, currentTranslation.y, 0.0);
        
        CGFloat offset = currentTranslation.y/200;
        
        CGFloat angle = MAX(0.0, MIN(M_PI_2*offset, M_PI_2));
        
        CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        self.filterMask.transform = transform;
        [CATransaction commit];
    }
}

@end
