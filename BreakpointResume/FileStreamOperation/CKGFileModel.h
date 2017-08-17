//
//  CKGFileModel.h
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/3.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKGFileModel : NSObject

@property(nonatomic,strong)NSString* fileName;
@property(nonatomic,strong)NSString* size;
@property(nonatomic,strong)NSString* fileExt;
@property(nonatomic,strong)NSString* md5Str;

@property(nonatomic,assign)BOOL isAsset;
@end
