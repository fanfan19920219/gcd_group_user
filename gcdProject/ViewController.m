//
//  ViewController.m
//  gcdProject
//
//  Created by M-SJ077 on 2017/2/13.
//  Copyright © 2017年 zhangzhihua. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"
#import "UIImageView+AFNetworking.h"
#define URL1 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1486982809520&di=1181028c8c22bf592f424eb916a4dcf4&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F4e4a20a4462309f71cd630317a0e0cf3d7cad65c.jpg"
#define URL2 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1486982809520&di=13eb719e2fcead2d596c59f774189aa7&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201407%2F13%2F20140713234126_yr2MV.jpeg"
#define URL3 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1486982809518&di=183352c581712d8608cdd084fd4f0b92&imgtype=0&src=http%3A%2F%2Fimg4q.duitang.com%2Fuploads%2Fitem%2F201505%2F07%2F20150507233334_XztRF.thumb.700_0.jpeg"
#define URL4 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1486982809514&di=70fa4889e136400a69af7be1549705e7&imgtype=0&src=http%3A%2F%2Fp2.image.hiapk.com%2Fuploads%2Fallimg%2F160520%2F7730-160520163337-52.jpg"



@interface ViewController (){
    NSArray *_imgArray;
    dispatch_group_t _group;
    UIScrollView *_showScrollview;
    NSMutableArray *_showimgArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    _group = dispatch_group_create();
    _imgArray = @[URL1,URL2,URL3,URL4];
    [self create_Views];
    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logButton.tag=1;
    logButton.bounds = CGRectMake(0, 0, self.view.frame.size.width/2, 100);
    logButton.center = CGPointMake(self.view.frame.size.width/4, self.view.frame.size.height - 50);
    [logButton setTitle:@"一边加载一边刷新" forState:UIControlStateNormal];
    logButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [logButton addTarget:self action:@selector(logGroup:) forControlEvents:UIControlEventTouchUpInside];
    [logButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:logButton];
    
    UIButton *logButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    logButton1.tag = 2;
    logButton1.bounds = CGRectMake(0, 0, self.view.frame.size.width/2, 100);
    logButton1.center = CGPointMake((self.view.frame.size.width/4)*3, self.view.frame.size.height - 50);
    [logButton1 setTitle:@"加载完成再刷新" forState:UIControlStateNormal];
    logButton1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [logButton1 addTarget:self action:@selector(logGroup:) forControlEvents:UIControlEventTouchUpInside];
    [logButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:logButton1];
    
    
}

-(void)create_Views{
    _showimgArray = [[NSMutableArray alloc]init];
    _showScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height - 100)];
    _showScrollview.pagingEnabled = YES;
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _showScrollview.frame.size.width/2 -1, _showScrollview.frame.size.height/2 -1)];
    imageView1.backgroundColor = [UIColor whiteColor];
    [_showScrollview addSubview:imageView1];
    [_showimgArray addObject:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_showScrollview.frame.size.width/2, 0, _showScrollview.frame.size.width/2 -1, _showScrollview.frame.size.height/2 -1)];
    imageView2.backgroundColor = [UIColor whiteColor];
    [_showScrollview addSubview:imageView2];
    [_showimgArray addObject:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _showScrollview.frame.size.height/2, _showScrollview.frame.size.width/2 -1, _showScrollview.frame.size.height/2 -1)];
    imageView3.backgroundColor = [UIColor whiteColor];
    [_showScrollview addSubview:imageView3];
    [_showimgArray addObject:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(_showScrollview.frame.size.width/2, _showScrollview.frame.size.height/2, _showScrollview.frame.size.width/2 -1, _showScrollview.frame.size.height/2 -1)];
    imageView4.backgroundColor = [UIColor whiteColor];
    [_showScrollview addSubview:imageView4];
    [_showimgArray addObject:imageView4];
    
    
    [self.view addSubview:_showScrollview];

}



-(void)logGroup:(UIButton*)sender{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //默认加载四张
    for(int i =0 ; i<4 ; i++){
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
        dispatch_group_enter(_group);
        dispatch_group_async(_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //利用nsdata数组 数据全部读取完成后加载
            if(sender.tag==2){
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgArray[i]]];
                [dataArray addObject:data];
            }else{
                //利用AFnetWorking进行及时进行加载
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *loadImageView = [_showimgArray objectAtIndex:i];
                    [loadImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imgArray objectAtIndex:i]]]];
                });
            }
            dispatch_group_leave(_group);
            dispatch_semaphore_signal(semaphore); // + 1
        });
    }
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        //加载完成
        
        //加载NSData
        if(sender.tag==2){
            int index = 0;
            for(NSData *data in dataArray){
                UIImageView *img = [_showimgArray objectAtIndex:index];
                img.image = [UIImage imageWithData:data];
                index++;
            }
            NSLog(@"加载完成刷新数据");
        }
    });
}




//分步代码
-(void)log{
    //多个网络请求/任务顺序执行结束之后，然后再执行操作。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //dispatch_queue_create("com.example.MyQueue", DISPATCH_QUEUE_SERIAL);
    // 1.
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
    dispatch_group_enter(_group);
    dispatch_group_async(_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
        [NSThread sleepForTimeInterval:2];
        dispatch_group_leave(_group);
        dispatch_semaphore_signal(semaphore); // + 1
    });
    
    // 2.
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_group);
    dispatch_group_async(_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2");
        [NSThread sleepForTimeInterval:2];
        dispatch_group_leave(_group);
        dispatch_semaphore_signal(semaphore);
    });
    
    // 3.
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_group);
    dispatch_group_async(_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"3");
        [NSThread sleepForTimeInterval:2];
        dispatch_group_leave(_group);
        dispatch_semaphore_signal(semaphore);
    });
    
    // 4.
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_group_enter(_group);
    dispatch_group_async(_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"4");
        [NSThread sleepForTimeInterval:2];
        dispatch_group_leave(_group);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        NSLog(@"结束");
    });
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    AFImageDownloader * lo = [UIImageView sharedImageDownloader];
    [lo.imageCache removeAllImages];
    
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
