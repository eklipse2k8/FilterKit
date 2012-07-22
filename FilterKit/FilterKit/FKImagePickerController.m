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
#import "FKLightLeakFilter.h"
#import "FKFilters.h"

#define RADIANS(degrees) (degrees / 180.0 * M_PI)

#define DISK_CENTER_X -1150.0
#define DRAG_DISTANCE 300
#define FILTER_STEP_ANGLE RADIANS(27.0)
#define MASK_NEXT_TRANSFORM CATransform3DMakeRotation(-FILTER_STEP_ANGLE, 0, 0, 1.0);
#define MASK_PREV_TRANSFORM CATransform3DMakeRotation(FILTER_STEP_ANGLE, 0, 0, 1.0);

@interface FKImagePickerController ()
@property(nonatomic, strong) FKImageView *imageView;
@property(nonatomic, strong) FKImageView *filteredImageView;
@property(nonatomic, strong) UIImageView *disk;
@property(nonatomic, strong) CALayer *filterMask;

@property(nonatomic, strong) NSMutableArray *filters;

//- (void)didSwipeViewPort:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)didDragViewPort:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)swapToPreviousfilter;
- (void)swapToNextfilter;
@end


@implementation FKImagePickerController {
    NSUInteger _currentFilterIndex;
}

@synthesize imageView, filteredImageView, disk;
@synthesize filterMask;
@synthesize filters;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filters = [[NSMutableArray alloc] init];
        [self.filters addObject:[NSNull null]];
        
        _currentFilterIndex = 0;

        NSUInteger next = 0;
        NSString *filterListString = FKFilterList[next++];
        while (filterListString != nil) {
            [self.filters addObject:NSClassFromString(filterListString)];
            filterListString = FKFilterList[next++];
        }
                
        self.view.backgroundColor = [UIColor blackColor];
        self.view.opaque = YES;
        self.view.clipsToBounds = YES;
//        
//        
//        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeViewPort:)];
//        [self.view addGestureRecognizer:swipeGestureRecognizer];
//        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragViewPort:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect imageFrame = CGRectMake(0, 80, 320, 320);
    
    self.imageView = [[FKImageView alloc] initWithFrame:imageFrame];
    self.imageView.image = [UIImage imageNamed:@"unfiltered.jpg"];
    [self.view addSubview:self.imageView];
    
    self.filteredImageView = [[FKImageView alloc] initWithFrame:imageFrame];
    [self.view addSubview:self.filteredImageView];

    self.filterMask = [CALayer layer];
    self.filterMask.backgroundColor = [UIColor redColor].CGColor;
    self.filterMask.frame = CGRectMake(DISK_CENTER_X, 0, 1000, imageFrame.size.height+10);
    self.filterMask.anchorPoint = CGPointMake(0.0, 0.5);
    self.filterMask.transform = MASK_NEXT_TRANSFORM;
    self.filteredImageView.layer.mask = filterMask;
//    [self.view.layer addSublayer:self.filterMask];
    
    self.disk = [[UIImageView alloc] initWithFrame:CGRectMake(DISK_CENTER_X, imageFrame.origin.y-(2000-imageFrame.size.height)/2, 1000, 2000)];
    self.disk.image = [UIImage imageNamed:@"disk.png"];
    self.disk.layer.anchorPoint = CGPointMake(0.0, 0.5);
    [self.view addSubview:disk];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 
