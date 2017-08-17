//
//  fileTableViewCell.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/8/9.
//  Copyright © 2017年 hzbt. All rights reserved.
//
// 获取当前屏幕的高度
#define kMainScreenHeight ([UIScreen mainScreen].applicationFrame.size.height)
// 获取当前屏幕的宽度
#define kMainScreenWidth  ([UIScreen mainScreen].applicationFrame.size.width)
//@"http://10.122.251.224:9001"
#define HostIPPort @"http://120.25.215.234:9001"
#import "fileTableViewCell.h"
#import "CNFile.h"
#import <AFNetworking.h>

@interface fileTableViewCell()<NSURLSessionDelegate,NSURLSessionTaskDelegate>{
    NSInteger nowChunkNumber;
    NSInteger haveUploaded;
    
    NSURLSessionDataTask* sessionDataTask;
    
}
@property(nonatomic,strong)UIButton* uploadButton;
@property(nonatomic,strong)UILabel* numberLabel;
@property(nonatomic,strong)NSProgress* progress;
@end
@implementation fileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.uploadButton];
        [self.contentView addSubview:self.numberLabel];
        nowChunkNumber = 1;
    }
    
    return self;
}
-(UIButton*)uploadButton{
    if (_uploadButton==nil) {
        _uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-100, 0, 100, 100)];
        [_uploadButton setTitle:@"Start" forState:UIControlStateNormal];
        [_uploadButton setTitle:@"Pause" forState:UIControlStateSelected];
        [_uploadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        [_uploadButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}
-(UILabel*)numberLabel{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-200, 0, 100, 100)];
        
        _numberLabel.textColor = [UIColor blackColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font =[UIFont systemFontOfSize:15.f];
    }
    return _numberLabel;
}
-(void)buttonAction:(UIButton*)button{
    button.selected = !button.selected;
    
    if (button.selected) {
        
        [self uploadFile:_fileModel];
        
    }else{
        
        [sessionDataTask suspend];
        
        //[self.downloadTask cancel];//取消
    }
    
}
-(void)setFileModel:(CNFile *)fileModel{
    _fileModel = fileModel;
    
    NSUInteger length = fileModel.fileSize;
    
    self.progress = [NSProgress progressWithTotalUnitCount:length];
    
    // 注册一个监听器  KVO
    [self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    
    self.textLabel.text = fileModel.fileName;
}

//递归上传
-(void)uploadFile:(CNFile*)fileModel{
    
    if (fileModel==nil) {
        return;
    }
    
    ZHChunk* chunkToUpload = [ZHChunk readDataWithChunkNumber:nowChunkNumber file:fileModel];
    if(chunkToUpload.resumableChunkSize==0){
        NSLog(@"没有数据了");
        return;
    }
    else if (chunkToUpload.resumableCurrentChunkSize<chunkToUpload.resumableChunkSize){
        NSLog(@"最后一下子");
    }
    
    
    //chunkToUpload.photo
    NSDictionary* params = @{
                          @"photo":@(chunkToUpload.photo),
                          @"resumableChunkNumber":@(nowChunkNumber),
                          @"resumableChunkSize":@(chunkToUpload.resumableChunkSize),
                          @"resumableCurrentChunkSize":@(chunkToUpload.resumableCurrentChunkSize),
                          @"resumableTotalSize":@(chunkToUpload.resumableTotalSize),
                          @"resumableType":chunkToUpload.resumableType,
                          @"resumableIdentifier":chunkToUpload.resumableIdentifier,
                          @"resumableFilename":chunkToUpload.resumableFilename,
                          @"resumableRelativePath":chunkToUpload.resumableFilename,
                          @"resumableTotalChunks":@(chunkToUpload.resumableTotalChunks)
                          };
    NSString* paramStr = [NSString stringWithFormat:@"photo=%@&resumableChunkNumber=%@&resumableChunkSize=%@&resumableCurrentChunkSize=%@&resumableTotalSize=%@&resumableType=%@&resumableIdentifier=%@&resumableFilename=%@&resumableRelativePath=%@&resumableTotalChunks=%@",@(chunkToUpload.photo),
                          @(nowChunkNumber),
                          @(chunkToUpload.resumableChunkSize),
                          @(chunkToUpload.resumableCurrentChunkSize),
                          @(chunkToUpload.resumableTotalSize),
                          chunkToUpload.resumableType,
                          chunkToUpload.resumableIdentifier,
                          chunkToUpload.resumableFilename,
                          chunkToUpload.resumableFilename,
                          @(chunkToUpload.resumableTotalChunks)];
    
//    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:paramStr] invertedSet];
//    
//    NSString *encodedUrl = [paramStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    paramStr = [paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    // 1.创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应

    // 2.利用网络管理者上传数据
    // formData: 专门用于拼接需要上传的数据
    __weak fileTableViewCell* weakSelf = self;
    
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/document/upload?%@",HostIPPort,paramStr];

    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //Get请求成功发现该片已存在
        [weakSelf uploadNextChunk];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        //通讯协议状态码
        NSInteger statusCode = response.statusCode;
        //服务器端约定先get请求一次如果状态为404则证明该片不存在可以上传
        if (statusCode==404) {
            
            [weakSelf uploadFileUseMyselfMethod:params chunkToUpload:chunkToUpload url:urlStr];
            
        }
    }];

}
//http://www.cnblogs.com/ldnh/p/5304279.html
-(void)uploadFileUseMyselfMethod:(NSDictionary*)dic chunkToUpload:(ZHChunk*)chunkToUpload url:(NSString*)urlStr{
    /**
     *  post的上传文件，不同于普通的数据上传，
     *  普通上传，只是将数据转换成二进制放置在请求体中，进行上传，有响应体得到结果。
     *  post上传，当上传文件是， 请求体中会多一部分东西， Content——Type，这是在请求体中必须要书写的，而且必须要书写正确，不能有一个标点符号的错误。负责就会请求不上去，或者出现请求的错误（无名的问题等）
     *  其中在post 请求体中加入的格式有{1、边界 2、参数 3、换行 4、具体数据 5、换行 6、边界 7、换行 8、对象 9、结束符}
     */
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置请求头数据 。  boundary：边界
    [request setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = chunkToUpload.chunkData;
    
    // 设置请求方式 post
    request.HTTPMethod = @"POST";
    
    
     NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    sessionDataTask = nil;
    sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        __weak fileTableViewCell* weakSelf = self;
        
        
        if (chunkToUpload.resumableCurrentChunkSize<chunkToUpload.resumableChunkSize){
            NSLog(@"-----%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
        else if (chunkToUpload.resumableCurrentChunkSize>0) {
            [weakSelf uploadNextChunk];
            
        }else{
            NSLog(@"+++++++++%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
    }];
    [sessionDataTask resume];
    
    
    
//ios 7之前方式
//    [NSURLConnection sendAsynchronousRequest:request  queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        __weak fileTableViewCell* weakSelf = self;
//        
//        
//        if (chunkToUpload.resumableCurrentChunkSize<chunkToUpload.resumableChunkSize){
//            NSLog(@"-----%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        }
//        else if (chunkToUpload.resumableCurrentChunkSize>0) {
//            [weakSelf uploadNextChunk];
//            
//        }
////        else{
////            NSLog(@"+++++++++%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
////        }
//        NSLog(@"+++++++++%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        
//    }];
 
}
//执行下一次上传
-(void)uploadNextChunk{
    
    if (self.uploadButton.selected) {
        nowChunkNumber++;
        [self uploadFile:_fileModel];
    }
    
}


/**
 在主线程更新进度百分比

 @param completedNum 已经完成，，，
 */
-(void)updateProgress:(int64_t)completedNum{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        
        CGFloat progressf = (CGFloat)((nowChunkNumber-1)*DefaultOffset+completedNum)/self.progress.totalUnitCount;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
        progressf = progressf*100;
        if (progressf>100) {
            progressf = 100;
        }
        NSString* showStr = [NSString stringWithFormat:@"%0.f%c",progressf,'%'];
        _numberLabel.text = showStr;
    });
    
    NSLog(@"%lld  %lld",self.progress.totalUnitCount,completedNum);
}


//接收到服务器响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSLog(@"%s",__FUNCTION__);
    
    //允许接受服务器回传数据
    completionHandler(NSURLSessionResponseAllow);
}

