//
//  StarViewController.m
//  gcdProject
//
//  Created by M-SJ077 on 2017/2/13.
//  Copyright © 2017年 zhangzhihua. All rights reserved.
//

#import "StarViewController.h"
#import "ViewController.h"

@interface StarViewController ()

@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.bounds = CGRectMake(0, 0, 100, 20);
    pushButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [pushButton addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [pushButton setTitle:@"push" forState:UIControlStateNormal];
    [pushButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:pushButton];
    
    // Do any additional setup after loading the view.
}

-(void)push{
    ViewController *VC = [[ViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
