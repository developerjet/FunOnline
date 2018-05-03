//
//  MusicClassifyCell.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MusicClassifyCell.h"

@interface MusicClassifyCell()

@property (weak, nonatomic) IBOutlet UIImageView *screenImgView;
@property (weak, nonatomic) IBOutlet UILabel  *classifyLabel;

@end

@implementation MusicClassifyCell

#pragma mark - Initial

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.screenImgView.backgroundColor = [UIColor colorWithRandom];
}

#pragma mark - Setter

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)setModel:(MusicClassModel *)model {
    _model = model;
    
    self.classifyLabel.text = model.tname;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    self.screenImgView.image = [UIImage imageNamed:imageName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
