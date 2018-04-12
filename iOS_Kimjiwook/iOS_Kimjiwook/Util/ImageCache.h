//
//  ImageCache.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject
// 싱글턴 객체 생성.
+ (ImageCache *)instance;

// 이미지 가져오기. (메모리 > 로컬 > 다운로드) 순서임.
- (void)loadFromUrl:(NSString *)stringUrl callback:(void (^)(UIImage *image))complete;
// 캐쉬에 이미지 있는지 확인하기.
- (UIImage *)getImageUrl:(NSString *)stringUrl;
// 로컬과 메모리에 캐쉬남기는 기능.
- (void)setCached:(NSString *)stringUrl image:(UIImage *)image;
- (UIImage *)getDocumentImageUrl:(NSString *)stringUrl;
@end
