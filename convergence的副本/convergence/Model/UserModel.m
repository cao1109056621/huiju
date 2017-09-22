//
//  UserModel.m
//  convergence
//
//  Created by admin on 2017/9/19.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "UserModel.h"
#import <CoreImage/CoreImage.h>
#import "UserModel.h"
@implementation UserModel
-(id)initWithDictionary:(NSDictionary *)dict{
    self =[super init];
    if (self) {
        _memberId = [Utilities nullAndNilCheck:dict[@"memberId"] replaceBy:@"0"];
        _phone =[Utilities nullAndNilCheck:dict[@"contactTel"] replaceBy:@"未设置"] ;
        _nickname = [Utilities nullAndNilCheck:dict[@"memberName"] replaceBy:@"未命名"];
        //self.nick = [dict[@"memberName"] isKindOfClass:[NSNull class]] ? @"暂无" :dict[@"memberName"];
        _age = [Utilities nullAndNilCheck:dict[@"age"] replaceBy:@"0"];
        _dob = [Utilities nullAndNilCheck:dict[@"birthday"] replaceBy:@"0"];
        _idCardNo = [Utilities nullAndNilCheck:dict[@"identificationcard"] replaceBy:@"未设置"];
        _credit = [Utilities nullAndNilCheck:dict[@"memberPoint"] replaceBy:@"0"];
        _avatarUrl = [Utilities nullAndNilCheck:dict[@"memberUrl"] replaceBy:@"0"];
        _tokenKey = [Utilities nullAndNilCheck:dict[@"key"] replaceBy:@""];
        if ([dict[@"memberSex"]isKindOfClass:[NSNull class]]) {
            _gen = @"";
        }else{
            switch ([dict[@"memberSex"]integerValue]) {
                case 1:
                    _gen = @"男";
                    break;
                case 2:
                    _gen = @"女";
                    break;
                default:
                    _gen = @"未设置";
                    break;
            }
            
        }
    }
    return self;
}

@end
