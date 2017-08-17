//
//  CKGFileUploadManager.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKGFileModel.h"
@interface CKGFileUploadManager : NSObject
- (void)uploadWithFile:(CKGFileModel *)file VC:(UIViewController *)vc;
@end
