//
//  NSObject+Associating.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 12..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Associating)
/// 셀 이미지 작업시 이미지를 덮어쓰는 경우가 발생을 방지하기 위해 작업을 대기함.
@property (nonatomic, retain) id associatedObject;
@end
