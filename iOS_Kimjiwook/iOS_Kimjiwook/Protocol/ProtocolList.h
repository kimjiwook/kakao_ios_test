//
//  ProtocolList.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolList : NSObject
/// 1. 최초 HTML Parsing을 통하여 리스트 구해오기.
- (void)getImageArray:(void (^)(id ob))complet :(void (^)(NSError *error))fail;
@end
