//
//  Created by stran on 7/22/12.
//
//


#import "FKVignetteFilterBuilder.h"
#import "GPUImage.h"


@implementation FKVignetteFilterBuilder {

}

- (id)initWithDelegate:(id <FKFilterBuilderDelegate>)aDelegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        self.title = @"Vignette";
        self.imageFilter = [[GPUImageVignetteFilter alloc] init];
    }

    return self;
}

@end