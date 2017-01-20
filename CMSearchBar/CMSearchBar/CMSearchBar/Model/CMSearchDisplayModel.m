//
//  CMSearchDisplayModel.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSearchDisplayModel.h"

@implementation CMSearchDisplayModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.detailLabel forKey:@"detailLabel"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.detailLabel = [aDecoder decodeObjectForKey:@"detailLabel"];
    }
    return self;
}

+(NSArray *)takeFromSandbox
{
    // 1 构造路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docPath stringByAppendingPathComponent:@"searchHistoryData.data"];
    
    // 2 取出数据
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    // 3 返回
    return array;
}



@end
