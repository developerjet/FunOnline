//
//  MineTableViewCell.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MineTableViewCell.h"

@interface MineTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel     *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel     *leftLabel;
@property (weak, nonatomic) IBOutlet UIView      *lineView;

@end

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(MineModel *)model {
    _model = model;
    
    self.leftLabel.text    = model.title;
    self.leftImgView.image = [UIImage imageNamed:model.image];
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    
    self.lineView.hidden = hideLine;
}

- (void)setHideArrow:(BOOL)hideArrow {
    _hideArrow = hideArrow;
    
    self.arrowView.hidden = hideArrow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
