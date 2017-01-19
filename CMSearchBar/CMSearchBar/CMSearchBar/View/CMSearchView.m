//
//  CMSearchView.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSearchView.h"
#import "CMSearchBar.h"

@interface CMSearchView()

@property(nonatomic,weak) CMSearchBar *searchBar;

@end

@implementation CMSearchView
{
    CGFloat _margin;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self customUI];
}

- (void)customUI
{
    //设置边距
    _margin = 10;
    
    //设置背景
    self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:246/255.0];
    
    //设置搜索条
    CMSearchBar *searchBar = [[CMSearchBar alloc]init];
    [searchBar addTarget:self action:@selector(searchBarEditingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    [searchBar addTarget:self action:@selector(searchBarTextChange) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:searchBar];
    self.searchBar = searchBar;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.searchBar.frame = CGRectMake(_margin, _margin, w - 2 * _margin, h - 2 * _margin);
}

#pragma mark - 事件监听
- (void)searchBarEditingDidBegin
{
    if ([self.delegate respondsToSelector:@selector(searchView:didSearchBarEditingDidBegin:)]) {
        [self.delegate searchView:self didSearchBarEditingDidBegin:self.searchBar];
    }
}

- (void)searchBarTextChange
{
    if ([self.delegate respondsToSelector:@selector(searchView:didSearchBarTextChanged:)]) {
        [self.delegate searchView:self didSearchBarTextChanged:self.searchBar];
    }
}



@end
