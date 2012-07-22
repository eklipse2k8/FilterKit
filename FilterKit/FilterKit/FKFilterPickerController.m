//
//  FKFilterPickerController.m
//  FilterKit
//
//  Created by Mohammed Jisrawi on 7/21/12.
//  Copyright (c) 2012 iOS Dev Camp 2012. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FKFilterPickerController.h"
#import "FKImageView.h"
#import "FKFilters.h"
#import "FKFilterChain.h"

#define RADIANS(degrees) (degrees / 180.0 * M_PI)

#define DISK_CENTER_X -1150.0
#define DRAG_DISTANCE 300
#define FILTER_STEP_ANGLE RADIANS(27.0)
#define MASK_NEXT_TRANSFORM CATransform3DMakeRotation(-FILTER_STEP_ANGLE, 0, 0, 1.0);
#define MASK_PREV_TRANSFORM CATransform3DMakeRotation(FILTER_STEP_ANGLE, 0, 0, 1.0);


@interface FKFilterPickerController ()
@property(nonatomic, strong) FKImageView *imageView, *filteredImageView;
@property(nonatomic, strong) CALayer *disk, *filterMask;
@property(nonatomic, strong) NSMutableArray *filters;

- (void)didDragViewPort:(UIPanGestureRecognizer *)gestureRecognizer;

- (void)didEndSwipingWithOffset:(CGFloat)offset;
- (void)didEndDraggingWithOffset:(CGFloat)offset;

- (void)preparePreviousFilter;
- (void)prepareNextFilter;
- (void)prepareFilterForIndex:(NSUInteger)index;
- (void)swapToNextfilter;
- (void)swapToPreviousfilter;
@end


@implementation FKFilterPickerController {
    NSUInteger _currentFilterIndex;
}

@synthesize imageView, filteredImageView, disk;
@synthesize filterMask;
@synthesize filters;
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
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
        
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeViewPort:)];
        [self.view addGestureRecognizer:swipeGestureRecognizer];
  
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
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    self.filteredImageView = [[FKImageView alloc] initWithFrame:imageFrame];
    [self.view addSubview:self.filteredImageView];
    
    self.filterMask = [CALayer layer];
    self.filterMask.backgroundColor = [UIColor redColor].CGColor;
    self.filterMask.frame = CGRectMake(DISK_CENTER_X, 0, 1000, imageFrame.size.height+4);
    self.filterMask.anchorPoint = CGPointMake(0.0, 0.5);
    self.filterMask.transform = MASK_NEXT_TRANSFORM;
    self.filteredImageView.layer.mask = filterMask;
//    [self.view.layer addSublayer:self.filterMask];
    
    self.disk = [CALayer layer];
    self.disk.frame = CGRectMake(DISK_CENTER_X, imageFrame.origin.y-(2000-imageFrame.size.height)/2, 1000, 2000);
    self.disk.contents = (id)[UIImage imageNamed:@"disk.png"].CGImage;
    self.disk.anchorPoint = CGPointMake(0.0, 0.5);
    [self.view.layer addSublayer:disk];
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
    
    //This multiplier simulates torque by adjusting the rotational offset for the touch distance from the left edge of the screen.
    CGFloat multiplier = [gestureRecognizer locationInView:self.view].x/self.view.frame.size.width;

    CGFloat offset = MAX(-1.0, MIN((multiplier*currentTranslation.y)/DRAG_DISTANCE, 1.0));

//    NSLog(@"y trans: %f, x loc: %f, mult: %f, off: %f", currentTranslation.y, [gestureRecognizer locationInView:self.view].x, multiplier, offset);
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        
        if(offset < 0)
            [self preparePreviousFilter];
        else
            [self prepareNextFilter];
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded || 
             gestureRecognizer.state == UIGestureRecognizerStateCancelled){
                
        if(fabsf([gestureRecognizer velocityInView:self.view].y) > 600){
            [self didEndSwipingWithOffset:offset];
        }else{        
            [self didEndDraggingWithOffset:offset];
        }
    }else{
        
        CGFloat angle = MAX(-FILTER_STEP_ANGLE, MIN(FILTER_STEP_ANGLE*offset, FILTER_STEP_ANGLE));
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if(offset < 0)
            self.filterMask.transform = CATransform3DMakeRotation(angle+FILTER_STEP_ANGLE, 0, 0, 1.0);
        else
            self.filterMask.transform = CATransform3DMakeRotation(angle-FILTER_STEP_ANGLE, 0, 0, 1.0);
                
        self.disk.transform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
        [CATransaction commit];
    }
}

- (void)didEndSwipingWithOffset:(CGFloat)offset
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setCompletionBlock:^{
        if(offset < 0)
            [self swapToPreviousfilter];
        else
            [self swapToNextfilter];
    }];
    
    if(offset < 0){
        self.filterMask.transform = CATransform3DIdentity;
        self.disk.transform = MASK_NEXT_TRANSFORM;
    }else{
        self.filterMask.transform = CATransform3DIdentity;
        self.disk.transform = MASK_PREV_TRANSFORM;
    }
    [CATransaction commit];
}

- (void)didEndDraggingWithOffset:(CGFloat)offset
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setCompletionBlock:^{
        if(fabs(offset) > 0.5){            
            if(offset < 0)
                [self swapToPreviousfilter];
            else
                [self swapToNextfilter];
        }
    }];
    
    if(fabs(offset) > 0.5){
        if(offset < 0){
            self.filterMask.transform = CATransform3DIdentity;
            self.disk.transform = MASK_NEXT_TRANSFORM;
        }else{
            self.filterMask.transform = CATransform3DIdentity;
            self.disk.transform = MASK_PREV_TRANSFORM;
        }
    }else{
        if(offset < 0){
            self.filterMask.transform = MASK_PREV_TRANSFORM;
            self.disk.transform = CATransform3DIdentity;
        }else{
            self.filterMask.transform = MASK_NEXT_TRANSFORM;
            self.disk.transform = CATransform3DIdentity;
        }
    }
    [CATransaction commit];
}


#pragma mark - 
#pragma mark - Filter Preparation & Application

- (void)preparePreviousFilter
{    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
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
    [CATransaction setDisableActions:YES];
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
    Class filter = (Class)[self.filters objectAtIndex:index];
    
    self.filteredImageView.image = self.image;
    
    if(![filter isKindOfClass:[NSNull class]]){  
        self.filteredImageView.filterChain = [[filter alloc] init];
        [self.filteredImageView processFilterChain];
        
        NSLog(@"preparing filter %d: %@", index, [self.filteredImageView.filterChain title]);
    }else{
        NSLog(@"preparing filter %d: unfiltered image", index);
    }
}

- (void)swapToNextfilter
{    
    NSLog(@"swapping to next");
    if(_currentFilterIndex == [self.filters count]-1) 
        _currentFilterIndex = 0;
    else
        _currentFilterIndex++;
    
    self.imageView.image = self.filteredImageView.image;
    
    //reset disk & mask
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.filterMask.transform = MASK_NEXT_TRANSFORM;
    self.disk.transform = CATransform3DIdentity;
    [CATransaction commit];
}

- (void)swapToPreviousfilter
{
    NSLog(@"swapping to prev");
    
    if(_currentFilterIndex == 0)
        _currentFilterIndex = [self.filters count]-1;
    else
        _currentFilterIndex--;
    
    self.imageView.image = self.filteredImageView.image;
    
    //reset disk & mask
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.filterMask.transform = MASK_PREV_TRANSFORM;
    self.disk.transform = CATransform3DIdentity;
    [CATransaction commit];
}

@end