#pragma mark - User Interaction
//
//- (void)didSwipeViewPort:(UISwipeGestureRecognizer *)gestureRecognizer
//{
//    
//    BOOL swipedUp = NO;
//    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp){
//        swipedUp = YES;
//    }else if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown){
//        swipedUp = NO;
//    }else{
//        return;
//    }
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        if(swipedUp){
//            self.filterMask.transform = MASK_PREV_TRANSFORM;
//            self.disk.layer.transform = MASK_PREV_TRANSFORM;
//        }else{
//            self.filterMask.transform = CATransform3DIdentity;
//            self.disk.layer.transform = MASK_NEXT_TRANSFORM;
//        }
//    }completion:^(BOOL finished){
//        if(swipedUp)    
//            [self swapToPreviousfilter];
//        else
//            [self swapToNextfilter];
//    }];
//}

- (void)didDragViewPort:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint currentTranslation = [gestureRecognizer translationInView:self.view];
    
    //This multiplier simulates torque by adjusting the rotational offset for the touch distance from the left edge of the screen.
    CGFloat multiplier = [gestureRecognizer locationInView:self.view].x/self.view.frame.size.width;
    
    CGFloat offset = MAX(-1.0, MIN((multiplier*currentTranslation.y)/DRAG_DISTANCE, 1.0));
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){

        if(offset < 0)
            [self preparePreviousFilter];
        else
            [self prepareNextFilter];
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded || 
       gestureRecognizer.state == UIGestureRecognizerStateCancelled){
            
        [UIView animateWithDuration:0.2 animations:^{
            if(fabs(offset) > 0.5){
                if(offset < 0){
                    self.filterMask.transform = CATransform3DIdentity;
                    self.disk.layer.transform = MASK_NEXT_TRANSFORM;
                }else{
                    self.filterMask.transform = CATransform3DIdentity;
                    self.disk.layer.transform = MASK_PREV_TRANSFORM;
                }
            }else{
                self.filterMask.transform = MASK_NEXT_TRANSFORM;
                self.disk.layer.transform = CATransform3DIdentity;
            }
        }completion:^(BOOL finished){
            if(fabs(offset) > 0.5){            
                if(offset < 0)
                    [self swapToNextfilter];
                else
                    [self swapToPreviousfilter];
            }
        }];
        
    }else{
        
        CGFloat angle = MAX(-FILTER_STEP_ANGLE, MIN(FILTER_STEP_ANGLE*offset, FILTER_STEP_ANGLE));
                        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        if(offset < 0)
            self.filterMask.transform = CATransform3DMakeRotation(angle+FILTER_STEP_ANGLE, 0, 0, 1.0);
        else
            self.filterMask.transform = CATransform3DMakeRotation(angle-FILTER_STEP_ANGLE, 0, 0, 1.0);
        
        self.disk.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1.0);;
        [CATransaction commit];
    }
}


#pragma mark - 
#pragma mark - Filter Application

- (void)preparePreviousFilter
{    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    self.filterMask.transform = MASK_PREV_TRANSFORM;
    [CATransaction commit];
    
    NSLog(@"prev");
    if(_currentFilterIndex == 0)
        [self prepareFilterForIndex:[self.filters count]-1];
    else
        [self prepareFilterForIndex:_currentFilterIndex-1];
}

- (void)prepareNextFilter
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    self.filterMask.transform = MASK_NEXT_TRANSFORM;
    [CATransaction commit];
    
    NSLog(@"next");
    if(_currentFilterIndex == [self.filters count]-1)
        [self prepareFilterForIndex:0];
    else
        [self prepareFilterForIndex:_currentFilterIndex+1];
}

- (void)prepareFilterForIndex:(NSUInteger)index
{
    NSLog(@"preparing: %d", index);
    
    Class filter = (Class)[self.filters objectAtIndex:_currentFilterIndex];
    
    self.filteredImageView.image = [UIImage imageNamed:@"unfiltered.jpg"];
    
    if(![filter isKindOfClass:[NSNull class]]){    
        self.filteredImageView.filterChain = [[filter alloc] init];
        [self.filteredImageView processFilterChain];
    }
}

- (void)swapToNextfilter
{    
    NSLog(@"swapping");
    if(_currentFilterIndex == [self.filters count]-1) 
        _currentFilterIndex = 0;
    else
        _currentFilterIndex++;
    
    self.imageView.image = self.filteredImageView.image;
    
    //reset disk & mask
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    self.filterMask.transform = MASK_NEXT_TRANSFORM;
    self.disk.layer.transform = CATransform3DIdentity;
    [CATransaction commit];
}

- (void)swapToPreviousfilter
{
    NSLog(@"swapping");

    if(_currentFilterIndex == 0)
        _currentFilterIndex = [self.filters count]-1;
    else
        _currentFilterIndex--;
    
    self.imageView.image = self.filteredImageView.image;

    //reset disk & mask
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    self.filterMask.transform = MASK_NEXT_TRANSFORM;
    self.disk.layer.transform = CATransform3DIdentity;
    [CATransaction commit];
}

@end
