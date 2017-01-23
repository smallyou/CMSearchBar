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
#import "CMSearchDisplayModel.h"

typedef NS_ENUM(NSInteger,CMSearhDataSourceType) {
    CMSearhDataSourceTypeHistory = 0,               //历史记录(历史搜索关键词记录)
    CMSearhDataSourceTypeQuickSearch = 1,           //快速搜索(边输入边搜索，展示部分信息)
    CMSearhDataSourceTypeFuzzySearch = 2            //模糊搜索(点击搜索按钮后搜索，展示搜索的所有词条的所有信息)
};

@interface CMSearchViewController () <UITableViewDelegate,UITableViewDataSource,CMSearchViewProtocol,CMSectionHeaderViewDelegate>

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
    
    /**加载沙盒中的搜索历史数据*/
    self.searchHistorys = [NSMutableArray arrayWithArray:[CMSearchDisplayModel takeFromSandbox]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.searchView.frame = CGRectMake(0, 64, self.view.frame.size.width, 55);
    self.tableView.frame = CGRectMake(0, 64 + 60, self.view.frame.size.width, self.view.frame.size.height - 64 - 60);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //当前页面消失的时候，将内存中的搜索记录归档-存储沙盒
    [CMSearchDisplayModel saveArrayToSandbox:self.searchHistorys];
}


#pragma mark - 设置UI
/**初始化UI*/
- (void)setupUI
{
    CMSearchView *searchView = [[CMSearchView alloc]init];
    searchView.type = CMSearchViewTypeNormal;
    searchView.delegate = self;
    [searchView getInputPoint]; //获取输入焦点
    [self.view addSubview:searchView];
    self.searchView  = searchView;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 30;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    // 取出模型
    CMSearchDisplayModel *searchDisplay = self.searchDatas[indexPath.row];
    
    // 赋值
    cell.textLabel.text = searchDisplay.title;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *ID = @"header";
    CMSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView == nil) {
        headerView = [CMSectionHeaderView sectionHeaderView];
        headerView.delegate = self;
    }
    headerView.type = (self.dataSourceType == CMSearhDataSourceTypeHistory)?CMSectionHeaderViewTypeHistory:CMSectionHeaderViewTypeSearchResult;
    return headerView;
}

#pragma mark - UITableViewDelegate
/**当开始滚动的时候*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchView resignInputPoint];
}


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
    //设置当前的数据源类型
    self.dataSourceType = CMSearhDataSourceTypeFuzzySearch;
    
    //将当前搜索项作为搜索历史-去重
    CMSearchDisplayModel *searchHistory = [[CMSearchDisplayModel alloc]init];
    searchHistory.keyword = keyword;
    if (![CMSearchDisplayModel isHasMutiItem:searchHistory atHistorys:self.searchHistorys]) {
        [self.searchHistorys insertObject:searchHistory atIndex:0];
    }
    
    //准备数据
    [self setupDataWithKeyword:keyword];
}

#pragma mark - CMSectionHeaderViewDelegate
- (void)sectionHeaderView:(CMSectionHeaderView *)sectionHeader didClearBtnClicked:(UIButton *)button
{
    //将搜索历史记录清空
    [self.searchHistorys removeAllObjects];
    
    //如果当前是数据源是历史搜索记录 -- 刷新
    if (self.dataSourceType == CMSearhDataSourceTypeHistory) {
        [self.tableView reloadData];
    }
    
    //沙盒可以放在页面消失的时候一并存入
}


#pragma mark - 数据处理
/**准备数据*/
- (void)setupDataWithKeyword:(NSString *)keyword
{
    //--准备搜索历史数据
    if (self.dataSourceType == CMSearhDataSourceTypeHistory) {
        
        // 1 修改表格显示数据源
        self.searchDatas = self.searchHistorys;
        
        // 2 刷新表格
        [self.tableView reloadData];
        
    }
    //--准备快速搜索数据
    else if(self.dataSourceType == CMSearhDataSourceTypeQuickSearch){
        
        
        
        
    }
    //--准备模糊搜索数据
    else{
        
        
        
    }
    
}



@end
