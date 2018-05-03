//
//  FeedBackDropMenu.m
//  FunOnline
//
//  Created by Original_TJ on 2018/4/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FeedBackDropMenu.h"

#define MAX_LIMIT_NUMS  160

@interface FeedBackDropMenu()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *numberTxFiled;
@property (nonatomic, strong) UITextView  *commentTxView;
@property (nonatomic, strong) UIView      *customMenuView;
@property (nonatomic, strong) UIView      *customLineView;
@property (nonatomic, strong) UILabel     *placeholdLabel;

@end

@implementation FeedBackDropMenu

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        
        [self initSubview];
        [self addConstraints];
    }
    return self;
}

- (void)initSubview
{
    self.customMenuView = [[UIView alloc] init];
    self.customMenuView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self addSubview:self.customMenuView];
    
    UIFont *defaultFont = [UIFont systemFontOfSize:16];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
    label.font = defaultFont;
    label.text = @"联系电话";
    label.textAlignment = NSTextAlignmentCenter;
    self.numberTxFiled = [[UITextField alloc] init];
    self.numberTxFiled.delegate = self;
    self.numberTxFiled.leftView = label;
    self.numberTxFiled.font = defaultFont;
    self.numberTxFiled.keyboardType = UIKeyboardTypePhonePad;
    self.numberTxFiled.backgroundColor = [UIColor whiteColor];
    self.numberTxFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numberTxFiled.textColor = COLORHEX(@"323232");
    self.numberTxFiled.placeholder = @"请输入您的手机号码";
    self.numberTxFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.customMenuView addSubview:self.numberTxFiled];
    
    self.customLineView = [[UIView alloc] init];
    self.customLineView.backgroundColor = COLORHEX(@"e8e8e8");
    [self.customMenuView addSubview:self.customLineView];
    
    self.commentTxView = [[UITextView alloc] init];
    self.commentTxView.delegate = self;
    self.commentTxView.font = defaultFont;
    self.commentTxView.backgroundColor = COLORHEX(@"FFFFFF");
    [self addSubview:self.commentTxView];
    
    self.placeholdLabel = [[UILabel alloc] init];
    self.placeholdLabel.textColor = COLORHEX(@"DCDCDC");
    self.placeholdLabel.font = defaultFont;
    self.placeholdLabel.text = @"请输入反馈，我们将不断为您改进";
    [self addSubview:self.placeholdLabel];
}

- (void)addConstraints
{
    [self.customMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@50.5);
    }];
    
    [self.customLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.customMenuView);
        make.height.equalTo(@0.5);
    }];
    
    [self.numberTxFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.customMenuView);
        make.bottom.equalTo(self.customLineView.mas_top);
        make.right.equalTo(self.customMenuView).offset(-35);
        make.height.equalTo(@50);
    }];
    
    [self.commentTxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customMenuView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@140);
    }];
    
    [self.placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentTxView).offset(5);
        make.top.equalTo(self.commentTxView).offset(8);
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:DidTextFieldEditing:)]) {
        
        [self.delegate menu:self DidTextFieldEditing:textField.text];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:DidTextViewEditing:)]) {
        
        [self.delegate menu:self DidTextViewEditing:textView.text];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.placeholdLabel.hidden = textView.text.length;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([textField isEqual:self.numberTxFiled] && string.length > 0) {
        if ([textField.text trimAll].length >= 11) {
            [self showAlert:@"手机号码长度限制"];
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [self showAlert:[NSString stringWithFormat:@"最多只能输入%d个字", MAX_LIMIT_NUMS]];
        
        return NO;
    }
}

- (void)showAlert:(NSString *)content
{
    [LEEAlert alert].config
    .LeeTitle(@"温馨提示")
    .LeeContent(content)
    .LeeAction(@"OK", ^{
        // 点击事件Block
    })
    .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
    .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
    .LeeShow();
}


@end
