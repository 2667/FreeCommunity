//
//  CHTListViewController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTListViewController.h"
#import "CHTListHeader.h"
#import "CHTNewTopicViewController.h"

@interface CHTListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CHTListView *myView;
@property (nonatomic, assign) CHTListSortedType currentType;

@end

@implementation CHTListViewController

- (void)loadView {
    self.myView = [[CHTListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.myView;
    self.myView.tableView.estimatedRowHeight = 100;
    self.myView.tableView.delegate = self;
    self.myView.tableView.dataSource = self;
    
    [self.myView.tableView registerNib:[UINib nibWithNibName:@"CHTListCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRightItem];
    self.currentType = CHTListSortedTypeCreatTime;
    self.navigationItem.title = self.categoryName;
    [self makeData];
    // Do any additional setup after loading the view.
}

- (void)makeRightItem {
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeAction)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)]];
}

- (void)composeAction {
    CHTNewTopicViewController *nvc = [[CHTNewTopicViewController alloc] init];
    nvc.subCategoryName = self.categoryName;
    nvc.subCategoryID = self.subCategoryID;
    [self.navigationController pushViewController:nvc animated:YES];
}

- (void)refreshAction {
    
}

- (void)makeData {
    [[CHTListManager shareInstance] loadDataWithSubCategoryID:self.subCategoryID sortType:self.currentType page:1 finish:^{
        [self.myView.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[CHTListManager shareInstance] countOfDataType:CHTListSortedTypeCreatTime];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTListModel *model = [[CHTListManager shareInstance] modelOfCurrentType:self.currentType index:indexPath.row];
    CHTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTListModel *model = [[CHTListManager shareInstance] modelOfCurrentType:self.currentType index:indexPath.row];
    return [CHTListCell heightWith:model.title image:model.images.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
