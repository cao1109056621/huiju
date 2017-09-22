//
//  HomeViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import <UIImageView+WebCache.h>
#import "SDCycleScrollView.h"
#import "DetailViewController.h"
#import "ExpDetailViewController.h"
#import "UserModel.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    NSInteger page;
    NSInteger perpage;
    NSInteger  jing;
    NSInteger   wei;
    NSInteger i;
    NSInteger totalPage;
}

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSMutableArray * arr;
@property (strong,nonatomic) NSMutableArray * brr;
@property (strong,nonatomic) NSMutableArray * advArr;
@property (strong, nonatomic) UIButton * headBtn;

@end

@implementation HomeViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self firstnetworkRequest];
    [self initialization];
    [self headBtnSet];
    
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - netrquest

-(void)firstnetworkRequest{
    //_aiv= [Utilities getCoverOnView:self.view];
    NSDictionary * para = [NSDictionary new];
    [RequestAPI requestURL:@"/city/hotAndUpgradedList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //[_aiv stopAnimating];
        
        //NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * hotArr = result[@"hot"];
            for(NSDictionary * dict in hotArr){
          HomeModel * home = [[HomeModel alloc]initWithFirstNSDictionary:dict];
        //将城市区号添加到全局单例化全局变量中
        [[StorageMgr singletonStorageMgr] addKey:@"CityInfo" andValue:home];
        //单独将用户的ID也存储进单例化全局变量来作为用户是否已经登陆的判断依据，同时也方便其他所有页面更快捷的使用用户Id这个参数
        [[StorageMgr singletonStorageMgr] addKey:@"CityId" andValue:home.hotId];

            }
            [self secondnetworkRequest];
        }else{
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
//创建刷新指示器的方法
- (void)setRefreshControl{
    //已获取列表的刷新指示器
    UIRefreshControl *Ref = [UIRefreshControl new];
    [Ref addTarget:self action:@selector(Ref) forControlEvents:UIControlEventValueChanged];
    Ref.tag = 10001;
    [_homeTableView addSubview:Ref];
}
- (void)Ref{
    page = 1;
    [self firstnetworkRequest];
}

-(void)secondnetworkRequest{
    
    //_aiv= [Utilities getCoverOnView:self.view];
    NSDictionary* para = @{@"city":@"无锡",@"jing":@(120.2672222),@"wei":@(31.47361111),@"page":@(page),@"perPag":@(perpage)};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10001];
        [ref endRefreshing];        //NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSArray * adv = responseObject[@"advertisement"];
            //NSLog(@"adv =%@",adv);
            for(NSDictionary * advDict in adv){
                
                _advArr[i] = advDict[@"imgurl"];
                i++;
            }
            //NSLog(@"_advArr =%@",_advArr);
            [self photoscroll];
            
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            NSDictionary *pagingInfo = result[@"pagingInfo"];
            totalPage = [pagingInfo[@"totalPage"]integerValue];
            if (page == 1) {
                //清空数据
                [_arr removeAllObjects];
                
            }

            for(NSDictionary * dict in models){
            HomeModel * home = [[HomeModel alloc]initWithSecondNSDictionary:dict];
                
                [_arr addObject:home];
                
            }
            
            //刷新表格
            [_homeTableView reloadData];
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

#pragma mark - table
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
    
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HomeModel * home = _arr[section];
    
    
     return home.experience.count+1;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{   HomeModel * home = _arr[indexPath.section];
    if(indexPath.row == 0){
        
        HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
    
        NSURL *URL1 =[NSURL URLWithString:home.clubimage];
        [cell.dianimage sd_setImageWithURL:URL1 placeholderImage:[UIImage imageNamed:@"AdDefault"]];
        
        cell.diannameLbl.text =home.clubname;
        cell.disLbl.text = [NSString stringWithFormat:@"%ld米",(long)home.clubdis];
        
        cell.adressLbl.text = home.clubaddress;
        
        //cell.priceLbl.text = home.clubprice;
        return cell;
    }
    NSArray * experiences = home.experience;
    NSDictionary * dict = experiences[indexPath.row-1];
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
     NSURL *URL2 =[NSURL URLWithString:dict[@"logo"]];
    [cell.tiyanimage sd_setImageWithURL:URL2 placeholderImage:[UIImage imageNamed:@"AdDefault"]];
    cell.priceLbl.text = [NSString stringWithFormat:@"%@元",dict[@"price"]];
    cell.tiyanLbl.text = dict[@"name"];
    cell.rollLbl.text =@"综合卷";
    cell.saleLbl.text = [NSString stringWithFormat:@"已售:%@",dict[@"sellNumber"]];
    return cell;
    
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 180;
    }
    return 130;
    
}
//设置每一组中每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel * home = _arr[indexPath.section];
    NSString *Id =  [NSString stringWithFormat:@"%ld",home.clubId];
    //NSLog(@"id是：%@",Id);
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:Id];
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"Home2Club" sender:nil];
    }else {
        NSArray *array = home.experience;
        NSDictionary *dict = array[indexPath.row-1];
        NSString *eId =  dict[@"id"];
        [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:eId];
        [self performSegueWithIdentifier:@"Home2Exp" sender:nil];
    }

 
}

#pragma mark - Navigation

//俱乐部详情页的跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    }

#pragma mark - photoscroll
-(void)photoscroll{
    //_srr= @[@"app_logo",@"app_logo",@"app_logo"];
    self.bannerView.imageURLStringsGroup = _advArr;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.delegate = self;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.bannerView.autoScrollTimeInterval = 3;//轮播时间
}
-(void)initialization{
    
  

    _advArr = [NSMutableArray new];
    page = 1;
    perpage = 15;
    [self setRefreshControl];
    _arr=[NSMutableArray new];
    
}
-(void)headBtnSet{
    _headBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _headBtn.frame = CGRectMake(0, 0, 30, 30);
    _headBtn.clipsToBounds=YES;
    _headBtn.layer.cornerRadius=15;
    [_headBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_headBtn];
    if([Utilities loginCheck]){
        //已登录
        
        //[self dispatch];
        UserModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        NSURL *url =  [NSURL URLWithString:usermodel.avatarUrl];
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [_headBtn setBackgroundImage:img forState:UIControlStateNormal];
        // 根据图片的url下载图片数据
        dispatch_queue_t xrQueue = dispatch_queue_create("默认图", NULL); // 创建GCD线程队列
        dispatch_async(xrQueue, ^{
            // 异步下载图片
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            // 主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [_headBtn setBackgroundImage:img forState:UIControlStateNormal];
            });
        });
        
        
    }else{
        //未登录
        [_headBtn setBackgroundImage:[UIImage imageNamed:@"ic_user_head.png"] forState:UIControlStateNormal];
        
    }
}
//用Model的方式返回上一页
-(void)returnAction{
    //注册策划通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
}

@end
