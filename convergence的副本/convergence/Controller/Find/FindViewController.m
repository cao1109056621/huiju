//
//  FindViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FindViewController.h"
#import "FindTableViewCell.h"
#import "FindCollectionViewCell.h"
#import "FindModel.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "UserModel.h"
@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger flag;
    BOOL isDis;
}
@property (weak, nonatomic) IBOutlet UIButton *disBtn;
@property (weak, nonatomic) IBOutlet UIButton *allKindBtn;
@property (weak, nonatomic) IBOutlet UIButton *allCityBtn;
- (IBAction)allCityAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)allKindAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)disAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *SxTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *ContentCollectionView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSArray * cityArr;
@property (strong,nonatomic) NSMutableArray * kindArr;
@property (strong,nonatomic) NSMutableArray * kindArr1;
@property (strong,nonatomic) NSArray * disArr;
@property (strong,nonatomic) NSString * disStr;
@property (strong,nonatomic) NSString * idStr;
@property (strong,nonatomic) NSMutableArray * contentArr;
@property (strong, nonatomic) UIButton *headBtn;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    [self disnetworkRequest];
    [self headBtnSet];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return _contentArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    FindCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    FindModel * find = _contentArr[indexPath.row];
    NSURL * url = [NSURL URLWithString:find.clubImageUrl];
    [cell.contentImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdDefault"]];
    cell.shopLbl.text = find.clubName;
    cell.addressLbl.text = find.clubAdd;
    cell.disLbl.text = [NSString stringWithFormat:@"%ld米",(long)find.clubDis];
    
    return cell;
    }

//设置每一个collectionView的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_SCREEN_W/2-5, UI_SCREEN_W/2-5);
}
//设置左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     [_ContentCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    FindModel * find = _contentArr[indexPath.row];
    NSString *clubId = find.clubID;
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:clubId];
    DetailViewController *issueVC = [Utilities getStoryboardInstance:@"Homepage" byIdentity:@"ClubDetail"];

    [self.navigationController pushViewController:issueVC animated:YES];
    
}
- (void)setRefreshControl{
    
    UIRefreshControl *refresh = [UIRefreshControl new];
    [refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    refresh.tag = 10001;
    [_ContentCollectionView addSubview:refresh];
    
}
//会所列表下拉刷新事件
- (void)refreshAction{
    pageNum = 1;
    if(flag == 1){
        if(_disStr == nil){
            [self disnetworkRequest];
        }else{
            [self rangenetworkRequest];
        }
        return;
    }
    if(flag == 2){
        if(_idStr == nil){
            [self disnetworkRequest];
        }else{
            [self kindnetworkRequest];
        }
        return;
    }
    if(flag == 3){
        if(isDis){
            [self disnetworkRequest];//默认
            return;
        }else{
            [self peoplenetworkRequest];
            return;
        }
    }
    else{
        [self disnetworkRequest];
    }
}

//细胞将要出现时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _contentArr.count-1){
        if(pageNum != totalPage){
            pageNum ++;
            if(flag == 1){
                if(_disStr == nil){
                    [self disnetworkRequest];
                }else{
                    [self rangenetworkRequest];
                }
                return;
            }
            
            if(flag == 2){
                if(_idStr == nil){
                    [self disnetworkRequest];
                }else{
                    [self kindnetworkRequest];
                }
                return;
            }
            
            if(flag == 3){
                if(isDis){
                    [self disnetworkRequest];
                }else{
                    [self peoplenetworkRequest];
                }
                return;
            }
            else{
                [self disnetworkRequest];
                //  NSLog(@"不是最后一页");
            }
        }
    }
    
}

