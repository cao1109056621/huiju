//
//  ActModel.h
//  convergence
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActModel : NSObject
@property (strong, nonatomic) NSString *activityId; //活动ID
@property (strong, nonatomic) NSString *imgUrl;//活动图片URL字符串
@property (strong, nonatomic) NSString *name;  //活动名称
@property (strong, nonatomic) NSString *content;//活动内容
@property (nonatomic) NSInteger like;          //活动点赞数
@property (nonatomic) NSInteger unlike;        //活动被踩数
@property (nonatomic) BOOL isFavo;             //活动是否被收藏
@property (strong, nonatomic) NSString *address; //报名费
@property (strong, nonatomic) NSString *applyFee;//报名状态
@property (strong, nonatomic) NSString *attendence;//报名人数
@property (strong, nonatomic) NSString *atype; //类型
@property (strong, nonatomic) NSString *issure; //发布者名字
@property (strong, nonatomic) NSString *issurephone; //发布者电话号码
@property (strong, nonatomic) NSString *limitation; //限制报名人数
@property (nonatomic) NSTimeInterval dueTime;//截止时间
@property (nonatomic) NSTimeInterval startTime; //开始时间
@property (nonatomic) NSTimeInterval endTime; //结束时间
@property (nonatomic) NSInteger status; //状态
- (id) initWithDictionary: (NSDictionary *)dict;
- (id) initWithDetailDictionary: (NSDictionary *)dict;
@end
