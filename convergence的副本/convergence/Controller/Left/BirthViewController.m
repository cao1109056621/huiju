//
//  BirthViewController.m
//  convergence
//
//  Created by admin on 2017/9/21.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "BirthViewController.h"
#import "SettingTableViewCell.h"
#import "SettingViewController.h"
#import "UserModel.h"
@interface BirthViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)doneAction:(UIBarButtonItem *)sender;
@property(strong,nonatomic)NSArray *pickerArr;
@property (strong,nonatomic)UserModel *user;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
- (IBAction)touchAction:(UITextField *)sender forEvent:(UIEvent *)event;
@end

@implementation BirthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _dobTextField.text=_user.dob;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 100, 255);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)save{
    NSString *sr=_dobTextField.text;
    [[StorageMgr singletonStorageMgr]addKey:@"SR" andValue:sr];
    
    _avi=[Utilities getCoverOnView:self.view];
    
    //NSLog(@"%@",_user.nickname);
    
    NSDictionary *para = @{@"memberId":_user.memberId,@"birthday":sr};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            //  NSDictionary *result= responseObject[@"result"];
            
            NSNotification *note = [NSNotification notificationWithName:@"refresh" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络请求失败😂" andTitle:nil onView:self];
    }];
    
    
    
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolbar.hidden = YES;
    _datePicker.hidden = YES;
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *theDate = [formatter stringFromDate:date];
    _dobTextField.text = theDate;
    _toolbar.hidden = YES;
    _dobTextField.hidden = YES;
    
    
}
- (IBAction)touchAction:(UITextField *)sender forEvent:(UIEvent *)event {
    
    _datePicker.hidden = NO;
    _toolbar.hidden = NO;
}
@end

