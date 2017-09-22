//
//  PayTableViewController.m
//  convergence
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "PayTableViewController.h"

@interface PayTableViewController (){
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong ,nonatomic) NSArray *arr;
@end

@implementation PayTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self naviConfig];
    [self uiLayout];
    [self dataInitialize];
    
    //注册一个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    //设置导航栏标题文字
    self.navigationItem.title = @"活动报名支付";
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"支付" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)dataInitialize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}

-(void)uiLayout{
    _nameLabel.text = _activity.name;
    _contentLabel.text = _activity.content;
    _priceLabel.text = [NSString stringWithFormat:@"%@元",_activity.applyFee];
    
    //将表格视图设置为“编辑中”
    self.tableView.editing = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            NSString *tradeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_activity.name amount:_activity.applyFee tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@的活动报名费",_activity.name] itBPay:@"30"];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
}

-(void)purchaseResultAction:(NSNotification *)note{
    NSString *result = note.object;
    if ([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您，你已成功完成报名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请保持账户余额充足" : @"您已取消支付" andTitle:@"支付失败" onView:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}

//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//设置组的头标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"支付方式";
}

//按住细胞以后（取消选择）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != flag){
        flag = indexPath.row;
        //遍历表格视图中所有选中状态下的细胞
        for (NSIndexPath * eachIP in tableView.indexPathsForSelectedRows) {
            //当选中的细胞不是当前正在按的这个细胞的情况下
            if (eachIP != indexPath) {
                //将细胞从选中状态下改为不选中状态
                [tableView deselectRowAtIndexPath:eachIP animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == flag){
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
