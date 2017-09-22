//
//  LeftViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "LeftViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeModel.h"
@interface LeftViewController ()

@property (strong,nonatomic) NSArray *arr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatrImage;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UILabel *usernameLbl;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)seetingAction:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uilayout];
    [self dataInitialize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登陆
        _loginBtn.hidden = YES;
        _usernameLbl.hidden = NO;
        
        HomeModel *user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_avatrImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        _usernameLbl.text = user.nickname;
    }else{
        //未登陆
        _loginBtn.hidden = NO;
        _usernameLbl.hidden = YES;
        
        _avatrImage.image = [UIImage imageNamed:@"ic_user_head"];
        _usernameLbl.text = @"游客";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uilayout{
    _avatrImage.layer.borderColor = [[UIColor lightGrayColor]CGColor];
}

- (void)dataInitialize{
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _arr = @[@"我的订单",@"我的推广",@"积分中心",@"意见反馈",@"关于我们"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _arr.count;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        cell.textLabel.text =_arr[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmpytCell" forIndexPath:indexPath];
        
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView) {
        if ([Utilities loginCheck]) {
        switch (indexPath.row) {
            case 0:
            {
                [self performSegueWithIdentifier:@"List2order" sender:self];
            }
                break;
            case 1:
            {
               [self performSegueWithIdentifier:@"List2gene" sender:self];
            }
                break;
            case 2:
            {
                
                [self netRequest];
            }
                break;
            case 3:
            {
                [self performSegueWithIdentifier:@"List2advice" sender:self];
            }
                break;
            default:
            {
                [self performSegueWithIdentifier:@"List2about" sender:self];
            }
                break;
        }
        }else{
            //获取要跳转过去的那个页面
            UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Left" byIdentity:@"SignNavi"];
            //执行跳转
            [self presentViewController:signNavi animated:YES completion:nil];
        }
    }
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.f;
    }else{
        return UI_SCREEN_H - 600;
    }
}
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转过去的那个页面
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Left" byIdentity:@"SignNavi"];
    //执行跳转
    [self presentViewController:signNavi animated:YES completion:nil];
}

- (IBAction)seetingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        //获取要跳转过去的那个页面
        UINavigationController * settingNavi = [Utilities getStoryboardInstance:@"Left" byIdentity:@"Setting"];
        //执行跳转
        [self presentViewController:settingNavi animated:YES completion:nil];
        
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Left" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
        
    }
}
-(void)netRequest{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
    [RequestAPI requestURL:@"/score/memberScore" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"resposeObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSString *integral = responseObject[@"result"];
            NSString *string  =[NSString stringWithFormat:@"当前积分:%@",integral];
            [Utilities popUpAlertViewWithMsg:@"积分商城即将登录，准备好了吗，亲！" andTitle:string onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

@end
