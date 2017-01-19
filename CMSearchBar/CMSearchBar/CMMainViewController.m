//
//  CMMainViewController.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMMainViewController.h"
#import "CMSearchView.h"

@interface CMMainViewController () <CMSearchViewProtocol>

@property(nonatomic,weak) CMSearchView *searchView;


@end

@implementation CMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"搜索";
    
    CMSearchView *searchView = [[CMSearchView alloc]init];
    searchView.delegate = self;
    
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.searchView.frame = CGRectMake(0, 64, self.view.frame.size.width, 55);
}


#pragma mark - CMSearchViewProtocol

- (void)searchView:(CMSearchView *)searchView didSearchBarEditingDidBegin:(CMSearchBar *)searchBar
{
    NSLog(@"搜索开始编辑");
}

- (void)searchView:(CMSearchView *)searchView didSearchBarTextChanged:(CMSearchBar *)searchBar
{
    NSLog(@"搜索内容发生改变");
}


@end
