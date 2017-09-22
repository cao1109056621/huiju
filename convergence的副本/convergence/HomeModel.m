//
//  HomeModel.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
-(instancetype)initWithFirstNSDictionary:(NSDictionary *)dict{
    self =[super init];
    if (self) {
        _hotId = [Utilities nullAndNilCheck:@"hot" replaceBy:@"0"];
        _weidu = [Utilities nullAndNilCheck:@"wei" replaceBy:@"0"];
        _jingdu = [Utilities nullAndNilCheck:@"jing" replaceBy:@"0"];
    }
    return self;
}

-(instancetype)initWithSecondNSDictionary:(NSDictionary *)dic{
    self =[super init];
    if (self) {
        //_clubId = [[Utilities nullAndNilCheck:@"id" replaceBy:@"id"]integerValue];
       // _clubdis = [[Utilities nullAndNilCheck:@"distance" replaceBy:@"distance"] integerValue];
        //_clubimage = [Utilities nullAndNilCheck:@"image" replaceBy:@"image"];
        //_clubaddress = [Utilities nullAndNilCheck:@"address" replaceBy:@"address"];
        //_clubname = [Utilities nullAndNilCheck:@"name" replaceBy:@"name"];
         //_clubprice = [Utilities nullAndNilCheck:@"price" replaceBy:@"price"];
        self.clubId = [dic[@"id"]isKindOfClass:[NSNull class]]?:[dic[@"id"] integerValue];
        self.clubimage = [dic[@"image"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"image"];
        self.clubprice = [dic[@"price"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"price"];
        self.clubname = [dic[@"name"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"name"];
        self.clubaddress = [dic[@"address"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"address"];
        self.clubdis = [dic[@"distance"]isKindOfClass:[NSNull class]]?:[dic[@"distance"]integerValue];
         self.logoimage = [dic[@"logo"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"logo"];
        self.advimage = [dic[@"imgurl"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"imgurl"];
        self.experience = [dic[@"experience"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"experience"];
        
    }
    return self;
}
-(instancetype)initWithLeftNSDictionary:(NSDictionary *)dict{
    self =[super init];
    if (self) {
        
        _memberId = [Utilities nullAndNilCheck:dict[@"memberId"] replaceBy:@"0"];
        _nickname = [Utilities nullAndNilCheck:dict[@"memberName"] replaceBy:@"未命名"];
        _avatarUrl = [Utilities nullAndNilCheck:dict[@"memberUrl"] replaceBy:@""];
    }
    return self;
}
-(instancetype)initWithDetailNSDictionary:(NSDictionary *)dic{
    self =[super init];
    if (self) {
        
        //_introduce = [Utilities nullAndNilCheck:dic[@"membeclubIntroducerId"] replaceBy:@""];
        self.introduce = [dic[@"clubIntroduce"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubIntroduce"];
        self.clubLogo = [dic[@"clubLogo"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubLogo"];
        self.clName = [dic[@"clubName"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubName"];
        self.clubTel = [dic[@"clubTel"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubTel"];
        self.clubTime = [dic[@"clubTime"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubTime"];
        self.clubMember = [dic[@"clubMember"]isKindOfClass:[NSNull class]]?:[dic[@"clubMember"] integerValue];
        self.clubPerson = [dic[@"clubPerson"]isKindOfClass:[NSNull class]]?:[dic[@"clubPerson"] integerValue];
        self.clubSite = [dic[@"clubSite"]isKindOfClass:[NSNull class]]?:[dic[@"clubSite"] integerValue];
        self.experienceInfos = [dic[@"experienceInfos"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"experienceInfos"];
        self.clubLogo = [dic[@"clubLogo"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubLogo"];
        self.clubadd = [dic[@"clubAddressB"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"clubAddressB"];
        self.eLogo = [dic[@"eLogo"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"eLogo"];
        self.expNmae = [dic[@"eName"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"eName"];
        self.orginPrice = [dic[@"orginPrice"]isKindOfClass:[NSNull class]]?0:[dic[@"orginPrice"] integerValue];
        self.number = [dic[@"number"]isKindOfClass:[NSNull class]]?0:[dic[@"number"] integerValue];
        self.eId = [dic[@"eId"]isKindOfClass:[NSNull class]]?@[@""]:dic[@"eId"];
        _jingdu = [Utilities nullAndNilCheck:dic[@"clubJing"] replaceBy:@""];
        _weidu = [Utilities nullAndNilCheck:dic[@"clubWei"] replaceBy:@""];
        
        
    }
    return self;
}
@end
