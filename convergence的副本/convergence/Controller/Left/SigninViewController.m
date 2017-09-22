//
//  SigninViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "SigninViewController.h"
#import "UserModel.h"
@interface SigninViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uilayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviConfig{
    //设置导航条标题文字
    //self.navigationItem.title = @"发布活动";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(beckAction)];
    self.navigationItem.leftBarButtonItem = left;
}

//用Model的方式返回上一页
-(void)beckAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)uilayout{
    //判断是否存在记忆体
    if (![[Utilities  getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        if ([Utilities  getUserDefaults:@"Username"] != nil) {
            //将它显示在用户名输入框中
            _usernameTextField.text = [Utilities getUserDefaults:@"Username"];
        }
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_usernameTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 18) {
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6—18位之间" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    if (_usernameTextField.text.length < 11 || [_usernameTextField.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet]invertedSet]].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:@"您输入不小于11位的手机号码" andTitle:nil onView:self];
        return;
    }
    //无输入异常的情况
    [self readyForEncoding];
}
- (void)readyForEncoding{
    // 创建菊花膜
    NSString *str = [Utilities uniqueVendor];
    _aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *prarmeter = @{@"deviceType" : @7001, @"deviceId" : str};
    //开始请求
    [RequestAPI requestURL:@"/login/getKey" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        //NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSString *exponent = result[@"exponent"];
            NSString *modulus = result[@"modulus"];
            //对内容进行MD5加密
            NSString *md5Str = [_passwordTextField.text getMD5_32BitString];
            [[StorageMgr singletonStorageMgr]addKey:@"pwd"andValue:_passwordTextField.text];
            //用模数与指数对MD5加密过后的密码进行加密
            NSString *rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
            //加密完成执行接口
            [self signInWithEnCryptPwd:rsaStr];
        }else{
            [_aiv stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        //失败以后要做的事情
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
- (void)signInWithEnCryptPwd:(NSString *)encryptPwd{
    NSString *str = [Utilities uniqueVendor];
    [RequestAPI requestURL:@"/login" withParameters:@{@"userName" : _usernameTextField.text, @"password" : encryptPwd, @"deviceType" : @7001, @"deviceId" : str} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        // NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            //将登陆入参存储，以便后面登陆
            [[StorageMgr singletonStorageMgr]addKey:@"userName" andValue:_usernameTextField.text];
            [[StorageMgr singletonStorageMgr]addKey:@"password" andValue:encryptPwd];
            [[StorageMgr singletonStorageMgr]addKey:@"deviceId" andValue:str];
            
            
            NSDictionary *result = responseObject[@"result"];
            UserModel *usermodel =[[UserModel alloc]initWithDictionary:result];
            //将登录获取到的用户信息打包存储到单例化全局变量中
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:usermodel];
            //单独将用户的ID也存储进单例化全局变量来作为用户是否已经登录的判断依据，同时也方便其它所有页面更快捷地使用ID这个参数
            [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:usermodel.memberId];
            //让根视图结束编辑状态达到收起键盘的目的
            [self.view endEditing:YES];
            //情空密码输入框里的内容
            _passwordTextField.text = @"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_usernameTextField.text];
            //用model的方式返回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
//按键盘上的return健收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
