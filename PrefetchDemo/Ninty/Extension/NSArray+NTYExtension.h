//
//  NSArray+NTYExtension.h
//  SARRS
//
//  Created by wangchao9 on 2017/6/27.
//  Copyright © 2017年 Beijing Ninety Culture Co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType>(Operations)
/**
 *  将数组映射为另外一个数组
 *
 *  @param block 映射函数 <br/>
 *         The block takes two arguments:

    obj The element in the array.

    idx The index of the element in the array.

    @return 映射后的数组
 */
- (NSMutableArray*)nty_map:(id (^)(ObjectType obj, NSUInteger idx))block;

- (NSMutableArray*)nty_filter:(BOOL (^)(ObjectType obj, NSUInteger idx))block;

/**
 *  用seperator把数组内容连接成一个字符串
 *
 *  @param seperator 分割符
 *
 *  @return 连接好的字符串
 */
- (NSString*)nty_joinedString:(NSString*)seperator;

- (void)nty_each:(void (^)(ObjectType item, NSUInteger index))block;
- (void)nty_each:(NSArray<NSNumber*>*)indexes executor:(void (^)(ObjectType item, NSUInteger index))block;

- (void)nty_foreach:(void (^)(id item, NSUInteger index, BOOL*stop))block;

/**
 *  把数组简化成一个对象
 *
 *  @param initial 初始值
 *  @param block 计算代码
 *
 *  @return 简化后的结果
 *  @code
 *  NSArray<NSString*>*names = @[@"ab", @"bc", @"cdx"];
 *  NSUInteger characters = [[names nty_reduce:@"0" executor:^id (NSString *item, NSUInteger index, id prev) {
 *      return @([prev unsignedIntegerValue] + [item length]);
 *  }] unsignedIntegerValue];
 *  @endcode
 */
- (id)nty_reduce:(id)initial executor:(id (^)(ObjectType item, NSUInteger index, id prev))block;

- (NSMutableArray*)nty_joined:(NSArray*)array;

- (id)nty_firstObjectPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL*stop))predicate;
@end

@interface NSArrayOperations <InputType, OutputType> : NSObject
+ (NSMutableArray<OutputType>*)map:(NSArray<InputType>*)input with:(OutputType (^)(InputType item, NSUInteger index))block;
@end
