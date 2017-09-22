//
//  FindModel.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel
-(instancetype)initWithFindNSDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        
        _clubAdd = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@"未知"];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@"未知"];
        _clubDis = [[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"0"]integerValue ];
        self.clubImageUrl = [dict[@"clubLogo"]isKindOfClass:[NSNull class]]?@[@""]:dict[@"clubLogo"];
        _clubID = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        
        
    }
    return self;
}

-(instancetype)initWithdisNSDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if(self){
        
        _clubAdd = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@"未知"];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@"未知"];
        _clubDis = [[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"0"]integerValue ];
        self.clubImageUrl = [dict[@"clubLogo"]isKindOfClass:[NSNull class]]?@[@""]:dict[@"clubLogo"];
        _clubID = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        
    }
    return self;
}
-(instancetype)initWithSxNSDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if(self){
        
        _fId = [Utilities nullAndNilCheck:dict[@"fId"] replaceBy:@""];
        _fName = [Utilities nullAndNilCheck:dict[@"fName"] replaceBy:@""];
        _total = [Utilities nullAndNilCheck:dict[@"total"] replaceBy:@""];

        
    }
    return self;
}

@end
