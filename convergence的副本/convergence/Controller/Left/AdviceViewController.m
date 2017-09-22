//
//  AdviceViewController.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *Btn;
- (IBAction)Btn:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    //关掉自动调整scrollView的属性
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.textView.delegate = self;
    [super viewWillAppear:animated];// 1
    [self.textView becomeFirstResponder];// 2
}

- (void)naviConfig{
    self.navigationItem.title = @"意见反馈";
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
-(void)netRequest{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
    NSDictionary *para1 = @{@"memberId":@"para",@"message":_textView.text};
    [RequestAPI requestURL:@"/clubFeedback" withParameters:para1 andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"resposeObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            [Utilities popUpAlertViewWithMsg:@"感谢您的反馈，我们将竭诚为您服务" andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)Btn:(UIButton *)sender forEvent:(UIEvent *)event {
    [self netRequest];
}
@end
