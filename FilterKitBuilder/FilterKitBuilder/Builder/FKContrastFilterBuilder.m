//
//  Created by stran on 7/22/12.
//
//


#import "FKContrastFilterBuilder.h"
#import "GPUImage.h"
#import "StyleFactory.h"


@implementation FKContrastFilterBuilder {

}
@synthesize slider;
@synthesize value;


- (void)sliderAction {
    GPUImageContrastFilter *filter = (GPUImageContrastFilter *)self.imageFilter;
    filter.contrast = slider.value;
    self.value.text = [NSString stringWithFormat:@"%.1f", slider.value];

    if (delegate) {
        [delegate refresh];
    }
}

- (id)initWithDelegate:(id <FKFilterBuilderDelegate>)aDelegate {
    self = [super initWithDelegate:aDelegate];
    if (self) {
        self.title = @"Contrast";
        self.imageFilter = [[GPUImageContrastFilter alloc] init];
        self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];

        [inputView addSubview:[StyleFactory titleLabel:title]];

        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 30, 200, 40)];
        [slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
        slider.minimumValue = 0.0;
        slider.maximumValue = 4.0;
        slider.continuous = YES;
        slider.value = 1.0;
        [inputView addSubview:slider];

        self.value = [StyleFactory valueLabel:[NSString stringWithFormat:@"%.1f", slider.value]];
        [inputView addSubview:value];
    }

    return self;
}

@end