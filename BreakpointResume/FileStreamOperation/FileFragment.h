//
//  FileFragment.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileFragment : NSObject<NSCoding>
@property (nonatomic,copy)NSString          *fragmentId;    //片的唯一标识
@property (nonatomic,assign)NSUInteger      fragmentSize;   //片的大小
@property (nonatomic,assign)NSUInteger      fragementOffset;//片的偏移量
@property (nonatomic,assign)BOOL            fragmentStatus; //上传状态 YES上传成功
@end
