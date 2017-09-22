//
//  SignupViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *surepassTextField;
@property (weak, nonatomic) IBOutlet UITextField *verification;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_nameTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if (_passTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if (_nicknameTextField.text.length < 6 || _nicknameTextField.text.length > 18) {
        [Utilities popUpAlertViewWithMsg:@"您输入的字符必须在6—18位之间" andTitle:nil onView:self];
        return;
    }
    if (_surepassTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请在确认密码输入框输入密码" andTitle:nil onView:self];
        return;
    }
    if (_verification.text.length == 0 ) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的四位验证码" andTitle:nil onView:self];
        return;
    }
    if (_surepassTextField.text != _passTextField.text ) {
        [Utilities popUpAlertViewWithMsg:@"请输入与密码输入框相同的密码" andTitle:nil onView:self];
        return;
    }
    if (_passTextField.text.length < 6 || _passTextField.text.length > 18) {
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6—18位之间" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    if (_nameTextField.text.length < 11 || [_nameTextField.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet]invertedSet]].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:@"您输入不小于11位的手机号码" andTitle:nil onView:self];
        return;
    }
    //无输入异常的情况
    [self readyForEncoding];
    
}
- (void)readyForEncoding{
    // 创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    //开始请求
    [RequestAPI requestURL:@"/register" withParameters:@{@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"statusCode = %ld", (long)statusCode);
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

@end
