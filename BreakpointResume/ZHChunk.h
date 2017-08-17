//
//  ZHChunk.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/8.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CNFile;
@interface ZHChunk : NSObject
@property (nonatomic,assign)BOOL photo;

@property (nonatomic,assign)NSInteger resumableChunkNumber;

@property (nonatomic,copy) NSString* resumableType;//image or movie

@property (nonatomic,copy) NSString* resumableRelativePath;//文件在app中路径

@property (nonatomic,copy) NSString* resumableFilename;//文件名

@property (nonatomic,assign)NSInteger resumableCurrentChunkSize;//当前块的大小

@property (nonatomic,assign)NSInteger resumableChunkSize; //块的标准大小

@property (nonatomic,assign) NSInteger resumableTotalSize;//文件大小

@property (nonatomic,assign) NSInteger resumableTotalChunks;//总片数

@property (nonatomic,copy) NSString* resumableIdentifier;

@property (nonatomic,assign)NSInteger uploadState;  //0，等待上传  ；1、上传成功；2、正在

@property (nonatomic,copy)NSData* chunkData;


+(ZHChunk*)readDataWithChunkNumber:(NSInteger)chunkNumber file:(CNFile*)file;
@end
