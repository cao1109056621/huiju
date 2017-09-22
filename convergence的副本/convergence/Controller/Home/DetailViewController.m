//
//  DetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "SDCycleScrollView.h"
#import "HomeModel.h"
#import "ExpModel.h"
#import <UIImageView+WebCache.h>
#import "MapViewController.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIGestureRecognizerDelegate>{
    NSInteger i;
    
}
- (IBAction)addressBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UITableView *expTableView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *vipLbl;
@property (weak, nonatomic) IBOutlet UILabel *locLbl;
@property (weak, nonatomic) IBOutlet UILabel *coachLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighttableView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSArray * srr;
@property (strong,nonatomic) NSArray * brr;
@property (strong,nonatomic) NSMutableArray * arr;
@property (strong,nonatomic) NSMutableArray * crr;
@property (weak, nonatomic) IBOutlet UIView *AddressView;


@property(nonatomic,strong) HomeModel * home;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_expTableView.userInteractionEnabled = YES;
    [self addressViewSet];
    [self detailnetworkRequest];
    [self initialization];
    [self Lateralspreads];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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

#pragma mark - network
-(void)detailnetworkRequest{
     _aiv= [Utilities getCoverOnView:self.view];
    NSString *ClubId = [[StorageMgr singletonStorageMgr]objectForKey:@"clubId"];
    NSDictionary * para = @{@"clubKeyId":ClubId};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_aiv stopAnimating];
        NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * picArr = result[@"clubPic"];
            for(NSDictionary * imgUrl in picArr){
                _crr[i] = imgUrl[@"imgUrl"];
                i++;
            }
            //详情页广告图片轮播
            [self photoscroll];
            //NSLog(@"tp%@",_crr);
        //NSArray * models = result[@"models"];
        //NSLog(@"result = %@",result);
        _home = [[HomeModel alloc]initWithDetailNSDictionary:result];
            
            NSArray * expArr = result[@"experienceInfos"];
            for(NSDictionary * dict in expArr){
                HomeModel * home = [[HomeModel alloc]initWithDetailNSDictionary:dict];
        [_arr addObject:home];
            }
        [self uilayout];
        
        //刷新表格
        [_expTableView reloadData];
    }else
    {
        //业务逻辑失败的情况下
        NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
        [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
    }
} failure:^(NSInteger statusCode, NSError *error) {
    //失败以后要做的事情在此处执行
    NSLog(@"statusCode = %ld",(long)statusCode);
    [_aiv stopAnimating];
    [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
}];
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"expCell" forIndexPath:indexPath];
    _heighttableView.constant = _arr.count * 120;
    HomeModel * home = _arr[indexPath.row];
    [cell.expImage sd_setImageWithURL:[NSURL URLWithString:home.eLogo] placeholderImage:[UIImage imageNamed:@""]];
    cell.expCard.text = home.expNmae;
    cell.priceLbl.text = [NSString stringWithFormat:@"%ld元",(long)home.orginPrice];
    cell.salecountLbl.text = [NSString stringWithFormat:@"已售:%ld",(long)home.number];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
//设置每一组中每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExpModel * exp = _arr[indexPath.row];
    [[StorageMgr singletonStorageMgr]addKey:@"eId" andValue:exp.eId];
    [self performSegueWithIdentifier:@"Club2Exp" sender:nil];
}
//UI布局
-(void)uilayout{
    
 _shopNameLbl.text = _home.clName;
 _addressLbl.text = _home.clubadd;
 _timeLbl.text = _home.clubTime;
 _contentLbl.text = _home.introduce;
 _vipLbl.text = [NSString stringWithFormat:@"%ld",(long)_home.clubMember];
 _locLbl.text = [NSString stringWithFormat:@"%ld",(long)_home.clubSite];
 _coachLbl.text =[NSString stringWithFormat:@"%ld",(long)_home.clubPerson];

 
}
-(void)initialization{
    
    _srr = [NSArray new];
    _arr = [NSMutableArray new];
    _crr = [NSMutableArray new];
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - photoscroll
-(void)photoscroll{
    //_srr= @[@"app_logo",@"app_logo",@"app_logo"];
    self.bannerView.imageURLStringsGroup = _crr;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.delegate = self;
    self.bannerView.currentPageDotColor = [UIColor grayColor]; // 自定义分页控件小圆标颜色
    self.bannerView.autoScrollTimeInterval = 3;//轮播时间
}
//电话配置
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *string = _home.clubTel;
    _brr =  [string componentsSeparatedByString:@","];
    // NSLog(@"数组里的是：%@",_arr);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // for(int i = 0 ; i < _arr.count ; i++){
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:_brr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  NSLog(@"点了第一个");
        // NSLog(@"%@",_arr[0]);
        //配置电话APP的路径，并将要拨打的号码组合到路径中
        NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_brr[0]];
        
        UIWebView *callWebview =[[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        
        
    }];
    [alertController addAction:callAction];
    // }
    if(_arr.count == 2)
    {
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:_brr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // NSLog(@"点了第二个");
            // NSLog(@"%@",_arr[1]);
            //配置电话APP的路径，并将要拨打的号码组合到路径中
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_brr[1]];
            
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
            
        }];
        [alertController addAction:callAction];
        
    }
    
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    //  [alertController addAction:callAction];
    [alertController addAction:cancelAction];
    
    
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
    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_home.jingdu];
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_home.weidu];
    [[StorageMgr singletonStorageMgr] addKey:@"clubname" andValue:_home.clName];
    [[StorageMgr singletonStorageMgr] addKey:@"clubip" andValue:_home.clubadd];
    [self performSegueWithIdentifier:@"Club2Map" sender:self];
   
}
- (IBAction)addressBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_home.jingdu];
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_home.weidu];
    [[StorageMgr singletonStorageMgr] addKey:@"clubname" andValue:_home.clName];
    [[StorageMgr singletonStorageMgr] addKey:@"clubip" andValue:_home.clubadd];
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
