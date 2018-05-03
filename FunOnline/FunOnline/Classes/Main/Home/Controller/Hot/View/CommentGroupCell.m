//
//  CommentGroupCell.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "CommentGroupCell.h"

@interface CommentGroupCell()
/** 用户头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 用户名称 */
@property (nonatomic, strong) UILabel *usernameLabel;
/** 评论内容 */
@property (nonatomic, strong) UILabel *commentLabel;
/** 点赞量 */
@property (nonatomic, strong) UIButton *starButton;
/** 评论时间 */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CommentGroupCell

#pragma mark - initial

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        _usernameLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        _usernameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_usernameLabel];
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#989898"];
        [self.contentView addSubview:_commentLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
        
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _starButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _starButton.titleEdgeInsets = UIEdgeInsetsMake(2, 10, 0, 0);
        _starButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_starButton setImage:[UIImage imageNamed:@"icon_gray_star"] forState:UIControlStateNormal];
        [_starButton setTitleColor:[UIColor colorWithHexString:@"989898"] forState:UIControlStateNormal];
        [self.contentView addSubview:_starButton];
    }
    return self;
}

#pragma mark - Private Setter

- (void)setComment:(Comment *)comment {
    _comment = comment;
    
    self.commentLabel.text  = comment.content;
    self.usernameLabel.text = comment.user.name;
    self.timeLabel.text     = [NSString conversionDate:comment.atime];
    [self.avatarImageView downloadImage:comment.user.avatar placeholder:@"icon_default_avatar"];
    [self.starButton setTitle:[NSString stringWithFormat:@"%ld", comment.user.following] forState:UIControlStateNormal];
}

- (void)adjustLayout
{
    self.avatarImageView.frame = self.comment.avatarFrame;
    self.usernameLabel.frame = self.comment.usernameFrame;
    self.timeLabel.frame = self.comment.timeFrame;
    self.commentLabel.frame = self.comment.connectFrame;
    self.starButton.frame = self.comment.statFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self adjustLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
