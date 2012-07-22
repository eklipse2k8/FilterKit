//
//  Created by stran on 7/22/12.
//
//


#import <Foundation/Foundation.h>
#import "FKFilterBuilder.h"


@interface FKSharpenFilterBuilder : FKFilterBuilder {

    UISlider *slider;
    UILabel *value;

}
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UILabel *value;

@end