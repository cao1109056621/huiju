//
//  ExpDetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/14.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ExpDetailViewController.h"
#import "ExpModel.h"
#import <UIImageView+WebCache.h>
#import "PuchaseTableViewController.h"
#import "MapViewController.h"
@interface ExpDetailViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *eName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *originPrice;

@property (weak, nonatomic) IBOutlet UILabel *clubName;

@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *sellNumber;
@property (weak, nonatomic) IBOutlet UILabel *useDate;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UITextView *useRule;
@property (weak, nonatomic) IBOutlet UITextView *userInfo;
- (IBAction)PayAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong,nonatomic)ExpModel * expm;
- (IBAction)address:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong,nonatomic)NSArray *arr;
@property (weak, nonatomic) IBOutlet UIView *AddressView;

@end

@implementation ExpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self request];
    [self addressViewSet];
    [self Lateralspreads];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"体验券信息";
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


-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    
    NSString *eId =  [[StorageMgr singletonStorageMgr]objectForKey:@"eId"];
    /*isKindOfClass:[NSNull class]]?@"-1" : [[StorageMgr singletonStorageMgr]objectForKey:@"eId"];*/
    NSDictionary *para = @{@"experienceId":eId};
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            NSLog(@"responseObject:%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            _expm = [[ExpModel alloc]initWithexperience:result];
            [self uiLayout];
            [self introduceViewHeight];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"请保持网络通畅" andTitle:@"提示" onView:self];
    }];
    
}

-(void)uiLayout{
    NSURL * url = [NSURL URLWithString:_expm.eLogo];
    [_Image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
    _eName.text = _expm.eName;
    _price.text = _expm.currentPrice;
    _originPrice.text = [NSString stringWithFormat:@"原价:%@元",_expm.orginPrice];;
    _clubName.text = _expm.clubName;
    _addressLbl.text = _expm.eAddress;
    //[_addressBtn setTitle:_expm.eAddress forState:UIControlStateNormal];
    _sellNumber.text = [NSString stringWithFormat:@"已售:%ld",(long)_expm.salaCount];
    _useDate.text = [NSString stringWithFormat:@"%@-%@",_expm.beginDate,_expm.endDate];
    _useTime.text = _expm.userTime;
    _useRule.text = _expm.rules;
    _userInfo.text = _expm.ePromot;
}
-(void)introduceViewHeight{
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 30, 1000);
    //拿的已经显示在textView上的高度
    CGSize contentSize = [_useRule.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_useRule.font} context:nil].size;
    //将文字内容的尺寸给textView高度约束
    // _introduceHeight.constant = contentSize.height + 36;
    //NSLog(@"内容高度是：%f",contentSize.height);
    _viewHeight.constant =contentSize.height + 36 + 175;
    
    /*
     _introduceHeight.constant = _clubIntrodutioanView.contentSize.height + 16;
     NSLog(@"内容高度是：%f",_clubIntrodutioanView.contentSize.height);
     _viewHeight.constant = _clubIntrodutioanView.contentSize.height + 25;
     */
    // _viewHeight.constant = 230.f;
}
- (IBAction)PayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PuchaseTableViewController *purchase = [Utilities getStoryboardInstance:@"Homepage" byIdentity:@"Purchase"];
        purchase.expm = _expm;
        [self.navigationController pushViewController:purchase animated:YES];
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Left" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
    
}



- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *string = _expm.clubTel;
    _arr =  [string componentsSeparatedByString:@","];
    // NSLog(@"数组里的是：%@",_arr);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // for(int i = 0 ; i < _arr.count ; i++){
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  NSLog(@"点了第一个");
        // NSLog(@"%@",_arr[0]);
        //配置电话APP的路径，并将要拨打的号码组合到路径中
        NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[0]];
        
        UIWebView *callWebview =[[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        
        
    }];
    [alertController addAction:callAction];
    // }
    if(_arr.count == 2)
    {
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // NSLog(@"点了第二个");
            // NSLog(@"%@",_arr[1]);
            //配置电话APP的路径，并将要拨打的号码组合到路径中
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[1]];
            
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
            
        }];
        [alertController addAction:callAction];
        
    }
    
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    //  [alertController addAction:callAction];
    [alertController addAction:cancelAction];
    
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        NSLog(@"点击确认");
    //
    //    }]];
    //
    
    
    
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    //
    //        NSLog(@"添加一个textField就会调用 这个block");
    //
    //    }];
    
    
    
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
-(void)addressViewSet{
    UITapGestureRecognizer * aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    aTapGR.numberOfTapsRequired = 1;
    // 设置手指触摸的个数
    aTapGR.numberOfTouchesRequired = 1;
    [_AddressView addGestureRecognizer:aTapGR];
    
    
}
-(void)tapGRAction{
    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_expm.longitude];
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_expm.latitude];
    [[StorageMgr singletonStorageMgr] addKey:@"clubname" andValue:_expm.clubName];
    [[StorageMgr singletonStorageMgr] addKey:@"clubip" andValue:_expm.eAddress];
    [self performSegueWithIdentifier:@"Exp2Map" sender:self];
    
}

- (IBAction)address:(UIButton *)sender forEvent:(UIEvent *)event {
 
    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_expm.longitude];
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_expm.latitude];
    [[StorageMgr singletonStorageMgr] addKey:@"clubname" andValue:_expm.clubName];
    [[StorageMgr singletonStorageMgr] addKey:@"clubip" andValue:_expm.eAddress];
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
