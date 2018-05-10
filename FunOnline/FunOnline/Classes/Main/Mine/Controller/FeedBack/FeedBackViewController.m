//
//  FeedBackViewController.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FeedBackViewController.h"
#import <TZImagePickerController.h>
#import "FeedBackPhotoCell.h"
#import "FeedBackDropMenu.h"

#define kColumn     4
#define spacing     10
#define kMaxCount   6 // 图片最多数

#define itemWidth   ((SCREEN_WIDTH-(kColumn + 1) * spacing) / kColumn) - 5
#define itemHeight  itemWidth

static NSString *const kFeedBackCellIdentifier = @"kFeedBackCellIdentifier";

@interface FeedBackViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
TZImagePickerControllerDelegate, FeedBackDropMenuDelegate>

@property (nonatomic, strong) FeedBackDropMenu *dropMenuView;
@property (nonatomic, strong) UIButton         *completeBtn;
@property (nonatomic, strong) UIImage          *addImage;

@property (nonatomic, strong) NSMutableArray *photoObjects;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isVisibleAdds;  //是否还能添加
@property (nonatomic, assign) BOOL isVisibleMore; //是否更多操作

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *comment;

@end

@implementation FeedBackViewController

#pragma mark - Lazys

- (UIImage *)addImage {
    
    if (!_addImage) {
        
        _addImage = [UIImage imageNamed:@"feedback_add"];
    }
    return _addImage;
}

- (NSMutableArray *)photoObjects
{
    if (!_photoObjects)
    {
        _photoObjects = [NSMutableArray arrayWithCapacity:0];
        [_photoObjects insertObject:self.addImage atIndex:_photoObjects.count];
    }
    return _photoObjects;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"反馈意见";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    
    [self initSubview];
}

- (void)initSubview
{
    self.isVisibleAdds = YES; //默认可以添加
    self.isVisibleMore = NO;
    
    self.dropMenuView = [[FeedBackDropMenu alloc] init];
    self.dropMenuView.delegate = self;
    [self.view addSubview:self.dropMenuView];
    
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedBackPhotoCell" bundle:nil] forCellWithReuseIdentifier:kFeedBackCellIdentifier];
    [self.view addSubview:self.collectionView];
    
    self.completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.completeBtn.backgroundColor = [UIColor colorThemeColor];
    [self.completeBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.completeBtn addTarget:self action:@selector(completeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.completeBtn];
    
    [self addConstraints];
}

- (void)addConstraints
{
    [self.dropMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@190.5);
    }];
    
    CGFloat item_height = itemHeight + 2*spacing;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dropMenuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(item_height));
    }];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.height.equalTo(@44);
    }];
    
    self.completeBtn.layer.cornerRadius = 22.0;
    self.completeBtn.layer.masksToBounds = YES;
}

// 更新图片容器高度
- (void)updateConstraints
{
    CGFloat item_height = itemHeight + 2*spacing;
    CGFloat newHeight = item_height;
    
    if (self.photoObjects.count % kColumn != 0) {
        int remain = self.photoObjects.count % kColumn;
        newHeight = (((self.photoObjects.count - remain) / kColumn) * item_height) + item_height;
    }else {
        newHeight = (self.photoObjects.count / kColumn) * item_height;
    }
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dropMenuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(newHeight));
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - action

