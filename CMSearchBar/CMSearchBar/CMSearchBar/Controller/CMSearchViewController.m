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
#import "CMSearchItemCell.h"

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
/**是否显示 sectionHeader (是否显示 搜索历史和搜索结果 的提示)*/
@property(nonatomic,assign) BOOL isDisplaySectionTitle;
/**记录模糊搜索cell的类型*/
@property(nonatomic,copy) NSString *cellClass;
/**记录cell对应数据模型的属性名称*/
@property(nonatomic,copy) NSString *propertyName;



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
    self.tableView.frame = CGRectMake(0, 64 + 55, self.view.frame.size.width, self.view.frame.size.height - 64 - 55);
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
    //不显示sectionHeader
    self.isDisplaySectionTitle = NO;
    
    CMSearchView *searchView = [[CMSearchView alloc]init];
    searchView.type = CMSearchViewTypeNormal;
    searchView.delegate = self;
    [searchView getInputPoint]; //获取输入焦点
    [searchView setupPlaceholder:self.placeholder];
    [self.view addSubview:searchView];
    self.searchView  = searchView;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.sectionHeaderHeight = 30;
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
    if (self.dataSourceType == CMSearhDataSourceTypeFuzzySearch){
        
        /*
        static NSString *ID = @"fuzzySearch";
        CMSearchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[CMSearchItemCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        // 取出模型
        CMSearchDisplayModel *searchDisplay = self.searchDatas[indexPath.row];
        
        // 赋值
        cell.searchDisplay = searchDisplay;
        */
        
        static NSString *ID = @"fuzzySearch";
        Class class = NSClassFromString(self.cellClass);
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[class alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        // 取出模型
        id dataModel = self.searchDatas[indexPath.row];
        
        // KVC赋值
        [cell setValue:dataModel forKeyPath:self.propertyName];
    
        return cell;
    }
    else{
        
        static NSString *ID = @"historyAndQuickCell";
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

/**设置行高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == CMSearhDataSourceTypeFuzzySearch) {
        return 100;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isDisplaySectionTitle?30:0;
}

/**cell点击*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //关闭键盘
    [self.searchView resignInputPoint];
    
    //取出模型
    CMSearchDisplayModel *searchModel = self.searchDatas[indexPath.row];
    
    //点击的是搜索记录
    if (self.dataSourceType == CMSearhDataSourceTypeHistory) {
        //设置搜索框关键字
        [self.searchView setupSearchKeyword:searchModel.keyword];
        
        //将表格数据源标记为模糊搜索并准备数据
        self.dataSourceType = CMSearhDataSourceTypeFuzzySearch;
        [self setupDataWithKeyword:searchModel.keyword];
        
    }
    //点击的是搜索结果（快捷搜索结果+模糊搜索结果）
    else{
        
        NSLog(@"点击的是快捷搜索+模糊搜索");
        if ([self.delegate respondsToSelector:@selector(searchView:didSelectedSearchResult:atIndexPath:)]) {
            [self.delegate searchView:self.searchView didSelectedSearchResult:searchModel atIndexPath:indexPath];
        }
        
    }
    
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
    
        //发起快捷搜索请求
        if ([self.delegate respondsToSelector:@selector(searchView:quickSearchWithKeyword:withResult:)]) {
            [self.delegate searchView:self.searchView quickSearchWithKeyword:keyword withResult:^(NSArray<CMSearchDisplayModel *> *array, NSError *error) {
                
                if (error) {
                    return;
                }
                //准备数据
                self.searchDatas = [NSMutableArray arrayWithArray:array];
                
                //刷新表格
                [self.tableView reloadData];
                
            }];
        }
        
    }
    //--准备模糊搜索数据
    else{
        
        
        //发起模糊搜索请求
        /*
        if ([self.delegate respondsToSelector:@selector(searchView:fuzzySearchWithKeyword:withResult:)]) {
            [self.delegate searchView:self.searchView fuzzySearchWithKeyword:keyword withResult:^(NSArray<CMSearchDisplayModel *> *array, NSError *error) {
                
                if (error) {
                    return;
                }
                //准备数据
                self.searchDatas = [NSMutableArray arrayWithArray:array];
                
                //刷新表格
                [self.tableView reloadData];
                
            }];
        }
        */
        if ([self.delegate respondsToSelector:@selector(searchView:fuzzySearchWithKeyword:withResultAndCellType:)]) {
            [self.delegate searchView:self.searchView fuzzySearchWithKeyword:keyword withResultAndCellType:^(NSArray<id> *array, NSString *cellClass, NSString *propertyName, NSError *error) {
                if (error) {
                    return;
                }
                
                //记录cell的类型及其属性名称
                self.cellClass = cellClass;
                self.propertyName = propertyName;
                
                //准备数据
                self.searchDatas = [NSMutableArray arrayWithArray:array];
                
                //刷新表格
                [self.tableView reloadData];
            }];
        }
        
    }
    
}



@end
