//
//  FileStreamOperation.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FileFragmentMaxSize         1024 *1024 // 1MB
@class FileFragment;
@interface FileStreamOperation : NSObject<NSCoding>

@property (nonatomic, readonly, copy) NSString *fileName;//包括文件后缀名的文件名
@property (nonatomic, readonly, assign) NSUInteger fileSize;//文件大小
@property (nonatomic, readonly, copy) NSString *filePath;//文件所在的文件目录
@property (nonatomic, readonly, strong) NSArray<FileFragment*> *fileFragments;//文件分片数组

//若为读取文件数据，打开一个已存在的文件。
//若为写入文件数据，如果文件不存在，会创建的新的空文件。（创建FileStreamer对象就可以直接使用fragments(分片数组)属性）
- (instancetype)initFileOperationAtPath:(NSString*)path forReadOperation:(BOOL)isReadOperation ;

//获取当前偏移量
- (NSUInteger)offsetInFile;

//设置偏移量, 仅对读取设置
- (void)seekToFileOffset:(NSUInteger)offset;

//将偏移量定位到文件的末尾
- (NSUInteger)seekToEndOfFile;

//关闭文件
- (void)closeFile;

#pragma mark - 读操作
//通过分片信息读取对应的片数据
- (NSData*)readDateOfFragment:(FileFragment*)fragment;

//从当前文件偏移量开始
- (NSData*)readDataOfLength:(NSUInteger)bytes;

//从当前文件偏移量开始
- (NSData*)readDataToEndOfFile;

#pragma mark - 写操作
//写入文件数据
- (void)writeData:(NSData *)data;
@end
