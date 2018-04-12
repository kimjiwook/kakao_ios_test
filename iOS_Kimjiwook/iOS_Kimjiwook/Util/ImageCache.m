//
//  ImageCache.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "ImageCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface ImageCache() {
//    NSMutableDictionary *cache;
}

@end

@implementation ImageCache


/**
 싱글턴을 이용한 객체 생성.
 @return self
 */
+ (ImageCache *)instance {
    static ImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    
    if (imageCache == nil) {
        // 최초 한번만 실행했는지 판단.
        dispatch_once(&onceToken, ^{
            imageCache = [[ImageCache alloc] init];
        });
    }
    return imageCache;
}

- (id)init {
    self = [super init];
    
    if (self) {
        // url 캐시 설정
        NSInteger byte = 1024 * 1024;
        // 메모리 : 10MB, 디스크 : 100MB (메모리 캐쉬는 ViewModel 에서 따로 할 예정)
        NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * byte diskCapacity:100 * byte diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
    }
    
    return self;
}

#pragma mark- Document 관련.

/**
 로컬에 저장되어 있는 이미지 파일가져오기.

 @param stringUrl 이미지 URL
 @return UIImage
 */
- (UIImage *)getDocumentImageUrl:(NSString *)stringUrl {
    // NSURL 변환.
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    UIImage *image = nil;
    if (url != nil) {
        NSString *key = [self md5:stringUrl];
        UIImage *cachedImage = [self getDocumentCache:key];
        
        if (cachedImage != nil) {
            image = cachedImage;
        }
    }
    return image;
}

/**
 로컬에 저장한다.
 @param stringUrl 이미지 URL
 @param image UIImage
 */
- (void)setDocumentImageUrl:(NSString *)stringUrl image:(UIImage *)image {
    NSString *key = [self md5:stringUrl];
    // 디스크 캐시에 추가
    [self setDocumentCache:image withKey:key];
}

- (UIImage *)getDocumentCache:(NSString *)key {
    // 경로 추출.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docPath, key];
    
    // 불러오기.
    return [[UIImage alloc] initWithContentsOfFile:path];
}

- (void)setDocumentCache:(UIImage *)image withKey:(NSString *)key {
    // 경로 추출.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docPath, key];

    // 저장
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}

#pragma mark- MD5를 통한 URL 변환.
// url을 사용해서 md5 해시 문자열 생성
-(NSString*)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02X",result[i]];
    return string;
}

@end
