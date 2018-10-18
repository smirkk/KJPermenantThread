//
//  KJPermenantThread.h
//  KJPermenantThreadDemo
//
//  Created by kouhanjin on 2018/10/18.
//  Copyright © 2018年 khj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KJPermenantThreadTask)(void);

@interface KJPermenantThread : NSObject

/**
 开启线程
 */
- (void)run;

/**
 执行任务
 */
- (void)executeTask:(KJPermenantThreadTask)task;

/**
 停止线程
 */
- (void)stop;
@end
