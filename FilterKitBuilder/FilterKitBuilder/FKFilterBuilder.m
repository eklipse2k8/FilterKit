//
//  Created by stran on 7/21/12.
//
//


#import "FKFilterBuilder.h"
#import "GPUImage.h"


@implementation FKFilterBuilder {

}
@synthesize title;
@synthesize imageFilter;
@synthesize inputView;
@synthesize delegate;

- (id)initWithDelegate:(id <FKFilterBuilderDelegate>)aDelegate {
    self = [super init];
    if (self) {
        delegate = aDelegate;
    }

    return self;
}


@end