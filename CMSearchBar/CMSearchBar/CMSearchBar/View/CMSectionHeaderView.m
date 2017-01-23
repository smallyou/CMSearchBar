//
//  CMSectionHeaderView.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSectionHeaderView.h"

@interface CMSectionHeaderView()

/**titleLabel*/
@property(nonatomic,weak) UILabel *title_label;     //title
/**清除历史记录按钮*/
@property(nonatomic,weak) UIButton *clearButton;    //清除历史记录按钮


@end

@implementation CMSectionHeaderView

+ (instancetype)sectionHeaderView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //添加title
        UILabel *title_label  = [[UILabel alloc]init];
        self.title_label = title_label;
        [self.contentView addSubview:title_label];
        
        
        //添加清除历史记录按钮
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setTitle:@"清空" forState:UIControlStateNormal];
        clearButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
        self.clearButton = clearButton;
        [self.contentView addSubview:clearButton];
        
    }
    return self;
}

#pragma mark - 设置UI
/**布局子控件*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.title_label sizeToFit];
    [self.clearButton sizeToFit];
    CGFloat titleW = self.title_label.bounds.size.width;
    CGFloat titleH = self.title_label.bounds.size.height;
    self.title_label.frame = CGRectMake(15, 0.5 * (self.contentView.frame.size.height - titleH), titleW, titleH);
    
    CGFloat btnW = self.clearButton.bounds.size.width;
    CGFloat btnH = self.clearButton.bounds.size.height;
    self.clearButton.frame = CGRectMake(self.contentView.frame.size.width - 15 - btnW, 0.5 * (self.contentView.frame.size.height - btnH), btnW, btnH);
}

#pragma mark - 重写方法
-(void)setType:(CMSectionHeaderViewType)type
{
    _type = type;
    
    if (type == CMSectionHeaderViewTypeSearchResult) {
        self.title_label.text = @"搜索结果";
    }else{
        self.title_label.text = @"搜索历史";
    }
    self.clearButton.hidden = type;
}

#pragma mark - 事件监听
/**清除历史搜索记录*/
- (void)clearHistory:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(sectionHeaderView:didClearBtnClicked:)]) {
        [self.delegate sectionHeaderView:self didClearBtnClicked:button];
    }
}


@end
