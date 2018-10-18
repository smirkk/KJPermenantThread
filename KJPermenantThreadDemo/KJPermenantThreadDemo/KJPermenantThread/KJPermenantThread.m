//
//  KJPermenantThread.m
//  KJPermenantThreadDemo
//
//  Created by kouhanjin on 2018/10/18.
//  Copyright © 2018年 khj. All rights reserved.
//

#import "KJPermenantThread.h"

@interface KJThread : NSThread
@end

@implementation KJThread
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end

@interface KJPermenantThread()
@property (nonatomic, strong) KJThread *innerThread;
@property (nonatomic, assign, getter = isStopped) BOOL stopped;
@end

@implementation KJPermenantThread
#pragma mark - public methods

- (instancetype)init{
    if (self = [super init]) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        // 初始化子线程
        self.innerThread = [[KJThread alloc] initWithBlock:^{
            
            // 开启runLoop，前提条件是Mode里没有任何Source0/Source1/Timer/Observer，RunLoop会立马退出
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            // 常驻线程
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}


- (void)run{
    
    if (!self.innerThread) return;
    // 开启线程
    [self.innerThread start];
}

- (void)executeTask:(KJPermenantThreadTask)task{
    
    if (!self.innerThread || !task) return;
    // 执行任务, waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop{
    if (!self.innerThread) return;
    // 停止线程
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc{
    [self stop];
}
#pragma mark - private methods

- (void)__stop{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(KJPermenantThreadTask)task{
    task();
}

#pragma mark - c语言启动runloop
- (void)__CRunLoop{
    
    CFRunLoopSourceContext context = {0};
    // 创建source
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 往Runloop中添加source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    // 启动
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
//    while (weakSelf && !weakSelf.isStopped) {
        // returnAfterSourceHandled设置为true，代表执行完source后就会退出当前loop,如果设置成false，就相当于while循环
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
//    }
}
@end
