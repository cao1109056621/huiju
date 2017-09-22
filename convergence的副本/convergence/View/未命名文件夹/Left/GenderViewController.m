//
//  GenderViewController.m
//  convergence
//
//  Created by admin on 2017/9/21.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "GenderViewController.h"
#import "SettingTableViewCell.h"
#import "SettingViewController.h"
#import "UserModel.h"
@interface GenderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)doneAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPickerview;
@property(strong,nonatomic)NSArray *pickerArr;
@property (strong,nonatomic)UserModel *user;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
- (IBAction)touchAction:(UITextField *)sender forEvent:(UIEvent *)event;
@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _genderTextField.text=_user.gen;
    _pickerArr=@[@"男",@"女"];
    [_genderPickerview selectRow:2 inComponent:0 animated:NO];
    //刷新第一列
    [_genderPickerview reloadComponent:0];

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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)save{
    NSString *xb=_genderTextField.text;
    //  [[StorageMgr singletonStorageMgr]addKey:@"XB" andValue:xb];
    NSNumber *gender;
    if([xb isEqualToString:@"男"]){
        gender = @1;
    }else{
        gender = @2;
    }
    _avi=[Utilities getCoverOnView:self.view];
    
    //NSLog(@"%@",_user.nickname);
    
    NSDictionary *para = @{@"memberId":_user.memberId,@"gender":gender};
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
// 多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        
        return _pickerArr.count;
        
    }else{
        return 1;
    }
    
}
//每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    return  _pickerArr[row];
    
    
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return _genderPickerview.frame.size.width/4;
    
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolbar.hidden=YES;
    _genderPickerview.hidden=YES;
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    //拿到某一种中选中的行号
    NSInteger row1=[_genderPickerview selectedRowInComponent:0];
    //根据上面拿到的行号。找到对应的数据（选中行的标题）
    NSString *title1=_pickerArr[row1];
    _genderTextField.text = title1;
    //把拿到的按钮显示在按钮上
    // [_XBTextField setTitle:[NSString stringWithFormat:@"%@",title1] forState:(UIControlStateNormal)];
    _toolbar.hidden=YES;
    _genderPickerview.hidden=YES;
    
}
- (IBAction)touchAction:(UITextField *)sender forEvent:(UIEvent *)event {
    _genderPickerview.hidden = NO;
    _toolbar.hidden = NO;
}
@end
