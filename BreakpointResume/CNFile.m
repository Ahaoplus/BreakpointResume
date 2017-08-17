//
//  CNFile.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/1.
//  Copyright © 2017年 hzbt. All rights reserved.
//
/*
 1、读文件：获取路径、名称
 2、分块
 3、获取MEMType
 */
#import "CNFile.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "ZHChunk.h"

#import "Filetooler.h"
@implementation CNFile
@synthesize fileType;
@synthesize filePath;
@synthesize fileName;
@synthesize fileSize;
@synthesize trunks;
@synthesize fileInfo;
@synthesize fileArr;
@synthesize resumableIdentifier;
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setFilePath:(NSString *)m_filePath{
    filePath = m_filePath;
    fileType = [self getMIMETypeURLRequestAtPath:m_filePath];
    [self getMIMETypeWithPath:m_filePath];
}

-(void)setFileSize:(NSInteger)m_fileSize{
    fileSize = m_fileSize;
    //总片数
    if (fileSize<DefaultOffset) {
        trunks = 1;
    }else if (fileSize%DefaultOffset==0){
        trunks = fileSize/DefaultOffset;
    }
    else{
        trunks = fileSize/DefaultOffset+1;
    }
    
    fileArr = [[NSMutableArray alloc]initWithCapacity:trunks];
    
    for (int i = 0; i<trunks; i++) {
        
        [fileArr addObject:@(0)];
    }
}
-(void)getMIMETypeWithPath:(NSString*)path{
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response.MIMEType);

        fileType = response.MIMEType;
    }];
    
    [dataTask resume];
}


//向该文件发送请求,根据请求头拿到该文件的MIMEType
 -(NSString *)getMIMETypeURLRequestAtPath:(NSString*)path
{
    //1.确定请求路径
    NSURL *url = [NSURL fileURLWithPath:path];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.发送请求
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *mimeType = response.MIMEType;
    return mimeType;
}
//获取一个随机整数，范围在[from,to），包括from，不包括to
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}
+(NSString*)identifierWithStr:(NSString*)searchStr{
    // 准备对象
    
    NSString * regExpStr = @"[\u4e00-\u9fa5]";
    NSString * replacement = @"";
    // 创建 NSRegularExpression 对象,匹配 正则表达式
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSString *resultStr = searchStr;
    // 替换匹配的字符串为 searchStr
    resultStr = [regExp stringByReplacingMatchesInString:searchStr
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, searchStr.length)
                                            withTemplate:replacement];
    NSLog(@"\\nsearchStr = %@\\nresultStr = %@",searchStr,resultStr);
    resultStr  = [resultStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    return resultStr;
    
}


+(long long) fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
}
+(NSArray*)getLocalFiles{
    
    NSArray* fileNames = @[@"apple3_1",@"apple4_6",@"iOS网络高级编程",@"太极",@"壁纸java",@"aaa"];
    
    
    NSArray* fileTypes = @[@"jpg",@"jpg",@"pdf",@"jpg",@"jpg",@"txt"];
    
    NSMutableArray* files = [[NSMutableArray alloc]initWithCapacity:4];
    
    for (NSInteger i=0; i<fileNames.count; i++) {
        CNFile* file = [[CNFile alloc]init];
        
        file.fileType = @"image";//image or movie
        
        file.filePath = [[NSBundle mainBundle] pathForResource:fileNames[i] ofType:fileTypes[i]];//文件在app中路径
        
        file.fileName = [NSString stringWithFormat:@"%@.%@",fileNames[i],fileTypes[i]];//文件名
        
        
        NSInteger length  =  [CNFile fileSizeAtPath:file.filePath];;
        
        file.fileSize = length;//文件大小
        
        
        file.resumableIdentifier = [NSString stringWithFormat:@"%ld-%@-%d",(long)file.fileSize,[CNFile identifierWithStr:file.fileName],[CNFile getRandomNumber:0 to:10000000]];
        
        [files addObject:file];
        
    }
    return files;
}

+(NSArray*)getInboxFile{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *docDir = [NSString stringWithFormat:@"%@/Inbox",pathDocuments];
    
    NSArray* fileNames = [Filetooler fileInInboxPath];
    
    
    NSMutableArray* files = [[NSMutableArray alloc]initWithCapacity:4];
    
    for (NSInteger i=0; i<fileNames.count; i++) {
        CNFile* file = [[CNFile alloc]init];
        
        file.fileType = @"image";//image or movie
        
        file.filePath = [NSString stringWithFormat:@"%@/%@",docDir,fileNames[i]];//文件在app中路径
        
        file.fileName = fileNames[i];//文件名
        
        
        NSInteger length  =  [CNFile fileSizeAtPath:file.filePath];;
        
        file.fileSize = length;//文件大小
        
        file.resumableIdentifier = [NSString stringWithFormat:@"%ld-%@-%d",(long)file.fileSize,[CNFile identifierWithStr:file.fileName],[CNFile getRandomNumber:0 to:10000000]];
        
        [files addObject:file];
        
    }
    return files;
    
    
}
/*
 resumableChunkNumber:1
 resumableChunkSize:2097152
 resumableCurrentChunkSize:116676
 resumableTotalSize:116676
 resumableType:image/jpeg
 resumableIdentifier:116676-jpg-0BB87110
 resumableFilename:太极.jpg
 resumableRelativePath:太极.jpg
 resumableTotalChunks:1
 */

 //调用C语言的API来获得文件的MIMEType ，只能获取本地文件哦，无法获取网络请求来的文件
 -(NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
 {
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}



@end
