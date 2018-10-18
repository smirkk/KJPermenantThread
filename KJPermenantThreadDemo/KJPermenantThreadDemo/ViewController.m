//
//  ViewController.m
//  KJPermenantThreadDemo
//
//  Created by kouhanjin on 2018/10/18.
//  Copyright © 2018年 khj. All rights reserved.
//

#import "ViewController.h"
#import "KJPermenantThread.h"

@interface ViewController ()
@property (strong, nonatomic) KJPermenantThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[KJPermenantThread alloc] init];
    [self.thread run];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}

- (IBAction)stop {
    [self.thread stop];
}


- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end
