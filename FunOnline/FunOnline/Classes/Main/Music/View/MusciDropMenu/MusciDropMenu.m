//
//  MusciDropMenu.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusciDropMenu.h"

@interface MusciDropMenu()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIImageView *screenImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLable;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@end

@implementation MusciDropMenu

+ (instancetype)loadNibDrop {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

#pragma mark - initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = COLORHEX(@"FFFFFF");
    self.autoresizingMask = UIViewAutoresizingNone;
    
    [self configSubview];
}

- (void)configSubview
{
    self.avatarImageView.layer.cornerRadius = 15.0;
    self.avatarImageView.layer.masksToBounds = YES;
    
    // 设置毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [self.effectView setEffect:blur];
}

#pragma mark - Setter

- (void)setAlbum:(AlbumModel *)album {
    _album = album;
    
    self.titleLabel.text = album.title;
    self.introLable.text = album.intro;
    self.nickNameLabel.text = album.nickname;
    self.tagsLabel.text = album.tags ? album.tags : @"暂无简介";
    [self.coverImageView downloadImage:album.coverMiddle placeholder:@"icon_default_image"];
    [self.avatarImageView downloadImage:album.avatarPath placeholder:@"icon_default_avatar"];
    [self.screenImageView downloadImage:album.coverOrigin placeholder:@"icon_loading_image"];
    NSString *title =  [NSString stringWithFormat:@"%.2f万", album.playTimes / (1000.0 * 1000.0)];
    [self.playCountLabel setTitle:title forState:UIControlStateNormal];
}

#pragma mark - action

- (IBAction)backEvent:(UIButton *)sender {
    
    if (self.backDidBlock) {
        self.backDidBlock();
    }
}
@end