//接收服务器回传的数据,有可能执行多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

//请求成功或失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"%@",error);
}


/**
 检测网络请求上传进度

 @param session session
 @param task 任务
 @param bytesSent 本次上传byte数
 @param totalBytesSent 总共已上传byte数
 @param totalBytesExpectedToSend 总共需要上传tyte数（由于是分块上传所以这里不能当作分母）
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{

    NSLog(@"bytesSent:%lld totalBytesSent:%lld totalBytesExpectedToSend:%lld",
          bytesSent,totalBytesSent,totalBytesExpectedToSend);
    [self updateProgress:totalBytesSent];
    
}


#pragma mark wuyong
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
}
//尝试方法一：
/*
-(void)uploadFileWithData:(NSDictionary*)dic chunkToUpload:(ZHChunk*)chunkToUpload url:(NSString*)urlStr{
    
    // 1.创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.requestSerializer= [AFHTTPRequestSerializer serializer];//请求
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer= [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//响应
    
    __weak fileTableViewCell* weakSelf = self;
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
 
         //Data: 需要上传的数据
         //name: 服务器参数的名称
         //fileName: 文件名称
         //mimeType: 文件的类型
        if ([chunkToUpload.chunkData isKindOfClass:[NSData class]]) {
            
            [formData appendPartWithFileData:chunkToUpload.chunkData name:@"file" fileName:chunkToUpload.resumableFilename mimeType:chunkToUpload.resumableType];
        }
        
        
    } progress:^void(NSProgress *uploadProgress){
        [weakSelf updateProgress:uploadProgress.completedUnitCount];
        
    } success:^void(NSURLSessionDataTask * task, id responseObject) {
        // 请求成功
        
        NSError *jsonError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
        if (!jsonError) {
            NSLog(@"请求成功 %@", object);
        }else{
            
        }
        
        if (chunkToUpload.resumableCurrentChunkSize<chunkToUpload.resumableChunkSize){
            NSLog(@"请求成功 %@", responseObject);
        }
        else if (chunkToUpload.resumableCurrentChunkSize>0) {
            [weakSelf uploadNextChunk];
        }
        else{
            NSLog(@"请求成功 %@", responseObject);
        }
        
        
    } failure:^void(NSURLSessionDataTask * task, NSError * error) {
        // 请求失败
        NSLog(@"请求失败 %@", error.description);
    }];
}

*/

