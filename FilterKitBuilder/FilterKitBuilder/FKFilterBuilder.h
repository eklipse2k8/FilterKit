//
//  Created by stran on 7/21/12.
//
//


#import <Foundation/Foundation.h>

@class GPUImageFilter;

@protocol FKFilterBuilderDelegate <NSObject>
    @required
    - (void) refresh;
    @end

@interface FKFilterBuilder : NSObject {

    NSString *title;
    GPUImageFilter *imageFilter;

    UIView *inputView;

    __unsafe_unretained  id<FKFilterBuilderDelegate> delegate;

}
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) GPUImageFilter *imageFilter;
@property(nonatomic, strong) UIView *inputView;
@property (assign) id delegate;

- (id)initWithDelegate:(id <FKFilterBuilderDelegate>)aDelegate;


@end