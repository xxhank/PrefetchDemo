//
//  Logger.h
//  Le123PhoneClient
//
//  Created by wangchao9 on 2017/5/5.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

// *INDENT-OFF*
#if __has_include(<Crashlytics/Crashlytics.h>)
// *INDENT-ON*
#import <Crashlytics/Crashlytics.h>
#endif // if __has_include(< Crashlytics / Crashlytics.h >)

// *INDENT-OFF*
#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
// *INDENT-ON*
#import <CocoaLumberjack/CocoaLumberjack.h>

#define LOG_COLOR(R,G,B) [UIColor colorWithRed: (R / 255.0) green: (G / 255.0) blue: (B / 255.0) alpha: 1.0]

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose; //LOG_LEVEL_VERBOSE;
#else /* if DEBUG */
static const int ddLogLevel = DDLogLevelInfo; //LOG_LEVEL_INFO;
#endif /* if DEBUG */

#ifdef DEBUG
// *INDENT-OFF*
#if __has_include(<LumberjackConsole/PTEDashboard.h>)
#import <LumberjackConsole/PTEDashboard.h>
// *INDENT-ON*
#define NSLogDash() [PTEDashboard.sharedDashboard show]
#endif // ifdef DEBUG
#else
#define NSLogDash()
#endif
void NSLogSetup();
#define NSLogInit() \
    NSLogSetup(); \
    NSLogDash();

// *INDENT-OFF*
#if !DEBUG && __has_include(<Crashlytics/Crashlytics.h>)
// *INDENT-ON*
#define NSLogInfo(__FORMAT__, ...)  do {DDLogInfo(__FORMAT__,##__VA_ARGS__);CLS_LOG(__FORMAT__,##__VA_ARGS__);} while (0)
#define NSLogWarn(__FORMAT__, ...)  do {DDLogWarn(__FORMAT__,##__VA_ARGS__);CLS_LOG(__FORMAT__,##__VA_ARGS__);} while (0)
#define NSLogError(__FORMAT__, ...) do {DDLogError(__FORMAT__,##__VA_ARGS__);CLS_LOG(__FORMAT__,##__VA_ARGS__);} while (0)
#else
#define NSLogInfo(__FORMAT__, ...)  do {DDLogInfo(__FORMAT__,##__VA_ARGS__);} while (0)
#define NSLogWarn(__FORMAT__, ...)  do {DDLogWarn(__FORMAT__,##__VA_ARGS__);} while (0)
#define NSLogError(__FORMAT__, ...) do {DDLogError(__FORMAT__,##__VA_ARGS__);} while (0)
#endif

#define NSLogCInfo  DDLogCInfo
#define NSLogCWarn  DDLogCWarn
#define NSLogCError DDLogCError

#ifdef NSLog
#undef NSLog
#endif // ifdef NSLog

@interface SARRSLogCustomFormatter : NSObject <DDLogFormatter> {
    int              atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end


#else // if __has_include(<CocoaLumberjack / DDLog.h>)
/// LOG
#ifndef __FILENAME__
#define __FILENAME__ ({(strrchr(__FILE__, '/')?:(__FILE__ - 1)) + 1;})
#endif // ifndef __FILENAME__

/// LOG
#define XCODE_COLORS_FG(color) @"\033[fg" color @";"
#define XCODE_COLORS_END       @"\033[;"

#define NSLogBase(color, level, fmt, ...) do {NSLog(XCODE_COLORS_FG(color) level " %s:%d %s> " fmt XCODE_COLORS_END, __FILENAME__, __LINE__, __FUNCTION__,##__VA_ARGS__);} while (0)

#define NSLogSetup() do {} while (0)

// *INDENT-OFF*
#if __has_include(<Crashlytics/Crashlytics.h>)
// *INDENT-ON*
#define NSLogInfo(fmt, ...)  do {NSLogBase(@"187,187,187",@"Info", fmt,##__VA_ARGS__);CLS_LOG(fmt,##__VA_ARGS__);} while (0)
#define NSLogWarn(fmt, ...)  do {NSLogBase(@"255,255,0",@"Warning", fmt,##__VA_ARGS__);CLS_LOG(fmt,##__VA_ARGS__);} while (0)
#define NSLogError(fmt, ...) do {NSLogBase(@"255,0,0",@"Error", fmt,##__VA_ARGS__);CLS_LOG(fmt,##__VA_ARGS__);} while (0)
#else
#define NSLogInfo(fmt, ...)  NSLogBase(@"187,187,187",@"Info", fmt,##__VA_ARGS__)
#define NSLogWarn(fmt, ...)  NSLogBase(@"255,255,0",@"Warning", fmt,##__VA_ARGS__)
#define NSLogError(fmt, ...) NSLogBase(@"255,0,0",@"Error", fmt,##__VA_ARGS__)
#endif



#define NSLogCInfo  NSLogInfo
#define NSLogCWarn  NSLogWarn
#define NSLogCError NSLogError
#endif // if __has_include(<CocoaLumberjack / DDLog.h>)

#define DQLogDebug NSLogInfo
#define DQLogInfo  NSLogInfo
#define DQLogWarn  NSLogWarn
#define DQLogError NSLogError

#define DQLogDownload DQLogDebug
#define DQLog         NSLogInfo

#define NSLogErrorObject(error) \
    if (error) { \
        NSLogError(@"%@", error); \
    } else { \
        NSLogError(@"unknown error"); \
    }
