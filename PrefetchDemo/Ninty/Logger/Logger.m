//
//  Logger.m
//  Le123PhoneClient
//
//  Created by wangchao9 on 2017/5/5.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import "Logger.h"
#import <libkern/OSAtomic.h>
// *INDENT-OFF*
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
// *INDENT-ON*


void NSLogSetup() {
    DDTTYLogger*tty = [DDTTYLogger sharedInstance];
    [tty setForegroundColor:LOG_COLOR(187,187,187) backgroundColor:nil forFlag:DDLogFlagInfo];
    [tty setForegroundColor:LOG_COLOR(255,155,0) backgroundColor:nil forFlag:DDLogFlagWarning];
    [tty setForegroundColor:LOG_COLOR(255,0,0) backgroundColor:nil forFlag:DDLogFlagError];
    [tty setLogFormatter:[SARRSLogCustomFormatter new]];
    [tty setColorsEnabled:YES];

    [DDLog addLogger:tty];

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency                       = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    [DDLog addLogger:fileLogger];

    [DDLog addLogger:[DDASLLogger sharedInstance]];
}

@implementation SARRSLogCustomFormatter
+ (NSDateFormatter*)dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter*formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    });

    return formatter;
}

- (NSString*)formatLogMessage:(DDLogMessage*)message {
    NSString*threadName = nil;
    if ([NSThread isMainThread]) {
        threadName = @"main";
    } else {
        if (message->_threadName.length > 0) {
            threadName = message->_threadName;
        } else if (message->_queueLabel) {
            threadName = message->_queueLabel;
        } else {
            threadName = [NSString stringWithFormat:@"0x%p", [NSThread currentThread]];
        }
    }

    threadName = [threadName stringByReplacingOccurrencesOfString:@"com.apple.main-thread" withString:@"main"];

    return [NSString stringWithFormat:@"%@ %.2f %@:%lu %@> %@",
            threadName,
            [message->_timestamp timeIntervalSince1970] * 1000,
            [message->_file lastPathComponent],
            (unsigned long)message->_line,
            message->_function,
            message->_message];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end
#endif
