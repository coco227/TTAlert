//
//  TTAlert.m
//  TTAlert
//
//  Created by user on 16/9/27.
//  Copyright © 2016年 Zhentao Zhang. All rights reserved.
//

#import "TTAlert.h"

#define kWidth  255
#define kHeight 180
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface TTAlert()

@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) UIButton * dismissBtn;

@property (nonatomic) float keyboardHeight;

@end

@implementation TTAlert

- (instancetype)init{
    self=[super init];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 10000;
        self.frame = [UIScreen mainScreen].bounds;
        self.haveCancelBtn = NO;
        [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 10000;
        self.haveCancelBtn = NO;
        [self createView];
    }
    return self;
}

- (void)dealloc{
    [self resignKeyWindow];
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)createView{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg.png"]];
    [self.bgView.layer setCornerRadius:10.0];
    [self.bgView.layer setMasksToBounds:YES];
    
    [self addSubview:self.bgView];
    [self addSubview:self.iconView];
    [self addSubview:self.titleTextLabel];
    [self addSubview:self.messageTextLabel];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.confirmBtn];
    
    [self addSubview:self.dismissBtn];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - 公共方法
- (void)show {
    self.hidden = NO;
    [self makeKeyAndVisible];
}

- (void)dismiss {
    [self resignKeyWindow];
    self.hidden = YES;
    [[UIApplication sharedApplication].windows.lastObject removeFromSuperview];
    if (_disappear) {
        _disappear(nil);
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *notiInfo = [notification userInfo];
    CGRect keyboardRect = [[notiInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    
    if (iPhone4 || iPhone5) {
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(self.center.x,
                                      self.center.y - 50);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification{
    if (iPhone4 || iPhone5) {
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(self.center.x,
                                      self.center.y + 50);
        }];
    }
}

#pragma mark - 私有方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)confirm:(UIButton *)btn{
    if (_confirm) {
        _confirm(btn);
    }
    [self dismiss];
}

- (void)cancel:(UIButton *)btn{
    if (_cancel) {
        _cancel(btn);
    }
    [self dismiss];
}

-(void)didConfirm:(void (^)(UIButton * button))didConfirm{
    _confirm = didConfirm;

}

-(void)didCancel:(void (^)(UIButton *))didCancel{
    _cancel = didCancel;
}

- (void)didDisappear:(void (^)(UIButton *))didDisappear{
    _disappear = didDisappear;
}

#pragma mark - setter & getter
- (void)setHaveCancelBtn:(BOOL)haveCancelBtn{
    _haveCancelBtn = haveCancelBtn;
    if (_haveCancelBtn) {
        _confirmBtn.frame = CGRectMake(kWidth/2,
                                       kHeight - 40,
                                       kWidth/2 + 1,
                                       40);
        _dismissBtn.hidden = YES;
    }else{
        _confirmBtn.frame = CGRectMake(0,
                                       kHeight - 40,
                                       kWidth,
                                       40);
        _dismissBtn.hidden = NO;
    }
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    _iconView.image = icon;
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    _titleTextLabel.text = titleText;
}

- (void)setMessageText:(NSString *)messageText{
    _messageText = messageText;
    _messageTextLabel.text = messageText;
}

- (void)setConformBtnTitle:(NSString *)conformBtnTitle{
    _conformBtnTitle = conformBtnTitle;
    [_confirmBtn setTitle:_conformBtnTitle forState:UIControlStateNormal];
}

- (void)setType:(TTAlertType)type{
    _titleTextLabel.frame = CGRectMake(_bgView.frame.origin.x,
                                       _bgView.frame.origin.y + 50,
                                       kWidth, 18);
    if (type == TTAlertTypeNormal) {
        _iconView.image = nil;
        self.haveCancelBtn = NO;
        self.titleTextLabel.center = CGPointMake(self.center.x, self.center.y - 50);
    }
    if (type == TTAlertTypeSuccessful) {
        _iconView.image = [UIImage imageNamed:@"success"];
        self.haveCancelBtn = NO;
    }
    if (type == TTAlertTypeDoubt) {
        _iconView.image = nil;
        self.haveCancelBtn = YES;
        self.titleTextLabel.center = CGPointMake(self.center.x, self.center.y - 50);
    }
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 0, kWidth, kHeight);
        _bgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                     [UIScreen mainScreen].bounds.size.height/2);
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(0, 0, kWidth, 125);
        _iconView.center = CGPointMake(_bgView.center.x, _bgView.frame.origin.y);
        _iconView.contentMode = UIViewContentModeCenter;
    }
    return _iconView;
}

- (UILabel *)titleTextLabel{
    if (!_titleTextLabel) {
        _titleTextLabel = [[UILabel alloc] init];
        _titleTextLabel.frame = CGRectMake(_bgView.frame.origin.x,
                                           _bgView.frame.origin.y + 50,
                                           kWidth, 18);
        _titleTextLabel.font = [UIFont systemFontOfSize:16];
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.textColor = [UIColor colorWithRed:234/255.0
                                                    green:63/255.0
                                                     blue:79/255.0 alpha:1.0];
//        _titleTextLabel.text = @"title";
    }
    return _titleTextLabel;
}

- (UITextView *)messageTextLabel{
    if (!_messageTextLabel) {
        _messageTextLabel = [[UITextView alloc] init];
        _messageTextLabel.frame = CGRectMake(_bgView.frame.origin.x,
                                           _bgView.frame.origin.y + 70,
                                           kWidth, 65);
        _messageTextLabel.font = [UIFont systemFontOfSize:14];
        _messageTextLabel.textAlignment = NSTextAlignmentCenter;
        _messageTextLabel.textColor = [UIColor colorWithRed:34/255.0
                                                    green:34/255.0
                                                     blue:34/255.0 alpha:1.0];
        _messageTextLabel.editable = NO;
//        _messageTextLabel.text = @"message fdshygoa";
//        _messageTextLabel.backgroundColor = [UIColor greenColor];
    }
    return _messageTextLabel;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.frame = CGRectMake(0,
                                      kHeight - 40,
                                      kWidth/2,
                                      40);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor colorWithRed:245/255.0
                                                       green:245/255.0
                                                        blue:245/255.0 alpha:1.0]];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:153/255.0
                                                  green:153/255.0
                                                   blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        if (_haveCancelBtn) {
            _confirmBtn.frame = CGRectMake(kWidth/2,
                                           kHeight - 40,
                                           kWidth/2 + 1,
                                           40);
        }else{
            _confirmBtn.frame = CGRectMake(0,
                                           kHeight - 40,
                                           kWidth,
                                           40);
        }
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:234/255.0
                                                        green:63/255.0
                                                         blue:79/255.0 alpha:1.0]];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [[UIButton alloc] init];
        _dismissBtn.frame = CGRectMake(_bgView.frame.origin.x + _bgView.frame.size.width,
                                       _bgView.frame.origin.y - 20,
                                       20,
                                       20);
        [_dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _dismissBtn.contentMode = UIViewContentModeScaleAspectFill;
        [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

@end
