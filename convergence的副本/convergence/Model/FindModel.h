//
//  FindModel.h
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject
@property (strong,nonatomic) NSString * clubID;
@property (strong,nonatomic) NSString * clubAdd;
@property (strong,nonatomic) NSString * clubImageUrl;
@property (strong,nonatomic) NSString * clubJing;
@property (strong,nonatomic) NSString * clubWei;
@property (strong,nonatomic) NSString * clubName;
@property (nonatomic) NSInteger  clubDis;

//筛选类型
@property(strong,nonatomic)NSString *fId;//健身类型id
@property(strong,nonatomic)NSString *fName;//健身类型名称
@property(strong,nonatomic)NSString *total;//包含该健身类型的健身会所数量
-(instancetype)initWithSxNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithFindNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithdisNSDictionary:(NSDictionary *)dict;

@end
