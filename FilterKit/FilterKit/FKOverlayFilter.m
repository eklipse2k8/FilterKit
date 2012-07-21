//
//  Created by stran on 7/21/12.
//
//


#import <UIKit/UIKit.h>
#import "FKOverlayFilter.h"


@implementation FKOverlayFilter {

}
@synthesize overlayImage;


- (id)init
{
    self = [super init];
    if (!self)
        return nil;

    return self;
}

- (UIImage *)imageWithFilterAppliedWithImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, FALSE, 0.0);
    [image drawInRect:CGRectMake( 0, 0, image.size.width, image.size.height)];
    [overlayImage drawInRect:CGRectMake( 0, 0, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end