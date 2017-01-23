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
    //[aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.detailTitle forKey:@"detailTitle"];
    [aCoder encodeObject:self.keyword forKey:@"keyword"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //self.title = [aDecoder decodeObjectForKey:@"title"];
        self.detailTitle = [aDecoder decodeObjectForKey:@"detailTitle"];
        self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
    }
    return self;
}

/**从沙盒中取出历史搜索记录*/
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

/**将搜索记录存入沙盒*/
+(void)saveArrayToSandbox:(NSArray *)array
{
    // 1 构造路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docPath stringByAppendingPathComponent:@"searchHistoryData.data"];
    
    // 2 归档
    [NSKeyedArchiver archiveRootObject:array toFile:path];
}

/**判断搜索记录数组中是否有重复*/
+(BOOL)isHasMutiItem:(CMSearchDisplayModel *)searchHistory atHistorys:(NSArray *)array
{
    for (CMSearchDisplayModel *item in array) {
        if ([item.keyword isEqualToString:searchHistory.keyword]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - 方法重写
- (void)setKeyword:(NSString *)keyword
{
    _keyword = keyword;
    
    if (keyword.length) {
        //
        self.title = keyword;
    }
}


@end
