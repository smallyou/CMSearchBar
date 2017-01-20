//
//  CMSearchDisplayModel.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSearchDisplayModel : UITableViewHeaderFooterView <NSCoding>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *detailLabel;


@end
