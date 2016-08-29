//
//  CHTTopicDetailViewController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTTopicDetailViewController.h"
#import "CHTNewTopicViewController.h"
#import "CHTTopicDetailHeader.h"
#import "CHTNavigationController.h"
#import "CHTImageLookViewController.h"

@interface CHTTopicDetailViewController ()<UITableViewDataSource, UITableViewDelegate, CHTAnswerDelegate>

@property (nonatomic, strong) CHTTopicDetailView *myView;
@property (nonatomic, strong) NSArray<CHTTopicDetailModel *> *dataArray;

@end

@implementation CHTTopicDetailViewController

- (void)loadView {
    self.myView = [[CHTTopicDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myView.headerModel = self.listModel;
    self.view = self.myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主题帖";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(makeData)];
    [self makeData];
    self.myView.tableView.dataSource = self;
    self.myView.tableView.delegate = self;
    self.myView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myView.tableView registerNib:[UINib nibWithNibName:@"CHTTopicDetailMainCell" bundle:nil] forCellReuseIdentifier:@"topicDetailMainCell"];
    self.myView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeData];
    }];
    self.myView.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSInteger count = [[CHTTopicDetailManager shareInstance] countOfData];
        [self.view showHUD];
        [[CHTTopicDetailManager shareInstance] loadMoreData:self.listModel skip:count - 1 finish:^{
            [self.view hideHUD];
            self.dataArray = [[CHTTopicDetailManager shareInstance] getArray];
            [self.myView.tableView reloadData];
            [self.myView.tableView.mj_footer endRefreshing];
        }];
    }];
    // Do any additional setup after loading the view.
}

- (void)makeData {
    [self.view showHUD];
    [[CHTTopicDetailManager shareInstance] loadData:self.listModel finish:^{
        [self.view hideHUD];
        self.dataArray = [[CHTTopicDetailManager shareInstance] getArray];
        [self.myView.tableView reloadData];
        [self.myView.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].subAnswers.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTTopicDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicDetailMainCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = [self modelOfIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CHTTopicDetailModel *)modelOfIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.dataArray[indexPath.section];
    } else {
        return self.dataArray[indexPath.section].subAnswers[indexPath.row - 1];
    }
}

- (void)answer:(NSIndexPath *)indexPath {
    CHTNewTopicViewController *nvc = [[CHTNewTopicViewController alloc] init];
    nvc.topicID = self.listModel.topicID;
    if (indexPath.section == 0) {
        nvc.answeredName = @"楼主";
        nvc.className = @"Topic";
        nvc.objectID = self.listModel.objectId;
    } else {
        CHTTopicDetailModel *model = [self modelOfIndexPath:indexPath];
        nvc.answeredName = model.userName;
        nvc.className = @"TopicAnswer";
        CHTTopicDetailModel *model1 = [self modelOfIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        nvc.objectID = model1.objectId;
    }
    nvc.subCategoryID = self.subCategoryID;
    [self.navigationController presentViewController:[[CHTNavigationController alloc] initWithRootViewController:nvc] animated:YES completion:nil];
}

- (void)clickImage:(NSInteger)index images:(NSArray *)imagesArray {
    CHTImageLookViewController *ivc = [[CHTImageLookViewController alloc] init];
    ivc.imagesArray = imagesArray;
    ivc.index = index;
    [self.navigationController.tabBarController presentViewController:ivc animated:NO completion:nil];
}

// 回复btn点击事件
- (void)clickAction {
    [self answer:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTTopicDetailModel *model = [self modelOfIndexPath:indexPath];
    CGFloat size = indexPath.row ? 13 : 15;
    CGFloat width = indexPath.row ? self.view.width - 60 : self.view.width - 20;
    if (model.height < 40) {
        model.height = [CHTTopicDetailMainCell heightWith:model.content imageCount:model.images.count fontSize:size labelWidth:width];
    }
    return model.height;
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
