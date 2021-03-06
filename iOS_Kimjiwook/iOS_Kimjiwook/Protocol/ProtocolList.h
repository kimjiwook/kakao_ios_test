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
- (void)getImageArray:(void (^)(id ob))complete :(void (^)(NSError *error))fail;
/// 2. 상세화면 진입시 HTML Parsing을 통해 데이터 가져오기.
- (void)getDetailVM:(NSString *)stringUrl :(void (^)(id ob))complete :(void (^)(NSError *error))fail;
@end