//尝试方法二：
/*
-(void)commitClick:(CNFile*)fileModel
{
    
    __weak typeof(self) weakSelf = self;
    
    if (fileModel==nil) {
        return;
    }
    if (nowChunkNumber>fileModel.trunks) {
        return;
    }
    ZHChunk* chunkToUpload = [ZHChunk readDataWithChunkNumber:nowChunkNumber file:fileModel];
    NSUInteger length = chunkToUpload.resumableCurrentChunkSize;
    self.progress = [NSProgress progressWithTotalUnitCount:length];
    
    NSDictionary* paraDic = @{
                          @"photo":@(chunkToUpload.photo),
                          @"resumableChunkNumber":@(nowChunkNumber),
                          @"resumableChunkSize":@(chunkToUpload.resumableChunkSize),
                          @"resumableCurrentChunkSize":@(chunkToUpload.resumableCurrentChunkSize),
                          @"resumableTotalSize":@(chunkToUpload.resumableTotalSize),
                          @"resumableType":chunkToUpload.resumableType,
                          @"resumableIdentifier":chunkToUpload.resumableIdentifier,
                          @"resumableFilename":chunkToUpload.resumableFilename,
                          @"resumableRelativePath":chunkToUpload.resumableFilename,
                          @"resumableTotalChunks":@(chunkToUpload.resumableTotalChunks)
                          };
    
    NSString* paramStr = [NSString stringWithFormat:@"photo=%@&resumableChunkNumber=%@&resumableChunkSize=%@&resumableCurrentChunkSize=%@&resumableTotalSize=%@&resumableType=%@&resumableIdentifier=%@&resumableFilename=%@&resumableRelativePath=%@&resumableTotalChunks=%@",@(chunkToUpload.photo),
                          @(nowChunkNumber),
                          @(chunkToUpload.resumableChunkSize),
                          @(chunkToUpload.resumableCurrentChunkSize),
                          @(chunkToUpload.resumableTotalSize),
                          chunkToUpload.resumableType,
                          chunkToUpload.resumableIdentifier,
                          chunkToUpload.resumableFilename,
                          chunkToUpload.resumableFilename,
                          @(chunkToUpload.resumableTotalChunks)];
    
    paramStr = [paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    manager.requestSerializer=  [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    NSString* urlStr = [NSString stringWithFormat:@"http://10.122.251.224:9001/document/upload?%@",paramStr];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:chunkToUpload.chunkData
                                    name:@"files"
                                fileName:chunkToUpload.resumableFilename
                                mimeType:chunkToUpload.resumableType];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                     [weakSelf updateProgress:uploadProgress.completedUnitCount];
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      if (error) {
                          NSLog(@"error is %@\n\n\n\nresponseObject is %@",error.description,responseObject);
                      } else {
                          NSLog(@"responseObject is %@",responseObject);
                      }
                  }];
    
    [uploadTask resume];
    
    
}

*/

/*
 
 Error Domain=com.alamofire.error.serialization.response Code=-1011 "Request failed: internal server error (500)" UserInfo={com.alamofire.serialization.response.error.response=<NSHTTPURLResponse: 0x17002fa20> { URL: http://120.25.215.234:9001/document/upload } { status code: 500, headers {
 "Access-Control-Allow-Headers" = "Authorization, Content-Type";
 "Access-Control-Allow-Methods" = "POST, PUT, GET, OPTIONS, DELETE";
 "Access-Control-Allow-Origin" = "*";
 "Access-Control-Max-Age" = 3600;
 "Cache-Control" = "no-cache, no-store, max-age=0, must-revalidate";
 Connection = close;
 "Content-Type" = "application/json;charset=UTF-8";
 Date = "Wed, 09 Aug 2017 12:48:40 GMT";
 Expires = 0;
 Pragma = "no-cache";
 "Transfer-Encoding" = Identity;
 "X-Content-Type-Options" = nosniff;
 "X-Frame-Options" = DENY;
 "X-XSS-Protection" = "1; mode=block";
 } }, NSErrorFailingURLKey=http://120.25.215.234:9001/document/upload, com.alamofire.serialization.response.error.data

 
 */


@end
