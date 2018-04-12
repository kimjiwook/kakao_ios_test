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

//
- (void)setDocumentImageUrl:(NSString *)stringUrl image:(UIImage *)image;
- (UIImage *)getDocumentImageUrl:(NSString *)stringUrl;
@end
