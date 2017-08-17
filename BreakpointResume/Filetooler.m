//
//  Filetooler.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/14.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import "Filetooler.h"
#import <UIKit/UIKit.h>
@implementation Filetooler


//保存图片
+(NSString*)saveImage:(NSString *)name withData:(NSData*)theData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSFileManager *fm=[NSFileManager defaultManager];
    
    NSString* home =[documentDirectory stringByAppendingPathComponent:MY_FILE];
    if (![fm fileExistsAtPath:home]) {
        [fm createDirectoryAtPath:home withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *file=[home stringByAppendingPathComponent:name];
    
    if ([fm fileExistsAtPath:file])
    {
        [fm removeItemAtPath:file error:nil];
    }
    if ([theData writeToFile:file atomically:YES]) {
        
    }
    return file;
}
//保存图片
+(NSString*)saveTMPImage:(NSString *)name withData:(NSData*)theData
{
    NSString *home=[NSHomeDirectory() stringByAppendingPathComponent:MY_FILE];
    NSFileManager *fm=[NSFileManager defaultManager];
    //	NSString *home=[NSHomeDirectory() stringByAppendingPathComponent:IMAGES_DATA];
    if (![fm fileExistsAtPath:home]) {
        [fm createDirectoryAtPath:home withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *file=[home stringByAppendingPathComponent:name];
    
    if ([fm fileExistsAtPath:file])
    {
        [fm removeItemAtPath:file error:nil];
    }
    if ([theData writeToFile:file atomically:YES]) {
        
    }
    return file;
}
/**
 *  得到某个路径下的文件压缩的数据
 *
 *  @param filePath 文件路径
 *
 *  @return 文件数据
 */
+(NSData*)dataOfFileInPath:(NSString*)filePath{
    NSURL* fileurl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",filePath]];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileurl];
    NSURLResponse *repsonse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&repsonse error:nil];
    return data;
}
///**
// *  根据文件路径
// *
// *  @param filePath 文件路径
// *
// *  @return 文件大小
// */
//+(NSString*)sizeOfFileInPath:(NSString*)filePath{
//    NSData* data = [FunctionUnit dataOfFileInPath:filePath];
//    // 得到mimeType
//    // NSLog(@"%@", repsonse.MIMEType);
////    return [NSString stringWithFormat:@"%ld%@",size,danWei];
//}
//保存文件
+(NSString*)saveFile:(NSString *)name withData:(NSData*)theData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSFileManager *fm=[NSFileManager defaultManager];
    //    NSString *home=[NSHomeDirectory() stringByAppendingPathComponent:FILE_CHACHE];
    NSString *home = [documentDirectory stringByAppendingPathComponent:MY_FILE];
    if (![fm fileExistsAtPath:home]) {
        [fm createDirectoryAtPath:home withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *file=[home stringByAppendingPathComponent:name];
    
    if ([fm fileExistsAtPath:file])
    {
        [fm removeItemAtPath:file error:nil];
    }
    [theData writeToFile:file atomically:YES];
    return file;
}
/**
 *  删除文件
 *
 *  @param filePath 文件路径
 */
+(void)deleteFileAtPath:(NSString*)filePath{
    NSFileManager *fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath])
    {
        [fm removeItemAtPath:filePath error:nil];
    }
    else{
        
    }
}
#pragma 文件操作 － end

+(NSArray*)fileInInboxPath{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *docDir = [NSString stringWithFormat:@"%@/Inbox",pathDocuments];
    
    
    NSError* error = nil;
    
    /*如果有此路径则获取该路径下的文件*/
    NSArray* filelist = [fileManager contentsOfDirectoryAtPath:docDir error:&error];
    
    
    if (error) {/*如果路经不存在则需要创建*/
        [fileManager createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {/*如果不能创建成功则报错*/
            NSLog(@"error is %@",error.description);
        }
        else{/*创建完路径后不尴尬的返回一个空数组*/
            filelist = [fileManager contentsOfDirectoryAtPath:docDir error:&error];
        }
    }
    
    return filelist;

}


//自定义目录
-(void)getLoacalFiles{
    //得到本地文件夹文件
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSString *docDir=[NSHomeDirectory() stringByAppendingPathComponent:MY_FILE];
    
    NSError* error = nil;
    
    /*如果有此路径则获取该路径下的文件*/
    NSArray* filelist = [filemanager contentsOfDirectoryAtPath:docDir error:&error];
    
    if (error) {/*如果路经不存在则需要创建*/
        [filemanager createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {/*如果不能创建成功则报错*/
            
            
        }
        else{/*如果有此路径则获取该路径下的文件*/
            filelist = [filemanager contentsOfDirectoryAtPath:docDir error:&error];
        }
    }
    
    
    for (int i = 0; i<[filelist count]; i++) {
        
        NSString* filename = [filelist objectAtIndex:i];
        
        NSString* localPath = [NSString stringWithFormat:@"%@/%@",docDir,[filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDate *fileModDate=[[filemanager attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",docDir,filename] error:nil] fileModificationDate];
        
       
    }
    
}

+(NSString*)fileSizeWithPath:(NSString*)localPath{
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    unsigned long long size =  [[filemanager attributesOfItemAtPath:localPath error:nil]fileSize];
    
    CGFloat sizef = 0.2f;
    NSString* danWei = @"B";
    if (size<1000.f) {
        danWei = @"B";
    }
    else if (size>1000.f&&size<1000.f*1000.f){
        danWei = @"K";
        sizef = size/1000.f;
    }
    else{
        danWei = @"M";
        sizef = size/(1000000.f);
    }

    return [NSString stringWithFormat:@"%f/%@",sizef,danWei];
}
@end
