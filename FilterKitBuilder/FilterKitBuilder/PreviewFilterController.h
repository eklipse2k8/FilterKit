//
//  Created by stran on 7/21/12.
//
//


#import <Foundation/Foundation.h>
#import "FKFilterBuilder.h"

@class GPUImageFilterGroup;
@class GPUImagePicture;


@interface PreviewFilterController : UIViewController
        <UITableViewDataSource,
        UITableViewDelegate,
        FKFilterBuilderDelegate> {

    UIImageView *imageView;

    GPUImagePicture *imageSource;
    GPUImageFilterGroup *filterGroup;
    UITableView *filterTable;

    NSMutableArray *builders;

}
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) GPUImageFilterGroup *filterGroup;
@property(nonatomic, strong) NSMutableArray *builders;
@property(nonatomic, strong) GPUImagePicture *imageSource;
@property(nonatomic, strong) UITableView *filterTable;


@end