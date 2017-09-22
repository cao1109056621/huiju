//
//  HomeTableViewCell.h
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
//firstcell
@property (weak, nonatomic) IBOutlet UIImageView *dianimage;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UILabel *diannameLbl;
@property (weak, nonatomic) IBOutlet UILabel *adressLbl;
@property (weak, nonatomic) IBOutlet UILabel *disLbl;
//secondcell
@property (weak, nonatomic) IBOutlet UIImageView *tiyanimage;
@property (weak, nonatomic) IBOutlet UILabel *tiyanLbl;
@property (weak, nonatomic) IBOutlet UILabel *rollLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *saleLbl;



@end
