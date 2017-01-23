//
//  CMSearchViewProtocol.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/19.
//  Copyright © 2017年 23. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMSearchBar,CMSearchView;

@protocol CMSearchViewProtocol <NSObject>

#pragma mark - 搜索相关方法
/**搜索条开始编辑*/
- (void)searchView:(CMSearchView *)searchView didSearchBarEditingDidBegin:(CMSearchBar *)searchBar;
/**搜索条内容发生改变*/
- (void)searchView:(CMSearchView *)searchView didSearchBarTextChanged:(CMSearchBar *)searchBar;
/**点击搜索按钮后的事件*/
- (void)searchView:(CMSearchView *)searchView didSearchBarReturnKeyClicked:(CMSearchBar *)searchBar keyword:(NSString *)keyword;




@end
