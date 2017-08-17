//
//  ViewController.m
//  BreakpointResume
//
//  Created by 张浩 on 2017/7/26.
//  Copyright © 2017年 hzbt. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"
#import "fileTableViewCell.h"
#import "CNFile.h"
#import "ZHChunk.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger nowChunks;
    NSArray* uploadFiles;
}
@property(nonatomic,weak) IBOutlet UITableView* tableView;

@property(nonatomic,strong) NSURLSessionDownloadTask* downloadTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[fileTableViewCell class] forCellReuseIdentifier:@"fileTableViewCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight   = 100;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    uploadFiles = [CNFile getInboxFile];
    
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return uploadFiles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    fileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"fileTableViewCell"];
    
    if (cell==nil) {
        cell = [[fileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileTableViewCell"];
    }
    CNFile* fileModel = uploadFiles[indexPath.row];
    cell.fileModel  = fileModel;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    点击上传
    
    
}

//下一步就是上传的过程：

-(void)uploadData:(NSData*) data WithChunk:(NSInteger) chunk file:(CNFile*)file{
    
    //在服务器返回该片上传成功后，我们要做的事有很多：
    
    //1）先将已经成功上传的本片的flag置finish
    
    //2）查看是否所有片的flag都已经置finish，如果都已经finishi，说明该文件上传完成，那么删除该文件，上传下一个文件或者结束。
    
//    for (NSInteger j = 0; j<nowChunks; j++){
//        
//        if (j == nowChunks || ((j == nowChunks - 1)&&([file.fileArr[j] isEqualToString:@"finish"])))
//            
//            [me deleteFile:file.filePath];
//        
//        [me readNextFile];
    
}






#pragma mark 普通下载

-(void)loadAction{
    //远程地址
    NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak ViewController* weakSelf = self;
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
//            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
//        weakSelf.backGroudView.image = img;
        
    }];
    
    [_downloadTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
