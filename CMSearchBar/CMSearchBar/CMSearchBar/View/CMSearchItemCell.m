//
//  CMSearchItemCell.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/23.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSearchItemCell.h"
#import "CMSearchDisplayModel.h"

@interface CMSearchItemCell ()

/**title标签*/
@property(nonatomic,weak) UILabel *title_label;
/**详细标签*/
@property(nonatomic,weak) UILabel *detail_label;
/**图标*/
@property(nonatomic,weak) UIImageView *iconView;

@end


@implementation CMSearchItemCell


- (void)setSearchDisplay:(CMSearchDisplayModel *)searchDisplay
{
    _searchDisplay = searchDisplay;
    if (searchDisplay.title.length) {
        UILabel *title_label = [[UILabel alloc]init];
        title_label.text = searchDisplay.title;
        [self.contentView addSubview:title_label];
        self.title_label = title_label;
    }
    
    if (searchDisplay.detailTitle.length) {
        UILabel *detail_label = [[UILabel alloc]init];
        detail_label.text = searchDisplay.detailTitle;
        [self.contentView addSubview:detail_label];
        self.detail_label = detail_label;
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
    }
    
    
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //布局iconView
    self.iconView.frame = CGRectMake(20, 20, 60, 60);

    //布局title
    self.title_label.frame = CGRectMake(20 + 60 + 10, 20, self.frame.size.width - 20 - 60 - 10 - 20, 28);
    
    //布局detail_label
    if (self.detail_label.text.length) {
        self.detail_label.frame = CGRectMake(20 + 60 + 10, CGRectGetMaxY(self.title_label.frame) + 10, self.frame.size.width - 20 - 60 - 10 - 20, 28);
    }
    
    
}


@end
