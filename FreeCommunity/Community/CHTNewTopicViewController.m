//
//  CHTNewTopicViewController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/24.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTNewTopicViewController.h"
#import "CHTNewTopicHeader.h"
#import <Photos/Photos.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>

@interface CHTNewTopicViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) CHTNewTopicView *myView;

@end

@implementation CHTNewTopicViewController

- (void)loadView {
    
    self.myView = [[CHTNewTopicView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myView.placeHolder = @"请输入内容";
    self.view = self.myView;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myView.textField becomeFirstResponder];
    self.myView.label.text = self.subCategoryName;
    self.navigationItem.title = @"发表帖子";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightAction)];
    if (self.topicID) {
        self.navigationItem.title = @"回复";
        self.myView.textField.hidden = YES;
        self.myView.label.hidden = YES;
        self.myView.placeHolder = [NSString stringWithFormat:@"回复%@", self.answeredName];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
        [self.myView.textField resignFirstResponder];
        [self.myView.textView becomeFirstResponder];
    }
    // Do any additional setup after loading the view.
}

- (void)cancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightAction {
    if (self.topicID) {
        [self answerAction];
        return;
    }
    CHTListModel *model = [[CHTListModel alloc] initAsNewModel];
    model = [self.myView setTopicModel:model];
    if (model.title.length == 0) {
        [MBProgressHUD showToastTitle:@"标题不能为空!" seconds:1 onView:self.view];
        return;
    } else if (model.content.length == 0 && model.images.count == 0) {
        [MBProgressHUD showToastTitle:@"内容不能为空!" seconds:1 onView:self.view];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *imagesUrlArray = [NSMutableArray array];
        for (int i = 0; i < model.images.count; i++) {
            NSData *data = UIImagePNGRepresentation(model.images[i]);
            AVFile *file = [AVFile fileWithName:@"image.png" data:data];
            if ([file save]) {
                [imagesUrlArray addObject:file.url];
            }
        }
        model.images = imagesUrlArray;
        AVObject *object = [AVObject objectWithClassName:@"Topic" dictionary:[model dictOfModel]];
        [object setObject:self.subCategoryID forKey:@"subCategoryID"];
        [object setObject:@"匿名用户" forKey:@"userName"];
        [object removeObjectForKey:@"height"];
        if ([object save]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showToastTitle:@"发表成功！" seconds:1 onView:[UIApplication sharedApplication].keyWindow];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showToastTitle:@"发表失败" seconds:1 onView:[UIApplication sharedApplication].keyWindow];
            });
        }
    });
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)answerAction {
    CHTListModel *model = [[CHTListModel alloc] init];
    model = [self.myView setTopicModel:model];
    if (model.content.length == 0 && model.images.count == 0) {
        [MBProgressHUD showToastTitle:@"回复内容不能为空!" seconds:1 onView:self.view];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *imagesUrlArray = [NSMutableArray array];
        for (int i = 0; i < model.images.count; i++) {
            NSData *data = UIImagePNGRepresentation(model.images[i]);
            AVFile *file = [AVFile fileWithName:@"image.png" data:data];
            if ([file save]) {
                [imagesUrlArray addObject:file.url];
            }
        }
        model.images = imagesUrlArray;
        AVObject *object = [AVObject objectWithClassName:@"TopicAnswer" dictionary:[model dictOfModel]];
        [object setObject:self.topicID forKey:@"topicID"];
        [object setObject:@"匿名用户" forKey:@"userName"];
        [object removeObjectForKey:@"title"];
        [object removeObjectForKey:@"height"];

        if ([object save]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showToastTitle:@"发表成功！" seconds:1 onView:[UIApplication sharedApplication].keyWindow];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showToastTitle:@"发表失败" seconds:1 onView:[UIApplication sharedApplication].keyWindow];
            });
        }
    });
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardShow:(NSNotification *)sender {
    CGFloat height = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (height) {
        [self.myView showKeyboard:height];
    }
}

- (void)keyboardHide:(NSNotification *)sender {
    [self.myView hideKeyboard];
}

- (void)addImageAction {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
//    picker.allowsEditing = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhoto];
    }]];
    if (self.topicID) {
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self.navigationController.tabBarController presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.myView addImage:image];
}

// 相册选择照片
- (void)selectPhoto {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            // 显示选择的索引
            picker.showsSelectionIndex = YES;
            // 设置相册的类型：相机胶卷 + 自定义相册
            picker.assetCollectionSubtypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),@(PHAssetCollectionSubtypeAlbumRegular)];
            // 不需要显示空的相册
            picker.showsEmptyAlbums = NO;
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}


- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset {
    NSInteger max = 9 - [self.myView countOfImages];
    if (picker.selectedAssets.count < max) {
        return YES;
    } else {
        [MBProgressHUD showToastTitle:[NSString stringWithFormat:@"最多只能选取%ld张图片", max] seconds:1 onView:picker.view];
        return NO;
    }
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    // 关闭图片选择界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 将图片添加到view上
    [self addImage:0 assets:assets];

}

- (void)addImage:(NSInteger)index assets:(NSArray *)assets {
    if (index >= assets.count) {
        return;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHAsset *asset = assets[index];
    CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
    // 获取图片
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.myView addImage:result];
        [self addImage:index + 1 assets:assets];

    }];
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
