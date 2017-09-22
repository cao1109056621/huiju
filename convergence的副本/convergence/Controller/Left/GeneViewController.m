//
//  GeneViewController.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "GeneViewController.h"
#import <CoreImage/CoreImage.h>
#import "UserModel.h"
@interface GeneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic)NSString *QR;
@end

@implementation GeneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self netRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置标题文字
    self.navigationItem.title = @"我的推广";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 124, 236);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}


-(void)netRequest{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
    //    NSString *ID = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"];
    //    NSDictionary *para = @{@"memberId":ID};
    [RequestAPI requestURL:@"/mySelfController/getInvitationCode" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //    NSDictionary *result = responseObject[@"result"];
            //   _QR = result[@"result"];
            _QR =  responseObject[@"result"];
            
            //创建一个二维码滤镜实例（CIFilter）
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            //滤镜恢复默认设置
            [filter setDefaults];
            //给滤镜添加数据
            NSString *string = [NSString stringWithFormat:@"http://dwz.cn/%@",_QR];
            //将字符串转成二进制数据
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //通过KVC设置滤镜inputMessage数据
            [filter setValue:data forKeyPath:@"inputMessage"];
            //4.获取生成的图片
            CIImage *ciImg = filter.outputImage;
            //5.设置二维码的前景色和背景颜色
            CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
            //5.1设置默认值
            [colorFilter setDefaults];
            [colorFilter setValue:ciImg forKey:@"inputImage"];
            [colorFilter setValue:[CIColor colorWithRed:255 green:255 blue:255] forKey:@"inputColor0"];
            [colorFilter setValue:[CIColor colorWithRed:255 green:0 blue:255 alpha:0] forKey:@"inputColor1"];
            //[colorFilter setValue:[UIColor redColor] forKey:@"inputColor1"];
            // 6.获取滤镜输出的图像
            //CIImage *outputImage = [filter outputImage];
            ciImg = colorFilter.outputImage;
            // 7.将CIImage转成UIImage
            UIImage *image = [self createNonInterpolatedUIImageFormCIImage:ciImg withSize:200];
            
            //显示二维码
            _imageView.image = image;
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    //CGFloat scale = MIN(10, 20);
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
