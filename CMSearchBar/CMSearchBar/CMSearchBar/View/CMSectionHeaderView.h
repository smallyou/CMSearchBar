//
//  CMSectionHeaderView.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CMSectionHeaderViewType) {
    CMSectionHeaderViewTypeHistory = 0, //历史记录
    CMSectionHeaderViewTypeSearchResult = 1     //搜索结果
};

@interface CMSectionHeaderView : UITableViewHeaderFooterView

/**快速创建方法*/
+ (instancetype)sectionHeaderView;

@property(nonatomic,assign) CMSectionHeaderViewType type;



@end
