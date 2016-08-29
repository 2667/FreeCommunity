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
#import "CHTTopicDetailViewController.h"

@interface CHTListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CHTListView *myView;
@property (nonatomic, assign) CHTListSortedType currentType;

@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIView *btnBottomView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *nothingFooterView;

@property (nonatomic, strong) UIView *noMoreFooterView;

@end

@implementation CHTListViewController

- (void)loadView {
    self.myView = [[CHTListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.myView;
//    self.myView.tableView.estimatedRowHeight = 100;
    self.myView.tableView.delegate = self;
    self.myView.tableView.dataSource = self;
    
    [self.myView.tableView registerNib:[UINib nibWithNibName:@"CHTListCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getCount];
}

- (void)getCount {
    [[CHTListManager shareInstance] countOfTopic:self.subCategoryID finish:^(NSInteger count) {
        [self.myView setTopicCount:count];
    }];
    [[CHTListManager shareInstance] countOfAnswer:self.subCategoryID finish:^(NSInteger count) {
        [self.myView setAnswerCount:count];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRightItem];
    [self setupFooterView];
    self.currentType = CHTListSortedTypeCreatTime;
    self.navigationItem.title = self.categoryName;
    [self.view showHUD];
    [[CHTListManager shareInstance] loadDataWithSubCategoryID:self.subCategoryID type:YES finish:^(NSInteger count){
        [self.view hideHUD];
        self.myView.tableView.tableFooterView = count < 20 ? self.noMoreFooterView : nil;
        [self reloadTableView];
    }];
    self.myView.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.view showHUD];
        [[CHTListManager shareInstance] requestData:self.currentType isAdd:YES finish:^(NSInteger count){
            [self.view hideHUD];
            self.myView.tableView.tableFooterView = count < 20 ? self.noMoreFooterView : nil;
            [self.myView.tableView reloadData];
            [self.myView.tableView.mj_footer endRefreshing];
        }];
    }];
    self.myView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshAction];
        [self getCount];
    }];
    // Do any additional setup after loading the view.
}

- (void)setupFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 170)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"~~~暂时没有帖子~~~";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(30);
        make.centerX.equalTo(view);
    }];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nothing"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_top);
        make.centerX.equalTo(view);
        make.height.width.equalTo(@150);
    }];
    self.nothingFooterView = view;
    
    self.noMoreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor grayColor];
    label1.text = @"没有更多帖子了/(ㄒoㄒ)/~~";
    label1.font = [UIFont systemFontOfSize:13];
    [self.noMoreFooterView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.noMoreFooterView);
    }];
    
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
    [self.view showHUD];
    [[CHTListManager shareInstance] requestData:self.currentType isAdd:NO finish:^(NSInteger count){
        [self.view hideHUD];
        self.myView.tableView.tableFooterView = count < 20 ? self.noMoreFooterView : nil;
        [self.myView.tableView.mj_header endRefreshing];
        [self reloadTableView];
        if ([[CHTListManager shareInstance] countOfDataType:self.currentType]) {
            [self.myView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }];
    [[CHTListManager shareInstance] countOfTopic:self.subCategoryID finish:^(NSInteger count) {
        [self.myView setTopicCount:count];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[CHTListManager shareInstance] countOfDataType:self.currentType];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTListModel *model = [[CHTListManager shareInstance] modelOfCurrentType:self.currentType index:indexPath.row];
    CHTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTTopicDetailViewController *tvc = [[CHTTopicDetailViewController alloc] init];
    tvc.listModel = [[CHTListManager shareInstance] modelOfCurrentType:self.currentType index:indexPath.row];
    tvc.subCategoryID = self.subCategoryID;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTListModel *model = [[CHTListManager shareInstance] modelOfCurrentType:self.currentType index:indexPath.row];
    if (model.height < 20) {
        CGFloat height = [CHTListCell heightWith:model.title image:model.images.count];
        model.height = height;
    }
    return model.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.headerView == nil) {
        [self setupHeaderView];
    }
    return self.headerView;
}

- (void)clickAction:(UIButton *)sender {
    [self.tempBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sender setTitleColor:TOPIC_COLOR forState:UIControlStateNormal];
    self.tempBtn = sender;
    self.btnBottomView.center = CGPointMake(self.tempBtn.center.x, self.btnBottomView.center.y);

    CHTListSortedType type = sender.center.x / (self.view.width / 3);
    if (type == self.currentType) {
        return;
    }
    [[CHTListManager shareInstance] setOffsetY:self.myView.tableView.contentOffset.y sortedType:self.currentType];
    self.currentType = type;
    
    if ([[CHTListManager shareInstance] countOfDataType:self.currentType] == 0) {
        [self refreshAction];
        return;
    }
    
    [self reloadTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)setupHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, view.width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:line];
    NSArray *array = @[@"最新发表", @"最新回复", @"回复最多"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(view.width / 3 * i, 0, view.width / 3, 35);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i == 0) {
            self.tempBtn = btn;
            [btn setTitleColor:TOPIC_COLOR forState:UIControlStateNormal];
        }
    }
    self.btnBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, view.width / 3, 2)];
    self.btnBottomView.backgroundColor = TOPIC_COLOR;
    [view addSubview:self.btnBottomView];
    self.btnBottomView.center = CGPointMake(self.tempBtn.center.x, self.btnBottomView.center.y);
    self.headerView = view;
}

/**
 *  刷新tableView
 */
- (void)reloadTableView {
    [self.myView.tableView reloadData];
    NSInteger count = [[CHTListManager shareInstance] countOfDataType:self.currentType];
    self.myView.tableView.tableFooterView = count ? self.myView.tableView.tableFooterView : self.nothingFooterView;
    CGFloat y = [[CHTListManager shareInstance] getOffsetYWithType:self.currentType];
    self.myView.tableView.contentOffset = CGPointMake(0, y);
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
