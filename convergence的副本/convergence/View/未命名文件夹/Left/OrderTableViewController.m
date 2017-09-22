//
//  OrderTableViewController.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "OrderTableViewController.h"
#import "OrderTableViewCell.h"
#import "OrderModel.h"
#import <UIImageView+WebCache.h>
@interface OrderTableViewController ()<UITextViewDelegate>
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation OrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    
    [self request];
    _arr = [NSMutableArray new];
}

- (void)naviConfig{
//    //设置导航条标题文字
//    self.navigationItem.title = @"我的订单";
//    //设置导航条的颜色（风格颜色）
//    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
//    //设置导航条标题的颜色
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    //设置导航条是否隐藏
//    self.navigationController.navigationBar.hidden = NO;
//    //设置导航条上按钮的风格颜色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    //设置是否需要毛玻璃效果
//    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(beckAction)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

//用Model的方式返回上一页
-(void)beckAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}


-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"memberId":[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"],@"type":@0};
    [RequestAPI requestURL:@"/orderController/orderList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@",responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSArray *array = responseObject[@"result"][@"orderList"];
            for(NSDictionary *dict in array){
                OrderModel *model = [[OrderModel alloc]initWithOrder:dict];
                [_arr addObject:model];
            }
            [_tableview reloadData];
        }
        
        else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
    }];
    
    
    
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;//_arr.count;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont systemFontOfSize:13];
    header.contentView.backgroundColor = UIColorFromRGB(240, 239, 245);
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    OrderModel *Model = _arr[section];
    NSString *upper = [Model.orderNum uppercaseString];
    NSString *string = [NSString stringWithFormat:@"订单号:%@",upper];
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"forIndexPath:indexPath];
    OrderModel *Model = _arr[indexPath.section];
    NSURL *url = [NSURL URLWithString: Model.imgUrl];
    [cell.OrderImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.OrderName.text = Model.productName;
    cell.clubName.text = Model.clubName;
    cell.price.text = [NSString stringWithFormat:@"%@元",Model.shouldpay];
    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView ==self.tableView)
    {
        CGFloat sectionHeaderHeight = 5;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset =UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset =UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
        }
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
