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
    NSMutableDictionary *cache;
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
        // 메모리 : 10MB, 디스크 : 100MB
        NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * byte diskCapacity:100 * byte diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
        
        // 메모리 캐시 설정
        cache = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    
    return self;
}


/**
 Block 방식의 이미지 가지고 오는 부분.
 @param stringUrl 이미지 호출할 URL
 @param complete 완료시 UIImage 전달.
 */
- (void)loadFromUrl:(NSString *)stringUrl callback:(void (^)(UIImage *image))complete {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // NSURL 변환.
        NSURL *url = [NSURL URLWithString:stringUrl];
        
        UIImage *image = nil;
        if (url != nil) {
            NSString *key = [self md5:stringUrl];
            
            // 1. 메모리에서 먼저 검색
            UIImage *cachedImage = [self loadFromMemory:key];
            
            // 2. 메모리에 없을 경우 Document에서 검색
            if (cachedImage == nil) {
                cachedImage = [self getDocumentCache:key];
                
                // 값이 있다면 메모리에 저장.
                if (cachedImage != nil) {
                    [self saveToMemory:cachedImage withKey:key];
                }
            }
            
            // 3. 캐시된 이미지가 없을 경우 url에서 직접 가져옴
            if (cachedImage != nil) {
                image = cachedImage;
            } else {
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:imageData];
                
                // 메모리와 디스크 캐시에 추가
                [self saveToMemory:image withKey:key];
                [self setDocumentCache:image withKey:key];
            }
        }
        
        // #. 값이 없을때, 디폴트 이미지 전달해 준다.
        if (image == nil) {
            image = [UIImage imageNamed:@"noimage"];
        }
        
        // 마무리. 메인에서 전달해주기.
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(image);
        });
    });
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

#pragma mark- Document 관련.
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

#pragma mark- Memory 관련.
- (UIImage *)loadFromMemory:(NSString *)key {
    if (cache == nil) return nil;
    
    // Cache 에서 가져오기
    UIImage *cachedImage = [cache objectForKey:key];
    return cachedImage;
}

- (void)saveToMemory:(UIImage *)image withKey:(NSString *)key {
    if (cache == nil) {
        cache = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    
    // Cache 에 저장하기.
    [cache setObject:image forKey:key];
}

@end
