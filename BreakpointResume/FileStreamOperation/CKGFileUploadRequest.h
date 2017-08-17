//
//  CKGFileUploadRequest.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKGFileModel.h"
#import "FileStreamOperation.h"
#import <UIKit/UIKit.h>

//分片上传成功block回调
typedef void(^FragmentsUploadFinished)(CKGFileModel *fd, NSArray *fragments);

@interface CKGFileUploadRequest : NSObject

@property (nonatomic, copy)FragmentsUploadFinished finishedBlock;

//上传请求方法
- (instancetype)initWithFragments:(NSArray *)fragments file:(CKGFileModel *)file fileStreamer:(FileStreamOperation *)fileStreamer isChatSend:(BOOL)isChatSend;


@end
