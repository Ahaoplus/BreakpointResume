//
//  fileTableViewCell.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/9.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNFile.h"
@interface fileTableViewCell : UITableViewCell
@property(nonatomic,strong)CNFile* fileModel;
@end
