//
//  CMMainViewController.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMMainViewController.h"
#import "CMSearchViewHeader.h"

@interface CMMainViewController ()

@property(nonatomic,weak) CMSearchView *searchView;


@end

@implementation CMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"搜索";
    
    CMSearchView *searchView = [[CMSearchView alloc]init];
    searchView.type = CMSearchViewTypeOnlyDisplay;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSearchView)];
    [searchView addGestureRecognizer:tap];
    
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.searchView.frame = CGRectMake(0, 64, self.view.frame.size.width, 55);
}


- (void)tapSearchView
{
    //关闭键盘
    [self.searchView endEditing:YES];
    
    //打开搜索控制器
    CMSearchViewController *searchVc = [[CMSearchViewController alloc]init];
    searchVc.title = @"搜索";
    [self.navigationController pushViewController:searchVc animated:NO];

}





@end
