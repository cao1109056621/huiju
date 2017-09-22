//
//  ActDetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ActDetailViewController.h"
#import "PayTableViewController.h"
#import <UIImageView+WebCache.h>
@interface ActDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *applyFeeLabel;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *attentdenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDueView;
@property (weak, nonatomic) IBOutlet UIView *applyIngView;
@property (weak, nonatomic) IBOutlet UIView *applyEndView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (strong ,nonatomic)UIImageView * image;

@end

@implementation ActDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self Lateralspreads];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden = YES;
    [self networkRequest];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
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

//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = _activity.name;
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
- (void)networkRequest{
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    NSString *request =[NSString stringWithFormat:@"/event/%@",_activity.activityId];
    // NSLog(@"%@",request);
    NSMutableDictionary *parmeters = [NSMutableDictionary new];
    if([Utilities loginCheck]){
        [parmeters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"] forKey:@"memberId"];
    }
    [RequestAPI requestURL:request withParameters:parmeters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject = %@",responseObject);
        [avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            _activity = [[ActModel alloc]initWithDetailDictionary:result];            [self uiLayout];
        }else{
            [avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PayTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"My" byIdentity:@"Pay"];
        purchaseVC.activity = _activity;
        [self.navigationController pushViewController:purchaseVC animated:YES];
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Left" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //配置“电话”App的路径,并将要拨打的号码组合到路径中
    NSString *targetAppStr = [NSString stringWithFormat:@"telprompt://%@", _activity.issurephone];
    
    NSURL *targetAppUrl = [NSURL URLWithString:targetAppStr];
    //从当前App跳转到其他指定的App中
    [[UIApplication sharedApplication] openURL:targetAppUrl];
    
}
- (void)uiLayout{
    [_activityImageView sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"活动"]];
    [self addTapGestureRecognizer:_activityImageView];
    _applyFeeLabel.text = [NSString stringWithFormat:@"%@元", _activity.applyFee];
    _attentdenceLbl.text = [NSString stringWithFormat:@"%@/%@", _activity.attendence, _activity.limitation];
    _typeLbl.text = _activity.atype;
    _issuerLbl.text = _activity.issure;
    _addressLbl.text = _activity.address;
    [_phoneBtn setTitle:[NSString stringWithFormat:@"联系活动发布者:%@", _activity.issurephone] forState:UIControlStateNormal];
    _contentLbl.text = _activity.content;
    NSString *dueTimeStr = [Utilities dateStrFromCstampTime:_activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeStr = [Utilities dateStrFromCstampTime:_activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr = [Utilities dateStrFromCstampTime:_activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text = [NSString stringWithFormat:@"%@ ~ %@", startTimeStr, endTimeStr];
    _applyDueLbl.text = [NSString stringWithFormat:@"报名截止时间(%@)",dueTimeStr];
    //获取什么时候调用这方法这个时间
    NSDate *now = [NSDate date];
    NSTimeInterval nowTime = [now timeIntervalSince1970InMilliSecond];
    _applyStartView.backgroundColor = [UIColor grayColor];
    if(nowTime >= _activity.dueTime){
        _applyDueView.backgroundColor = [UIColor grayColor];
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if(nowTime >= _activity.startTime){
            _applyIngView.backgroundColor = [UIColor grayColor];
            if(nowTime >= _activity.endTime){
                _applyEndView.backgroundColor = [UIColor grayColor];
            }
        }
    }
    if(_activity.attendence >= _activity.limitation){
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"活动满员" forState:UIControlStateNormal];
    }
    switch (_activity.status) {
        case 0:
            _applyStateLbl.text = @"已取消";
            break;
        case 1:
            _applyStateLbl.text = @"代付款";
            [_applyBtn setTitle:@"去付款" forState:UIControlStateNormal];
            break;
        case 2:
            _applyStateLbl.text = @"已报名";
            [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
            break;
        case 3:
            _applyStateLbl.text = @"退款中";
            [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
            break;
        case 4:
            _applyStateLbl.text = @"已退款";
            break;
            
        default:{
            _applyStateLbl.text = @"待报名";
        }
            break;
    }
}
//添加一个单击手势事件
- (void)addTapGestureRecognizer: (id)any{
    //初始化一个单击手势，设置它的响应事件为tapClick:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    //用户交互启用
    _activityImageView.userInteractionEnabled = YES;
    //将手势添加给入参
    [any addGestureRecognizer:tap];
}
//小图单击手势响应事件
- (void)tapClick: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized){
        //NSLog(@"你单击了");
        //拿到单击手势在_activityTableView中的位置
        //CGPoint location = [tap locationInView:_activityImageView];
        //通过上述的点拿到在_activityTableView对应的indexPath
        //NSIndexPath *indexPath = [_activityTableView indexPathForRowAtPoint:location];
        //防范式编程
        // if (_arr !=nil && _arr.count != 0){
        //根据行号拿到数组中对应的数据
        //  ActivityModel *activity = _arr[indexPath.row];
        //设置大图片的位置大小
        _image = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        //用户交互启用
        _image.userInteractionEnabled = YES;
        //设置大图背景颜色
        _image.backgroundColor = [UIColor blackColor];
        //_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_activity.imgUrl]]];
        //将http请求的字符串转换为nsurl
        NSURL *URL = [NSURL URLWithString:_activity.imgUrl];
        //依靠SDWebImage来异步地下载一张远程路径中的图片并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
        [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"活动"]];
        //设置图片地内容模式
        _image.contentMode = UIViewContentModeScaleAspectFit;
        //[UIApplication sharedApplication].keyWindow获得窗口实例，并将大图放置到窗口实例上，根据苹果规则，后添加的控件会盖住前面添加的控件
        [[UIApplication sharedApplication].keyWindow addSubview:_image];
        UITapGestureRecognizer *zoomIVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
        [_image addGestureRecognizer:zoomIVTap];
        
        // }
    }
}
//大图的单击手势响应事件
- (void)zoomTap: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        //把大图的本身东西扔掉
        [_image removeGestureRecognizer:tap];
        //把自己从父级视图中移除
        [_image removeFromSuperview];
        //彻底消失（这样就不会让内存滥用）
        _image = nil;
    }
}
//侧滑返回上一页
-(void)Lateralspreads{
    // 获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
@end

