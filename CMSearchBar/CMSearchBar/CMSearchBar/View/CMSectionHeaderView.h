//
//  CMSectionHeaderView.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMSectionHeaderView;

typedef NS_ENUM(NSInteger,CMSectionHeaderViewType) {
    CMSectionHeaderViewTypeHistory = 0, //历史记录
    CMSectionHeaderViewTypeSearchResult = 1     //搜索结果
};

@protocol CMSectionHeaderViewDelegate <NSObject>

/**清楚历史按钮被点击*/
- (void)sectionHeaderView:(CMSectionHeaderView *)sectionHeader didClearBtnClicked:(UIButton *)button;

@end

@interface CMSectionHeaderView : UITableViewHeaderFooterView

#pragma mark - 属性
/**view的类型*/
@property(nonatomic,assign) CMSectionHeaderViewType type;
/**代理*/
@property(nonatomic,weak) id<CMSectionHeaderViewDelegate> delegate;

#pragma mark - 方法
/**快速创建方法*/
+ (instancetype)sectionHeaderView;




@end
