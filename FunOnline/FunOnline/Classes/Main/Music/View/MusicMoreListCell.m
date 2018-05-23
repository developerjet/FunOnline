//
//  MusicMoreListCell.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicMoreListCell.h"

@interface MusicMoreListCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation MusicMoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
}

- (void)setModel:(MusicPlayModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.descLabel.text  = model.intro ? model.intro : model.nickname;
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld集", model.commentsCount];
    [self.coverImageView downloadImage:model.coverMiddle ? model.coverMiddle : model.coverPath placeholder:@"icon_default_image"];
    self.createTimeLabel.text = model.createdAt ? [NSString conversionDate:[NSString stringWithFormat:@"%ld", [model.createdAt integerValue] / 1000]] : @"";
    self.playCountLabel.text = model.playsCounts ? [NSString stringWithFormat:@"%.f万", model.playsCounts / 10000.0] : [NSString stringWithFormat:@"%.f万", model.playtimes / 10000.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
