//
//  CMMainViewController.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMMainViewController.h"
#import "CMSearchViewHeader.h"



@interface CMMainViewController () <CMSearchViewProtocol>

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
    searchVc.delegate = self;
    searchVc.title = @"搜索";
    [self.navigationController pushViewController:searchVc animated:YES];
    
    
    
}

#pragma mark - CMSearchViewDelegate
/**发起快捷搜索后的回调*/
- (void)searchView:(CMSearchView *)searchView quickSearchWithKeyword:(NSString *)keyword withResult:(void (^)(NSArray<CMSearchDisplayModel *> *, NSError *))result
{
    //构造假数据
    CMSearchDisplayModel *disM = [[CMSearchDisplayModel alloc]init];
    disM.title = [NSString stringWithFormat:@"快捷搜索的结果---%@",keyword];
    NSArray *array = @[disM];
    
    //回调
    result(array,nil);
}

/**发起模糊搜索后的回调*/
- (void)searchView:(CMSearchView *)searchView fuzzySearchWithKeyword:(NSString *)keyword withResult:(void (^)(NSArray<CMSearchDisplayModel *> *, NSError *))result
{
    //构造假数据
    CMSearchDisplayModel *dis = [[CMSearchDisplayModel alloc]init];
    dis.title = [NSString stringWithFormat:@"模糊搜索假数据--%@",keyword];
    dis.detailTitle = @"详细数据";
    NSArray *array = @[dis];
    
    //回调
    result(array,nil);
}

/**点击搜索结果后的回调*/
- (void)searchView:(CMSearchView *)searchView didSelectedSearchResult:(CMSearchDisplayModel *)searchDisplay atIndexPath:(NSIndexPath *)indexPath
{
    //搜索的显示数据
    NSLog(@"点击的是搜索结果===========");
}


@end
