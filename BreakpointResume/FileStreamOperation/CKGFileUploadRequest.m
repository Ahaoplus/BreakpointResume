//
//  CKGFileUploadRequest.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import "CKGFileUploadRequest.h"
#import "CKGFileUploadManager.h"
#import "CKGFileUploadCachedManager.h"
#import "ASIFormDataRequest.h"
#import "CKGFileUploadManager.h"
@implementation CKGFileUploadRequest
- (instancetype)initWithFragments:(NSArray *)fragments file:(CKGFileModel *)file fileStreamer:(FileStreamOperation *)fileStreamer isChatSend:(BOOL)isChatSend
{
    self = [super init];
    if (self) {
        __block float uploadCount = 0.0;
        NSInteger fileFragmentCount = fragments.count;
        for (int i = 0 ; i<fragments.count; i++) {
            NSString *urlString =nil;
            
            
            NSDictionary *postData = @{
                                       @"name":file.fileName,
                                       @"ext":file.fileExt,
                                       @"size":file.size,
                                       @"trunk_count":@(fileFragmentCount),
                                       @"trunk_id":@(i+1),
                                       @"md5":file.md5Str
                                       };
            ASIFormDataRequest *__weak request =nil;
            
            request.delegate = self;
            
            //获取对应文件分片
            __block NSData *data = [fileStreamer readDateOfFragment:fragments[i]];
            //表单填写
            [request setData:data  withFileName:file.fileName andContentType:@"multipart/form-data" forKey:@"file"];
            
            [request startAsynchronous];
            [request setCompletionBlock:^{
                NSString *string = request.responseString;
                NSDictionary *dataDic = @{@"status":@"1"};//Json解析;
                //                DLog(@" %zi dataDic:%@",i+1,dataDic);
                if ([dataDic[@"result"] integerValue] == 1 && [dataDic[@"data"][@"file_exists"] integerValue] == 0) {
                    uploadCount++;
                    //分片上传成功从沙盒对应路径删除
                    //                    [[CKGFileUploadCachedManager sharedInstance] removeFileByName:file.fileName fragment:i+1];
                    
                    //更新进度条（这里通过block或者通知传到需要更新进度条进度的地方）
                    NSLog(@"%@ progress>>>>>>>>>>>%f",file.fileName,(float)(uploadCount/fileFragmentCount));
                    if (file.isAsset) {
                        if (isChatSend) {
                            NSDictionary *dic = @{@"file":file,@"progress":@((float)(uploadCount * 1.0/fileFragmentCount))};
//                            [NC postNotificationName:@"CHATSENDFILE" object:dic];
                        }else
                        {
//                            [CKGFileUploadManager sharedInstance].upProgressBlock(file,(float)(uploadCount/fileFragmentCount),msg);
                        }
                    }
                    
                    if(uploadCount == fileFragmentCount)
                    {
                        //所有分片上传完毕删除对应文件
                        //                        [[CKGFileUploadCachedManager sharedInstance] deleteDirctoryAtPath:[NSString stringWithFormat:@"%@%@",file.md5Str,file.fileName]];
                        self.finishedBlock(file,fragments);
                        uploadCount = 0.0;
                    }
                }
            }];  
        }  
    }  
    return self;  
}



@end
