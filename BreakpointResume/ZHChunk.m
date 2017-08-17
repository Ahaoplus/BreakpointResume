//
//  ZHChunk.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/8.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import "ZHChunk.h"
#import "CNFile.h"
@implementation ZHChunk
@synthesize photo;
@synthesize resumableChunkNumber;//序号
@synthesize resumableType;//image or movie  video/mp4  MEMType
@synthesize resumableRelativePath;//文件在app中路径
@synthesize resumableFilename;//文件名
@synthesize resumableCurrentChunkSize;//当前块的大小
@synthesize resumableChunkSize; //块的标准大小
@synthesize resumableTotalSize;//文件大小
@synthesize resumableTotalChunks;//总片数
@synthesize resumableIdentifier;//文件ID:25723007-01mp4-C0D0B333
@synthesize uploadState;//上传状态

@synthesize chunkData;
-(instancetype)init{
    self = [super init];
    if (self) {
        
        photo = NO;
        
        resumableChunkSize = DefaultOffset;
        
        uploadState = 0;
    }
    return self;
}
//读取某一片段的信息
+(ZHChunk*)readDataWithChunkNumber:(NSInteger)chunkNumber file:(CNFile*)file{
    
    //总片数的获取方法（每一片的大小是1M）：
    
    //将文件分片，读取每一片的数据：
    
    NSData* data;
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:file.filePath];
    
    [readHandle seekToFileOffset:DefaultOffset * (chunkNumber-1)];
    
    data = [readHandle readDataOfLength:DefaultOffset];
    
    
    ZHChunk* chunk = [[ZHChunk alloc]init];
    
    chunk.chunkData = data;
    
    chunk.resumableChunkNumber = chunkNumber;
    
    chunk.resumableRelativePath = file.filePath;
    
    chunk.resumableFilename  = file.fileName;
    
    chunk.resumableCurrentChunkSize = data.length;
    
    chunk.resumableTotalSize = file.fileSize;
    
    chunk.resumableTotalChunks = file.trunks;
    
    chunk.resumableIdentifier = file.resumableIdentifier;
    
    chunk.resumableType = file.fileType;
    
    return chunk;
}

//generateUniqueIdentifier:function(file, event){
//    var custom = $.getOpt('generateUniqueIdentifier');
//    if(typeof custom === 'function') {
//        return custom(file, event);
//    }
//    var relativePath = file.webkitRelativePath||file.fileName||file.name; // Some confusion in different versions of Firefox
//    var size = file.size;
//    return(size + '-' + relativePath.replace(/[^0-9a-zA-Z_-]/img, ''));
//},
@end
