//
//  CKGFileUploadManager.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import "CKGFileUploadManager.h"
#import "CKGFileModel.h"
#import "CKGFileUploadCachedManager.h"
#import "FileStreamOperation.h"
@implementation CKGFileUploadManager
#pragma mark - 上传功能
//- (void)uploadWithFile:(CKGFileModel *)file VC:(UIViewController *)vc
//{
//    //获取文件分片数组
//    
////    fileStreamer = [[FileStreamOperation alloc] initFileOperationAtPath:[self getFilePath:file.fileName] forReadOperation:YES];
////    if (fileStreamer.fileFragments.count)
////    {
////        [self uploadWithFragment:fileStreamer.fileFragments file:file];
////    }
//}
//
////上传文件分片
//- (void)uploadWithFragment:(NSArray *)fragments file:(CKGFileModel *)file
//{
//    dispatch_group_t group = dispatch_group_create ();
//    
//    //创建上传缓存路径
//    [[CKGFileUploadCachedManager sharedInstance] createUploadDirectoryPath];
//    
//    //创建上传的文件路径 md5Str+fileName
//    [[CKGFileUploadCachedManager sharedInstance] createUploadFilePath:[NSString stringWithFormat:@"%@%@",file.md5Str,file.fileName]];
//    
//    //检查该文件是否在本地沙河中存在，文件名格式为文件md5Str+fileName
//    NSString *filePath = [[CKGFileUploadCachedManager sharedInstance] getFilePath:[NSString stringWithFormat:@"%@%@",file.md5Str,file.fileName]];
//    
//    NSArray *tempFragments;
//    
//    if ([[CKGFileUploadCachedManager sharedInstance] fileIsExist:filePath]) {
//        //存在,说明是断点续传，只需要上传本地之外的文件分片
//        //获取还没上传的文件分片数组
////        tempFragments = [self getNotUploadedFragments:file];
//    }else
//    {
//        //不存在，整个文件分片都下载;
//        //所有分片写入到沙盒
//        
//        for (int i=0; i<fragments.count;i++)
//        {
//            NSString *fragPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",i+1]];
////            NSData *data = [fileStreamer readDateOfFragment:fragments[i]];
//            [[CKGFileUploadCachedManager sharedInstance] writeFileWithData:data toPath:fragPath];
//        }
//        tempFragments = fragments;
//    }
//    
//    dispatch_queue_t queue = dispatch_queue_create("fragment.queue", DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_async(queue, ^{
//        //上传请求
//        CKGFileUploadRequest *fragmentRequest = [[CKGFileUploadRequest alloc] initWithFragments:fragments file:file fileStreamer:fileStreamer isChatSend:_isChatSend message:message];
//        fragmentRequest.finishedBlock = ^(CKGFileModel *fd,NSArray *fgts){
//            //合并请求
//            NSLog(@"********************%@分片上传完成",file.fileName);
//            [self combineWith:fgts file:fd message:message];
//        };
//    });
//}
//
////上传文件分片，所有片都上传完毕后合并
//- (void)combineWith:(NSArray *)fragments file:(CKGFileModel *)file message:(Message *)message
//{
//    NSString *urlString = [BASE_URL stringByAppendingString:@"/api/upload/formFile"];
//    NSString *myId = [UD objectForKey:UID_KEY];
//    
//    //    //文件名去掉后缀
//    NSMutableString *tempStr = [NSMutableString stringWithString:file.fileName];
//    
//    NSString *extStr = [NSString stringWithFormat:@".%@",file.fileExt];
//    
//    NSRange range = [tempStr rangeOfString:extStr.lowercaseString];
//    
//    [tempStr deleteCharactersInRange:range];
//    //
//    //    file.fileName = tempStr;
//    
//    NSDictionary *postData = @{
//                               @"uid":CheckStringValue(myId),
//                               @"act":CheckStringValue(@"join"),
//                               @"name":CheckStringValue(tempStr),
//                               @"ext":CheckStringValue(file.fileExt),
//                               @"size":CheckStringValue(file.size),
//                               @"trunk_count":@(fragments.count),
//                               @"md5":CheckStringValue(file.md5Str)
//                               };
//    ASIFormDataRequest *__weak request = [CKGHttpBase requestWithURLString:urlString
//                                                         andPostDictionary:postData];
//    
//    request.delegate = self;
//    
//    [request startAsynchronous];
//    [request setCompletionBlock:^{
//        NSString *string = request.responseString;
//        NSDictionary *dataDic = [string objectFromJSONString];
//        DLog(@" bb dataDic:%@",dataDic);
//        if ([dataDic[@"result"] integerValue]==1 && [dataDic[@"data"][@"file_exists"] integerValue]==1) {
//            NSString *storageID = dataDic[@"data"][@"storage_id"];
//            NSDictionary *fileDic = @{@"storage_id":storageID,@"name":tempStr};
//            file.storageId = storageID;
//            file.fileUrl = dataDic[@"data"][@"url"];
//            //上传到云端
//            if (_isSend) {
//                self.sendBlock(file,storageID,message);
//            }else{
//                [self uploadToCloudWithFileDic:fileDic file:file];
//            }
//            
//        }
//    }];
//}
//
//#pragma mark - 上传到云端
//- (void)uploadToCloudWithFileDic:(NSDictionary *)fileDic file:(CKGFileModel *)file
//{
//    NSString *dir_id = _dir_id.length?_dir_id:@"0";
//    [CKGHttpManager cloudUploadFileWithUid:@""
//                                    dir_id:dir_id
//                                     files:fileDic
//                                  andBlock:^(BOOL resultBool, NSString *message, NSDictionary *data) {
//                                      _dir_id = @"0";
//                                      if (resultBool == 1) {
//                                          [NC postNotificationName:@"kMyFileCurrentVCRefresh" object:nil];
//                                          self.cloudUploadBlock(file,YES);
//                                      }else
//                                      {
//                                          [_holdVC.navigationController.view addHUDLabelView:[NSString stringWithFormat:@"%@上传失败",file.fileName] Image:nil afterDelay:1];
//                                          self.cloudUploadBlock(file,NO);
//                                      }
//                                  }];
//}
@end
