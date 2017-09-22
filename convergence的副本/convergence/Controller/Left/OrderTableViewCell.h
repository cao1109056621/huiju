//
//  OrderTableViewCell.h
//  convergence
//
//  Created by admin on 2017/9/19.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *OrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *OrderName;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
