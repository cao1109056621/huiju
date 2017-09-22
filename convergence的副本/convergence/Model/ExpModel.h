//
//  ExpModel.h
//  convergence
//
//  Created by admin on 2017/9/14.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpModel : NSObject
@property(strong,nonatomic)NSString * eId;
@property (strong,nonatomic)NSString *beginDate;
@property(strong,nonatomic)NSString *endDate;
@property(strong,nonatomic)NSString *userTime;
@property(strong,nonatomic)NSString *clubTel;
@property(strong,nonatomic)NSString *currentPrice;
@property(strong,nonatomic)NSString *orginPrice;
@property(strong,nonatomic)NSString *eName;
@property(strong,nonatomic)NSString *clubName;
@property(strong,nonatomic)NSString *eLogo;
@property(strong,nonatomic)NSString *latitude;
@property(strong,nonatomic)NSString *longitude;
@property(strong,nonatomic)NSString *rules;
@property(strong,nonatomic)NSString *salaCount;
@property(strong,nonatomic)NSString  * eAddress;
@property(strong,nonatomic)NSString  * ePromot;
-(instancetype)initWithexperience:(NSDictionary *)dict;
@end
