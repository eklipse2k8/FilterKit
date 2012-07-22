//
//  Created by stran on 7/22/12.
//
//


#import "StyleFactory.h"


@implementation StyleFactory {

}

+ (UILabel *)titleLabel:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, 200, 20)];
    titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:15];
    titleLabel.text = title;

    return titleLabel;
}

+ (UILabel *)valueLabel:(NSString *)value {
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 80)];
    valueLabel.font = [UIFont fontWithName:@"GillSans-Light" size:30];
    valueLabel.text = value;

    return valueLabel;
}
@end