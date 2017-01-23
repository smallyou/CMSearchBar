//
//  CMSearchViewProtocol.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/19.
//  Copyright © 2017年 23. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMSearchBar,CMSearchView,CMSearchDisplayModel;

@protocol CMSearchViewProtocol <NSObject>

@optional

#pragma mark - 搜索相关方法
/**搜索条开始编辑*/
- (void)searchView:(CMSearchView *)searchView didSearchBarEditingDidBegin:(CMSearchBar *)searchBar;
/**搜索条内容发生改变*/
- (void)searchView:(CMSearchView *)searchView didSearchBarTextChanged:(CMSearchBar *)searchBar;
/**点击搜索按钮后的事件*/
- (void)searchView:(CMSearchView *)searchView didSearchBarReturnKeyClicked:(CMSearchBar *)searchBar keyword:(NSString *)keyword;

#pragma mark - 搜索结果相关处理方法
/**当搜索结果被点击后的调用（搜索结果包括快捷搜索和模糊搜索）*/
- (void)searchView:(CMSearchView *)searchView didSelectedSearchResult:(CMSearchDisplayModel *)searchDisplay atIndexPath:(NSIndexPath *)indexPath;

/**发起快捷搜索的时候调用，回调快捷搜索后的结果*/
- (void)searchView:(CMSearchView *)searchView quickSearchWithKeyword:(NSString *)keyword withResult:(void(^)(NSArray<CMSearchDisplayModel*> *array,NSError *error))result;

/**发起模糊搜索的时候调用，回调模糊搜索后的结果*/
- (void)searchView:(CMSearchView *)searchView fuzzySearchWithKeyword:(NSString *)keyword withResult:(void (^)(NSArray<CMSearchDisplayModel *> *, NSError *))result;

@end
