//
//  CKGFileUploadCachedManager.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKGFileUploadCachedManager : NSObject
{
    NSFileManager *_fm;
}

+ (instancetype)sharedInstance;

//判断文件是否存在
- (BOOL)fileIsExist:(NSString *)fileName;

//获取文件路径
- (NSString *)getFilePath:(NSString *)fileName;

//获取该文件路径下所有文件名
- (NSArray *)getAllFileNameInPath:(NSString *)fileName;

//创建上传路径
- (void)createUploadDirectoryPath;

//创建每个上传文件的文件夹
- (void)createUploadFilePath:(NSString *)fileName;

//写入文件分片到对应路径
- (void)writeFileWithData:(NSData *)fragment toPath:(NSString *)filePath;

//删除文件分片
- (void)removeFileByName:(NSString *)fileName fragment:(NSInteger)fragmentIndex;

//删除文件
- (void)deleteDirctoryAtPath:(NSString *)filePath;
@end
