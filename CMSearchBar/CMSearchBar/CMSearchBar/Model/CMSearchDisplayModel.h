//
//  CMSearchDisplayModel.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSearchDisplayModel : UITableViewHeaderFooterView <NSCoding>

#pragma mark - 通用属性
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *detailTitle;



#pragma mark - 搜索历史相关属性
/**上搜索关键词*/
@property(nonatomic,copy) NSString *keyword;

#pragma mark - 存储沙盒相关方法
+(NSArray *)takeFromSandbox;
+(void)saveArrayToSandbox:(NSArray *)array;

#pragma mark - 搜索历史相关方法
/**判断搜索记录数组中是否有重复*/
+(BOOL)isHasMutiItem:(CMSearchDisplayModel *)searchHistory atHistorys:(NSArray *)array;

@end
