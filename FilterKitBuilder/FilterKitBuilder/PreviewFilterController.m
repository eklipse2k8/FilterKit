//
//  Created by stran on 7/21/12.
//
//


#import "PreviewFilterController.h"
#import "GPUImage.h"
#import "FKContrastFilterBuilder.h"
#import "FKSaturationFilterBuilder.h"
#import "FKSharpenFilterBuilder.h"
#import "FKVignetteFilterBuilder.h"


@implementation PreviewFilterController {

}
@synthesize imageView;
@synthesize filterGroup;
@synthesize builders;
@synthesize imageSource;
@synthesize filterTable;


- (void)refresh {
    [imageSource processImage];
    imageView.image = [filterGroup imageFromCurrentlyProcessedOutput];
    imageView.frame = CGRectMake(301, 20, imageView.image.size.width, imageView.image.size.height);
}

- (void)updateGroup {
    self.filterGroup = [GPUImageFilterGroup new];
    GPUImageFilter *filter = nil;
    for (FKFilterBuilder *builder in builders) {
        [filterGroup addFilter:builder.imageFilter];

        if (filter) {
            [filter addTarget:builder.imageFilter];
        }
        filter = builder.imageFilter;
    }

    FKFilterBuilder *initialBuilder = [builders objectAtIndex:0];
    filterGroup.initialFilters = [NSArray arrayWithObject:initialBuilder.imageFilter];
    filterGroup.terminalFilter = filter;

    [imageSource addTarget:filterGroup];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - table datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

   	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   	if (cell == nil) {
   		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
   	}

    FKFilterBuilder *builder = [builders objectAtIndex:(NSUInteger)indexPath.row];
    [cell.contentView addSubview:builder.inputView];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [builders count];
}

#pragma mark - life cycle
- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];

    self.imageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"sample.jpg"]];
    self.builders = [NSMutableArray arrayWithObjects:
            [[FKContrastFilterBuilder alloc] initWithDelegate:self],
            [[FKSaturationFilterBuilder alloc] initWithDelegate:self],
            [[FKSharpenFilterBuilder alloc] initWithDelegate:self],
//            [[FKVignetteFilterBuilder alloc] initWithDelegate:self],
            nil];
    self.imageView = [[UIImageView alloc] initWithImage:nil];
    [self.view addSubview:imageView];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    [self.view addSubview:toolbar];

    self.filterTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 300, 704) style:UITableViewStylePlain];
    filterTable.dataSource = self;
    filterTable.delegate = self;
    [self.view addSubview:filterTable];

    [self updateGroup];
    [self refresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end