#pragma mark - tableview
//有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//一组有多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    if(flag == 1){
        return _cityArr.count;
    }
    if(flag == 2){
        return _kindArr.count;
    }
    if(flag == 3){
        return _disArr.count;
    }
    return 0;
}
//样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
     FindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sxCell" forIndexPath:indexPath];
    if(flag == 1){
        cell.kindLbl.text = _cityArr[indexPath.row];
    }
    if(flag == 2){
        cell.kindLbl.text = _kindArr[indexPath.row];
        
    }
    if(flag == 3){
        cell.kindLbl.text = _disArr[indexPath.row];
    }
    return cell;
    
  }
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    pageNum = 1;
    if(flag == 1){
        if(indexPath.row == 0){
        _disStr = @"0";
        [self disnetworkRequest];//默认按距离请求
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
        [_allCityBtn setTitle:_cityArr[0] forState:UIControlStateNormal];
        }
        if(indexPath.row == 1){
            _disStr = @"1000";
        [self rangenetworkRequest];
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
            [_allCityBtn setTitle:_cityArr[1] forState:UIControlStateNormal];
        }
        if(indexPath.row == 2){
            _disStr = @"2000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allCityBtn setTitle:_cityArr[2] forState:UIControlStateNormal];
        }
        if(indexPath.row == 3){
            _disStr = @"3000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allCityBtn setTitle:_cityArr[3] forState:UIControlStateNormal];
        }
        if(indexPath.row == 4){
            _disStr = @"5000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allCityBtn setTitle:_cityArr[4] forState:UIControlStateNormal];
        }
        
        
    }
    if(flag == 2){
        
        if(indexPath.row == 0){
            [self disnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allKindBtn setTitle:_kindArr[0] forState:UIControlStateNormal];
        }
        if(indexPath.row == 1){
            _idStr = @"1";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allKindBtn setTitle:_kindArr[1] forState:UIControlStateNormal];
        }
        if(indexPath.row == 2){
            _idStr = @"2";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allKindBtn setTitle:_kindArr[2] forState:UIControlStateNormal];
        }
        if(indexPath.row == 3){
            _idStr = @"3";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allKindBtn setTitle:_kindArr[3] forState:UIControlStateNormal];
        }
        if(indexPath.row == 4){
            _idStr = @"4";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_allKindBtn setTitle:_kindArr[4] forState:UIControlStateNormal];
        }
        
    }
    if(flag == 3){
        if(indexPath.row == 0){
            isDis = YES;
            [self disnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
            [_disBtn setTitle:@"按距离" forState:UIControlStateNormal];
        }else if(indexPath.row == 1){
       
            [self peoplenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        [_disBtn setTitle:_disArr[1] forState:UIControlStateNormal];
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

#pragma mark - hidden yes or no?
- (IBAction)allCityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    self.heightTableView.constant = _cityArr.count *40 ;
    if(_SxTableView.hidden == YES){
        _SxTableView.hidden = NO;
        _coverView.hidden = NO;
    }else{
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
    }
    
    [_SxTableView reloadData];
}
- (IBAction)allKindAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
    self.heightTableView.constant = _kindArr.count *40 ;
    if(_SxTableView.hidden == YES){
        _SxTableView.hidden = NO;
        _coverView.hidden = NO;
    }else{
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
    }    [_SxTableView reloadData];
}

- (IBAction)disAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    self.heightTableView.constant = _disArr.count *40;
    if(_SxTableView.hidden == YES){
        _SxTableView.hidden = NO;
        _coverView.hidden = NO;
    }else{
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
    }
    [_SxTableView reloadData];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _SxTableView.hidden = YES;
    _coverView.hidden = YES;
}
#pragma mark - networkRequest


//距离排序请求
-(void)disnetworkRequest{
    //_aiv= [Utilities getCoverOnView:self.view];
    NSDictionary * para = @{@"city":@"无锡",@"page":@(pageNum),@"perPage":@(pageSize),@"jing":@(120.2672222),@"wei":@(31.47361111),@"type":@0};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        //NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            NSDictionary  * pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if(pageNum == 1){
                [_contentArr removeAllObjects];
            }

            for(NSDictionary * dict in models){
                FindModel * find = [[FindModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];
            }
            [_ContentCollectionView reloadData];
            
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

//按人气
-(void)peoplenetworkRequest{
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary * para = @{@"city":@"无锡",@"jing":@"120.2672222",@"wei":@"31.47361111",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@1};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_aiv stopAnimating];
        //NSLog(@"responseObject=%@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            for(NSDictionary * dict in models){
                FindModel * find = [[FindModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];
            }
            [_ContentCollectionView reloadData];
            
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
//请求n千米范围内的会所
- (void)rangenetworkRequest{

    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.2672222",@"wei":@"31.47361111",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_disStr};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(pageNum == 1){
                [_contentArr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FindModel * find = [[FindModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];
                // NSLog(@"数组里的是%@",model);
                
            }
            
            
            
            [_ContentCollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//按种类请求会所
- (void)kindnetworkRequest{
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.2672222",@"wei":@"31.47361111",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_idStr};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if(pageNum == 1){
                [_contentArr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FindModel * find = [[FindModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];

                
            }
            [_ContentCollectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//请求健身类型ID
- (void)TypeRequest{
    
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡"};
    [RequestAPI requestURL:@"/clubController/getNearInfos" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *features = responseObject[@"result"][@"features"];
            NSArray *featureForm = features[@"featureForm"];
            for(NSDictionary *dict in featureForm){
                FindModel * find = [[FindModel alloc]initWithSxNSDictionary:dict];
                [_kindArr1 addObject:find];
                //    NSLog(@"数组里的是：%@",model.fName);
            }
            if(pageNum == 1){
                [_kindArr removeAllObjects];
            }
            _kindArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类", nil];
            for(int i = 0;i < 4;i++){
                FindModel * find = _kindArr1[i];
                [_kindArr addObject:find.fName];
            }
            
            //[_tableView reloadData];
            [self disnetworkRequest];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

-(void)initialization{
    isDis = NO;
    [self setRefreshControl];
    [self TypeRequest];
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _cityArr = [NSArray new];
    _kindArr = [NSMutableArray new];
    _kindArr1 = [NSMutableArray new];
    _disArr = [NSArray new];
    _contentArr = [NSMutableArray new];
    //_kindArr = @[@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动"];
    //_kindArr = [[NSArray alloc]initWithObjects:@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动",nil];
    _cityArr = @[@"不限",@"距离我1KM以内",@"距离我2KM以内",@"距离我3KM以内",@"距离我5KM以内"];
    _disArr = @[@"按距离",@"按人气"];
    pageNum = 1;
    pageSize = 10;
    perPage = 10;
    
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
/*-(void)dispatch{
    UserModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    NSURL *url =  [NSURL URLWithString:usermodel.avatarUrl];
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
}*/
@end
