//
//  NewsTableViewCell.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *elevationView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setModel:(NewsModel *)model {
    
    _model = model;
    
    self.timeLabel.text  = model.pubDate;
    self.descLabel.text  = model.desc;
    self.countLabel.text = model.views;
    self.titleLabel.text = model.title;
    [self.elevationView downloadImage:model.litpic placeholder:@"icon_loading_image"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
