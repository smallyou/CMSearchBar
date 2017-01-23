//
//  CMSearchView.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSearchViewProtocol.h"

typedef NS_ENUM(NSInteger,CMSearchViewType) {
    CMSearchViewTypeNormal = 0, //正常状态，接受搜索请求
    CMSearchViewTypeOnlyDisplay = 1 //仅仅是展示使用，用来做跳转的，不做实际搜索
};

@interface CMSearchView : UIView

@property(nonatomic,weak) id <CMSearchViewProtocol> delegate;
@property(nonatomic,assign) CMSearchViewType type;

#pragma mark - 键盘相关方法
/**获取输入焦点*/
- (void)getInputPoint;

/**失去输入焦点*/
- (void)resignInputPoint;

/**设置占位符*/
- (void)setupPlaceholder:(NSString *)placeholder;

/**设置搜索框关键字*/
- (void)setupSearchKeyword:(NSString *)keyword;

@end
