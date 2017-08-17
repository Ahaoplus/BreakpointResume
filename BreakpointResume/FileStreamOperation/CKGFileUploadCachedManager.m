//
//  CKGFileUploadCachedManager.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import "CKGFileUploadCachedManager.h"


static CKGFileUploadCachedManager *fileManager = nil;
@implementation CKGFileUploadCachedManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fm = [[NSFileManager alloc] init];;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!self) {
            fileManager  = [[CKGFileUploadCachedManager alloc] init];
        }
    });
    return fileManager;
}

#pragma mark - 是否存在该路径
- (BOOL)fileIsExist:(NSString *)fileName{
    //获取缓存目录下的路径
    NSString *filePath = [self getFilePath:fileName];
    return [_fm fileExistsAtPath:filePath];
}

#pragma mark - 获取文件路径
- (NSString *)getFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *lastUploadPath = [cachesDirectory stringByAppendingPathComponent:@"Upload"];
    NSString *filePath = [lastUploadPath stringByAppendingPathComponent:filename];
    return filePath;
}

#pragma mark - 获取该文件路径下所有文件名
- (NSArray *)getAllFileNameInPath:(NSString *)fileName
{
    NSMutableArray *fileNames = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *path= [self getFilePath:fileName]; // 要列出来的目录
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[_fm enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    
    NSMutableString *subPath = [[NSMutableString alloc] initWithCapacity:0];
    
    while((subPath=[myDirectoryEnumerator nextObject])!=nil)
    {
        NSLog(@"%@",subPath);
        NSString *deleteStr = [NSString stringWithFormat:@"%@/",path];
        
        [subPath deleteCharactersInRange:[subPath rangeOfString:deleteStr]];
        
        [fileNames addObject:subPath];
    }
    
    return (NSArray *)fileNames;
}

#pragma mark - 创建UPLOAD根文件夹
- (void)createUploadDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *lastUploadPath = [cachesDirectory stringByAppendingPathComponent:@"Upload"];
    
    BOOL fileExists = [_fm fileExistsAtPath:lastUploadPath];
    if (!fileExists)
    {//如果不存在则创建
        [_fm createDirectoryAtPath:lastUploadPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
}

#pragma mark - 创建每个上传文件的文件夹
- (void)createUploadFilePath:(NSString *)fileName;
{
    NSString *lastUploadPath = [self getFilePath:fileName];
    BOOL fileExists = [_fm fileExistsAtPath:lastUploadPath];
    if (!fileExists)
    {//如果不存在则创建
        [_fm createDirectoryAtPath:lastUploadPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
    
}

#pragma mark - 写入文件分片
- (void)writeFileWithData:(NSData *)fragment fragmentIndex:(NSInteger)fragmentIndex fileName:(NSString *)fileName
{
    NSString *tempPath = [[self getFilePath:fileName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%zi",fragmentIndex]];
    //写入
    [fragment writeToFile:tempPath atomically:YES];
}

#pragma mark - 删除文件分片
- (void)removeFileByName:(NSString *)fileName fragment:(NSInteger)fragmentIndex
{
    NSString *fragmentPath = [[self getFilePath:fileName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%zi",fragmentIndex]];
    NSLog(@"删除分片路径＊＊＊＊＊＊＊＊＊＊＊＊:%@",fragmentPath);
    NSError *err = nil;
    if (![_fm removeItemAtPath:fragmentPath error:&err])
    {
        NSLog(@"removeItem failed, err:%@", err);
    }
}

#pragma mark - 删除文件
- (void)deleteDirctoryAtPath:(NSString *)fileName{
    NSString *filePath = [[self getFilePath:fileName] stringByAppendingPathComponent:fileName];
    [_fm removeItemAtPath:filePath error:nil];
}

@end
