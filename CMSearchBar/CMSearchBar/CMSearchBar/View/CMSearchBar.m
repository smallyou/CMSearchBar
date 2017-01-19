//
//  CMSearchBar.m
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSearchBar.h"

@interface CMSearchBar()

@property(nonatomic,weak) UIImageView *iconView;

@end

@implementation CMSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self customUI];
        
        
        
    }
    return self;
}


- (void)customUI
{
    //设置背景色
    self.backgroundColor = [UIColor whiteColor];
    
    //设置圆角
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    //设置搜索框的搜索图标
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"icon_search"];
    iconView.contentMode = UIViewContentModeCenter;
    self.leftView = iconView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.iconView = iconView;
    
        
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(5, 0.5 * (bounds.size.height - 17), 27, 17);
}


@end
