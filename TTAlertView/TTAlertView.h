//
//  TTAlertView.h
//  TTAlertView
//
//  Created by user on 16/9/27.
//  Copyright © 2016年 Zhentao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**默认类型*/
typedef NS_ENUM(int, TTAlertType) {
    TTAlertTypeNormal,     // 提示类型（普通提示 normal）
    TTAlertTypeSuccessful, // 提示类型（成功提示 successful）
    TTAlertTypeDoubt	   // 提示类型（选择提示 doubt）
};

typedef void (^didConfirm)(UIButton * button);

typedef void (^didCancel)(UIButton * button);

typedef void (^didDisappear)(UIButton * button);

@interface TTAlertView : UIWindow
{
    didConfirm _confirm;
    didCancel  _cancel;
    didDisappear _disappear;
}

/** 提示类型*/
@property (nonatomic) TTAlertType type;
/**顶部图片*/
@property (nonatomic, strong) UIImage * icon;
/**标题*/
@property (nonatomic, copy) NSString * titleText;
/**标题Label*/
@property (nonatomic, strong) UILabel * titleTextLabel;
/**内容*/
@property (nonatomic, copy) NSString * messageText;
/**内容Label*/
@property (nonatomic, strong) UITextView * messageTextLabel;
/**确认按钮*/
@property (nonatomic, strong) UIButton * confirmBtn;
/**确认按钮文字*/
@property (nonatomic, copy) NSString * conformBtnTitle;
/**取消按钮(默认不显示)*/
@property (nonatomic, strong) UIButton * cancelBtn;
/**是否有取消按钮，默认“NO”*/
@property (nonatomic) BOOL  haveCancelBtn;
// 显示
- (void)show;
// 消失
- (void)dismiss;

-(void)didConfirm:(void (^)(UIButton * button))didConfirm;
-(void)didCancel:(void (^)(UIButton * button))didCancel;
-(void)didDisappear:(void (^)(UIButton * button))didDisappear;
@end
