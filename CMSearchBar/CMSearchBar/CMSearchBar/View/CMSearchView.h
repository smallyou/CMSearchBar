//
//  CMSearchView.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/18.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSearchViewProtocol.h"

@interface CMSearchView : UIView

@property(nonatomic,weak) id <CMSearchViewProtocol> delegate;

@end
