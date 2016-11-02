# TTAlert

这是一个自定义AlertView遮罩层，返回用block.

## 使用方法
```objc
#import "TTAlert.h"   
@property (nonatomic, strong) TTAlert * alert;   
   
- (TTAlert *)alert{   
    if (!_alert) {   
        _alert = [[TTAlert alloc] init];   
    }   
    return _alert;   
}   
   
[self.alert show];   
```
   

## alert类型   
```objc
typedef NS_ENUM(int, TTAlertType) {   
    TTAlertTypeNormal,     // 提示类型（普通提示 normal）只有确定按钮   
    TTAlertTypeSuccessful, // 提示类型（成功提示 successful）只有确定按钮，顶部有✅对勾标志   
    TTAlertTypeDoubt	     // 提示类型（选择提示 doubt）有确定和取消按钮   
};   
```

## 其他可自定义的属性 
```objc
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
   
-(void)didConfirm:(void (^)(UIButton * button))didConfirm;  //点击确定时返回的block   
-(void)didCancel:(void (^)(UIButton * button))didCancel;    //点击取消时（如果有取消按钮）返回的block   
-(void)didDisappear:(void (^)(UIButton * button))didDisappear; //alert消失时返回的block   
```
