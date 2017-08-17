//
//  CNFile.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/1.
//  Copyright © 2017年 hzbt. All rights reserved.
//  文件块
/**
 Request URL:http://120.25.215.234:9001/document/upload?photo=true&resumableChunkNumber=1&resumableChunkSize=2097152&resumableCurrentChunkSize=2097152&resumableTotalSize=25723007&resumableType=video%2Fmp4&resumableIdentifier=25723007-01mp4-C0D0B333&resumableFilename=01.%E8%BF%9B%E7%A8%8B%E5%92%8C%E7%BA%BF%E7%A8%8B.mp4&resumableRelativePath=01.%E8%BF%9B%E7%A8%8B%E5%92%8C%E7%BA%BF%E7%A8%8B.mp4&resumableTotalChunks=12
 Request Method:POST
 Status Code:200
 Remote Address:120.25.215.234:9001
 Referrer Policy:no-referrer-when-downgrade
 Response Headers
 view source
 Access-Control-Allow-Headers:Authorization, Content-Type
 Access-Control-Allow-Methods:POST, PUT, GET, OPTIONS, DELETE
 Access-Control-Allow-Origin:*
 Access-Control-Max-Age:3600
 Cache-Control:no-cache, no-store, max-age=0, must-revalidate
 Content-Length:6
 Date:Tue, 08 Aug 2017 09:54:22 GMT
 Expires:0
 Pragma:no-cache
 X-Content-Type-Options:nosniff
 X-Frame-Options:DENY
 X-XSS-Protection:1; mode=block
 Request Headers
 view source
 Accept:
Accept-Encoding:gzip, deflate
Accept-Language:zh-CN,zh;q=0.8
Connection:keep-alive
Content-Length:2097152
Content-Type:application/octet-stream
Host:120.25.215.234:9001
Origin:http://120.25.215.234:9001
Referer:http://120.25.215.234:9001/test.html?nsukey=V2gzRqsMgol1zcv4sQPR3kjQOVVcBeaEcGFV%2B3A%2FB4yijBk0S38WP2U2JKfK%2F%2B3EZPMEx4MFezLAriX5vqI3NH5GTqnoc89E3ZWhkYUdwJ8cH3RFcnblU8leXTeTs%2FlPiUKOAYfH1tDoVxhbXgzlPaMAtVChS0spMWv4d4NLwUiUhuiW4nHCZ9JT8X4C1eHW
User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.109 Safari/537.36
Query String Parameters
view source
view URL encoded
 
 
 photo = 0;
 resumableChunkNumber = 0;
 resumableChunkSize = 1048576;
 resumableCurrentChunkSize = 1048576;
 resumableFilename = "iOS\U7f51\U7edc\U9ad8\U7ea7\U7f16\U7a0b.pdf";
 resumableIdentifier = "68794052-iOS.pdf-6813384";
 resumableRelativePath = "iOS\U7f51\U7edc\U9ad8\U7ea7\U7f16\U7a0b.pdf";
 resumableTotalChunks = 66;
 resumableTotalSize = 68794052;
 resumableType = "application/pdf";
 
 
photo:true
resumableChunkNumber:1
resumableChunkSize:2097152
resumableCurrentChunkSize:2097152
resumableTotalSize:25723007
resumableType:video/mp4
resumableIdentifier:25723007-01mp4-C0D0B333
resumableFilename:01.进程和线程.mp4
resumableRelativePath:01.进程和线程.mp4
resumableTotalChunks:12
 */

#define DefaultOffset (1024*1024*2)
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "ZHChunk.h"
@interface CNFile : NSObject

@property (nonatomic,copy) NSString* fileType;//image or movie

@property (nonatomic,copy) NSString* filePath;//文件在app中路径

@property (nonatomic,copy) NSString* fileName;//文件名

@property (nonatomic,assign) NSInteger fileSize;//文件大小

@property (nonatomic,assign) NSInteger trunks;//总片数

@property (nonatomic,copy) NSString* fileInfo;

@property (nonatomic,strong) NSMutableArray* fileArr;//标记每片的上传状态

@property (nonatomic,strong)NSString* resumableIdentifier;
+(NSArray*)getLocalFiles;

+(NSArray*)getInboxFile;

@end
