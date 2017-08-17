//
//  DownloadManager.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/7/26.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <UIKit/UIKit.h>
@interface DownloadManager : NSObject
+(void)downLoadActionWithProgressView:(UIProgressView*)progressView
                                 task:(NSURLSessionDownloadTask**)task
                            imageView:(UIImageView*)imageView;
@end
