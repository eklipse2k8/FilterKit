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
@property(nonatomic, strong) UIView *chrome;
@property(nonatomic, strong) CALayer *disk, *filterMask;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) NSMutableArray *filters;
@property(nonatomic, strong) NSMutableDictionary *filteredImages;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

- (void)tappedCancel:(id)sender;

- (void)didDragDisk:(UIPanGestureRecognizer *)gestureRecognizer;

- (void)didEndSwipingWithOffset:(CGFloat)offset;
- (void)didEndDraggingWithOffset:(CGFloat)offset;

- (void)prepareAllFilters;
- (void)preparePreviousFilter;
- (void)prepareNextFilter;
- (void)prepareFilterForIndex:(NSUInteger)index;
- (void)swapToNextfilter;
- (void)swapToPreviousfilter;
@end


@implementation FKFilterPickerController {
    NSUInteger _currentFilterIndex;
}

@synthesize imageView, filteredImageView, activityIndicator, chrome;
@synthesize disk, filterMask;
@synthesize filters, filteredImages;
@synthesize panGestureRecognizer;
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

        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragDisk:)];
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect imageFrame = CGRectMake(0, 60, 320, 320);
    
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
    
    UIImageView *viewPort = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cameraViewPort.png"]];
    viewPort.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:viewPort];
    
    self.disk = [CALayer layer];
    self.disk.frame = CGRectMake(DISK_CENTER_X, imageFrame.origin.y-(2000-imageFrame.size.height)/2, 1000, 2000);
    self.disk.contents = (id)[UIImage imageNamed:@"disk.png"].CGImage;
    self.disk.anchorPoint = CGPointMake(0.0, 0.5);
    [self.view.layer addSublayer:disk];
    
    self.chrome = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImageView *barShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44.0, self.view.frame.size.width, 11.0)];
    [barShadow setImage:[UIImage imageNamed:@"navBarShadow.png"]];
    [self.chrome addSubview:barShadow];
    
    //nav bar setup
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    [navBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Choose Filter", @"")] animated:NO];
    [navBar.topItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(tappedCancel:)]];
    [self.chrome addSubview:navBar];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 80)];
    bottomBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottomBar.png"]];
    bottomBar.opaque = NO;
    [self.chrome addSubview:bottomBar];
    
    [self.view addSubview:self.chrome];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = self.imageView.center;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator]; 
    
    [self.panGestureRecognizer setEnabled:NO];
    [self.imageView setHidden:YES];
    [self.filteredImageView setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self prepareAllFilters];
}

#pragma mark - 
#pragma mark - User Interaction

- (void)tappedCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didDragDisk:(UIPanGestureRecognizer *)gestureRecognizer
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

- (void)prepareAllFilters
{
    self.filteredImages = [[NSMutableDictionary alloc] init];
    [self.filters enumerateObjectsUsingBlock:^(Class filter, NSUInteger idx, BOOL *stop){
        if(![filter isKindOfClass:[NSNull class]]){
            self.filteredImageView.image = [UIImage imageNamed:@"unfiltered@2x.jpg"];
            self.filteredImageView.filterChain = [[filter alloc] init];
            [self.filteredImageView processFilterChain];
            
            [self.filteredImages setObject:self.filteredImageView.image forKey:[self.filteredImageView.filterChain title]];
        }
    }];
    
    [activityIndicator removeFromSuperview];
    [self.imageView setHidden:NO];
    [self.filteredImageView setHidden:NO];
}

- (void)preparePreviousFilter
{    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.filterMask.transform = MASK_PREV_TRANSFORM;
    [CATransaction commit];
    
//    NSLog(@"prev");
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
    
//    NSLog(@"next");
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
        FKFilterChain *filterChain = [filter alloc];
        self.filteredImageView.image = [self.filteredImages objectForKey:[filterChain title]];
    }
}

- (void)swapToNextfilter
{    
//    NSLog(@"swapping to next");
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
//    NSLog(@"swapping to prev");
    
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

