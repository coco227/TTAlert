//
//  ViewController.m
//  TTAlertViewExample
//
//  Created by user on 2016/10/31.
//  Copyright © 2016年 Zhentao Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TTAlert.h"

@interface ViewController ()

- (IBAction)showNormalView:(id)sender;

- (IBAction)showSuccessfulView:(id)sender;

- (IBAction)showDoubtView:(id)sender;

@property (nonatomic, strong) TTAlert * alert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showNormalView:(id)sender {
    self.alert.type = TTAlertTypeNormal;
    self.alert.titleText = @"normalAlert";
    self.alert.messageText = @"This is a normal AlertView";
    
    [self.alert didConfirm:^(UIButton *button) {
        NSLog(@"confirmBtn has been pressed - confirmBtn : %@",button);
    }];
    
    [self.alert didCancel:nil];
    
    [self.alert didDisappear:^(UIButton *button) {
        NSLog(@"the alert has been dismissed");
    }];
    
    [self.alert show];
}

- (IBAction)showSuccessfulView:(id)sender {
    
    self.alert.type = TTAlertTypeSuccessful;
    self.alert.titleText = @"successfulAlert";
    self.alert.messageText = @"This is a successful AlertView";
    
    [self.alert didConfirm:^(UIButton *button) {
        NSLog(@"confirmBtn has been pressed - confirmBtn : %@ \n",button);
    }];
    
    [self.alert didCancel:nil];
    
    [self.alert didDisappear:^(UIButton *button) {
        NSLog(@"the alert has been dismissed \n");
    }];
    
    [self.alert show];
}

- (IBAction)showDoubtView:(id)sender {
    
    self.alert.type = TTAlertTypeDoubt;
    self.alert.titleText = @"doubtAlert";
    self.alert.messageText = @"This is a doubt AlertView";
    
    [self.alert didConfirm:^(UIButton *button) {
        NSLog(@"confirmBtn has been pressed - confirmBtn : %@ \n",button);
    }];
    [self.alert didCancel:^(UIButton *button) {
        NSLog(@"cancelBtn has been pressed - cancelBtn : %@ \n",button);
    }];
    [self.alert didDisappear:^(UIButton *button) {
        NSLog(@"the alert has been dismissed");
    }];
    
    [self.alert show];
}

#pragma mark - TTAlertView getter & setter
- (TTAlert *)alert{
    if (!_alert) {
        _alert = [[TTAlert alloc] init];
    }
    return _alert;
}

@end
