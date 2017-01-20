//
//  CMSearchViewController.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/19.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSearchViewController.h"
#import "CMSearchView.h"
#import "CMSectionHeaderView.h"
#import "CMSearchBar.h"

typedef NS_ENUM(NSInteger,CMSearhDataSourceType) {
    CMSearhDataSourceTypeHistory = 0,               //历史记录(历史搜索关键词记录)
    CMSearhDataSourceTypeQuickSearch = 1,           //快速搜索(边输入边搜索，展示部分信息)
    CMSearhDataSourceTypeFuzzySearch = 2            //模糊搜索(点击搜索按钮后搜索，展示搜索的所有词条的所有信息)
};

@interface CMSearchViewController () <UITableViewDelegate,UITableViewDataSource,CMSearchViewProtocol>

@property(nonatomic,weak) CMSearchView *searchView;
@property(nonatomic,weak) UITableView *tableView;

/**表格数据源*/
@property(nonatomic,strong) NSMutableArray *searchDatas;
/**历史记录数据源*/
@property(nonatomic,strong) NSMutableArray *searchHistorys;

#pragma mark - 记录标志
/**数据源类型*/
@property(nonatomic,assign) CMSearhDataSourceType dataSourceType;




@end

@implementation CMSearchViewController

#pragma mark - 懒加载
- (NSMutableArray *)searchDatas
{
    if (_searchDatas == nil) {
        _searchDatas = [NSMutableArray array];
    }
    return _searchDatas;
}

- (NSMutableArray *)searchHistorys
{
    if (_searchHistorys == nil) {
        _searchHistorys = [NSMutableArray array];
    }
    return _searchHistorys;
}

#pragma mark - 系统回调方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**初始化UI*/
    [self setupUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.searchView.frame = CGRectMake(0, 64, self.view.frame.size.width, 55);
    self.tableView.frame = CGRectMake(0, 64 + 60, self.view.frame.size.width, self.view.frame.size.height - 64 - 60);
}


#pragma mark - 设置UI
/**初始化UI*/
- (void)setupUI
{
    CMSearchView *searchView = [[CMSearchView alloc]init];
    searchView.type = CMSearchViewTypeNormal;
    searchView.delegate = self;
    [self.view addSubview:searchView];
    self.searchView  = searchView;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 30;
    tableView.bounces = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource
/**行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = @"ljasjhflkjas";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *ID = @"header";
    CMSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView == nil) {
        headerView = [CMSectionHeaderView sectionHeaderView];
    }
    headerView.type = (self.dataSourceType == CMSearhDataSourceTypeHistory)?CMSectionHeaderViewTypeHistory:CMSectionHeaderViewTypeSearchResult;
    return headerView;
}

#pragma mark - UITableViewDelegate

#pragma mark - CMSearchViewProtocol
/**输入文字正在改变*/
- (void)searchView:(CMSearchView *)searchView didSearchBarTextChanged:(CMSearchBar *)searchBar
{
    //取出当前搜索框的文字
    NSString *keyword = searchBar.text;
    
    //判断数据源类型
    if (keyword.length == 0) {
        //搜索历史
        self.dataSourceType = CMSearhDataSourceTypeHistory;
        
    }else{
        //快速搜索
        self.dataSourceType = CMSearhDataSourceTypeQuickSearch;
    }
    
    //准备数据
    [self setupDataWithKeyword:keyword];
}

/**获取焦点，准备编辑*/
- (void)searchView:(CMSearchView *)searchView didSearchBarEditingDidBegin:(CMSearchBar *)searchBar
{
    //开始编辑的时候，显示的应该是历史记录信息
    self.dataSourceType = CMSearhDataSourceTypeHistory;
    
    //准备数据
    [self setupDataWithKeyword:nil];
}

/**点击搜索按钮*/
- (void)searchView:(CMSearchView *)searchView didSearchBarReturnKeyClicked:(CMSearchBar *)searchBar keyword:(NSString *)keyword
{
    self.dataSourceType = CMSearhDataSourceTypeFuzzySearch;
    
    //准备数据
    [self setupDataWithKeyword:keyword];
}

#pragma mark - 数据处理
/**准备数据*/
- (void)setupDataWithKeyword:(NSString *)keyword
{
    if (self.dataSourceType == CMSearhDataSourceTypeHistory) {
        //如果是准备历史搜索数据
        // 1 构造路径
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *path = [docPath stringByAppendingPathComponent:@"searchHistoryData.data"];
        
        // 2 取出数据
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.searchHistorys = [NSMutableArray arrayWithArray:array];
        
        [self.tableView reloadData];
        
    }else if(self.dataSourceType == CMSearhDataSourceTypeQuickSearch){
        //快速搜索数据
        
        
        
    }else{
        //模糊搜索数据
        
        
    }
    
    [self.tableView reloadData];
}

@end
