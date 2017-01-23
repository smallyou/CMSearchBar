//
//  CMSearchViewController.h
//  CMSearchBar
//
//  Created by 23 on 2017/1/19.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSearchViewProtocol.h"
@interface CMSearchViewController : UIViewController

@property(nonatomic,weak) id<CMSearchViewProtocol> delegate;

/**占位符*/
@property(nonatomic,copy) NSString *placeholder;

@end
