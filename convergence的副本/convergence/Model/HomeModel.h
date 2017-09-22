//
//  HomeModel.h
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
//hot
@property (nonatomic,strong) NSString * hotId;
@property (nonatomic,strong) NSString * jingdu;
@property (nonatomic,strong) NSString * weidu;

@property (nonatomic,strong) NSString * logoimage;
@property (nonatomic,strong) NSString * advimage;
//second
@property(nonatomic)NSInteger clubId;
@property (nonatomic) NSInteger clubdis;
@property (nonatomic,strong) NSString * clubname;
@property (nonatomic,strong) NSString * clubaddress;
@property (nonatomic,strong) NSString * clubimage;
@property (nonatomic,strong) NSString * clubprice;
@property (strong,nonatomic) NSArray * experience;

@property (strong,nonatomic) NSString *memberId;
@property (strong,nonatomic) NSString *nickname;
@property (strong,nonatomic) NSString *avatarUrl;
//detail
@property (nonatomic,strong) NSString * clubadd;
@property (strong,nonatomic) NSString * introduce;
@property (strong,nonatomic) NSString * clubLogo;
@property (strong,nonatomic) NSString * clName;
@property (strong,nonatomic) NSString * clubTel;
@property (strong,nonatomic) NSString * clubTime;
@property (nonatomic) NSInteger  clubMember;//会员
@property (nonatomic) NSInteger clubPerson;//教练
@property (nonatomic) NSInteger clubSite;//场地
@property (strong,nonatomic) NSArray * experienceInfos;//体验劵信息
@property (strong,nonatomic) NSString * eLogo;
@property (strong,nonatomic) NSString * expNmae;
@property (strong,nonatomic) NSString * eId;
@property (nonatomic) NSInteger orginPrice;
@property (nonatomic) NSInteger number;

-(instancetype)initWithDetailNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithLeftNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithFirstNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithSecondNSDictionary:(NSDictionary *)dic;
@end