- (void)completeEvent:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![NSString isValidateHomePhoneNum:_number]) {
        [XDProgressHUD showHUDWithText:@"请填写正确的手机号码" hideDelay:1.0];
        return;
    }if (!_comment || _comment.length <= 10) {
        [XDProgressHUD showHUDWithText:@"请输入至少10个字符的反馈信息" hideDelay:1.0];
        return;
    }if (self.photoObjects.count <= 1) {
        [XDProgressHUD showHUDWithText:@"请上传至少一张图片" hideDelay:1.0];
        return;
    }
    
    [XDProgressHUD showHUDWithIndeterminate:@"正在提交，请稍等..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XDProgressHUD showHUDWithText:@"提交成功" hideDelay:1.0];
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - FeedBackDropMenuDelegate

- (void)menu:(FeedBackDropMenu *)menu DidTextFieldEditing:(NSString *)text {
    
    self.number = text;
}

- (void)menu:(FeedBackDropMenu *)menu DidTextViewEditing:(NSString *)text {
    
    self.comment = text;
}

#pragma mark - UICollectionView for data

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedBackPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedBackCellIdentifier forIndexPath:indexPath];
    if (self.photoObjects.count > indexPath.row)
    {
        cell.photoImageView.image = self.photoObjects[indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionView for delegate
// 照片选择处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    
    if (indexPath.row == self.photoObjects.count-1) {
        if (self.isVisibleAdds) {
            if (self.photoObjects.count == 1) {
                [self showAddSheet];
            }
            [self showAddSheet];
        }else {
            [self showMoreSheet];
        }
    }else {
        [self showMoreSheet];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

#pragma mark - Photo for handel

- (void)showAddSheet
{
    self.isVisibleMore = NO;
    
    WeakSelf;
    [LEEAlert actionsheet].config
    .LeeAction(@"拍照", ^{
        [weakSelf openCamera];
    })
    .LeeAction(@"从相册选择", ^{
        [weakSelf openAlbum];
    })
    .LeeCancelAction(@"取消", ^{
        // 点击事件Block
        self.isVisibleMore = YES;
    })
    .LeeShow();
}

- (void)showMoreSheet
{
    self.isVisibleMore = YES;
    
    WeakSelf;
    [LEEAlert actionsheet].config
    .LeeAction(@"拍照", ^{
        [weakSelf openCamera];
    })
    .LeeAction(@"从相册选择", ^{
        [weakSelf openAlbum];
    })
    .LeeAction(@"删除", ^{
        if (weakSelf.photoObjects.count) {
            if (weakSelf.photoObjects.count == kMaxCount) {
                if (!self.isVisibleAdds) {
                    [weakSelf.photoObjects addObject:self.addImage];
                    self.isVisibleAdds = YES;
                }
            }
            
            [weakSelf.photoObjects removeObjectAtIndex:self.selectIndex];
        }
        
        [weakSelf updateConstraints];
        [weakSelf.collectionView reloadData];
    })
    .LeeCancelAction(@"取消", ^{
        // 点击事件Block
        self.isVisibleAdds = NO;
        self.isVisibleMore = NO;
    })
    .LeeShow();
}

- (void)openCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        [LEEAlert alert].config
        .LeeTitle(@"温馨提示")
        .LeeContent(@"当前设备没有可用的摄像头")
        .LeeAction(@"OK", ^{
            // 点击事件Block
        })
        .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
        .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
        .LeeShow();
    }
}

- (void)openAlbum
{
    WeakSelf;
    NSInteger maxCount = (kMaxCount + 1) - self.photoObjects.count;
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePicker.navigationBar.barTintColor = [UIColor colorThemeColor];
    
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, NSArray<NSDictionary *> *infos) {
        
        for (int idx = 0; idx < photos.count; idx++)
        {
            UIImage *originImage = photos[idx];
            UIImage *newImage = [originImage imageToImageMaxWidthOrHeight:600];
            if (self.isVisibleMore) {   
                [weakSelf.photoObjects replaceObjectAtIndex:self.selectIndex withObject:newImage];
            }else {
                [weakSelf.photoObjects insertObject:newImage atIndex:weakSelf.photoObjects.count - 1];
            }
        }
        [weakSelf updateObjects];
    }];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)updateObjects {

    self.isVisibleAdds = self.photoObjects.count == kMaxCount + 1 ? NO : YES;
    
    if (self.photoObjects.count > kMaxCount) {
        self.isVisibleAdds = NO;
        [self.photoObjects removeObjectAtIndex:self.photoObjects.count - 1];
    }
    
    [self updateConstraints];
    [self.collectionView reloadData];
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = nil;
    if ([type isEqualToString:@"public.image"]) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    UIImage *newPhoto = [image imageToImageMaxWidthOrHeight:600];
    
    if (self.photoObjects.count) {
        if (self.isVisibleMore) {
            [self.photoObjects replaceObjectAtIndex:self.selectIndex withObject:newPhoto];
        }else {
            [self.photoObjects insertObject:newPhoto atIndex:self.photoObjects.count - 1];
        }
    }
    
    [self updateObjects];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
