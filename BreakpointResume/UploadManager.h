//
//  UploadManager.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/7/26.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadManager : NSObject
@property (nonatomic,strong) NSMutableArray* fileArr;//标记每片的上传状态
@end
