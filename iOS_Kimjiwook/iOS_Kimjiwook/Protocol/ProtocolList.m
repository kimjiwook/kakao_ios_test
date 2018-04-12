//
//  ProtocolList.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "ProtocolList.h"
#import "ViewModel.h"

@implementation ProtocolList

/**
 HTML 분석하기. 최초
 */
- (void)getImageArray:(void (^)(id ob))complete :(void (^)(NSError *error))fail {
    // URL 정보.
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,BASE_URL_GET_PARAM];
    
    // 네트워크 통신 준비.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // HTML Parser
        HTMLDocument *doc = [HTMLDocument documentWithString:html];
        NSArray *elements = [doc nodesMatchingSelector:@"div"];
    
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        for (HTMLElement *element in elements) {
            if ([[element attributes] objectForKey:@"class"]) {
                // 전체 가져오는 부분 (리스트 갯수가 맞음.)
                NSString *class = [[element attributes] objectForKey:@"class"];
                // 두가지 타입의 id를 가지고 있는 아이들을 리스트로 뺀다.
                if ([class isEqualToString:@"gallery-item-group lastitemrepeater"] ||
                    [class isEqualToString:@"gallery-item-group exitemrepeater"]) {

                    // 객체 생성.
                    ViewModel *vm = [[ViewModel alloc] init];
                    
                    // 내부를 반복 돌려 확인하기.
                    for (HTMLElement *childElement in [element childElementNodes]) {
                        
                        // 1. 상세 URL
                        if ([@"" isEqualToString:vm.detailURL]) {
                            vm.detailURL = [[childElement attributes] objectForKey:@"href"];
                        }
                        
                        // 2. 썸네일 이미지, 설명글
                        for (HTMLElement *srcElement in [childElement childElementNodes]) {
                            if ([@"" isEqualToString:vm.thumImageURL]) {
                                vm.thumImageURL = [[srcElement attributes] objectForKey:@"src"];
                                break;
                            }
                        }
                    }
                    
                    // 3. 설명글 (앞,뒤 공백만 제거)
                    if ([@"" isEqualToString:vm.caption]) {
                        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                        vm.caption = [element.textContent stringByTrimmingCharactersInSet:whitespace];
                    }
                    
                    [listArray addObject:vm];
                }
            }
        }
        // 완료.
        complete(listArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 에러
        fail(error);
    }];
}


/**
 상세화면 HTML 파싱 후 데이터 진행.

 @param stringUrl
 @param complete
 @param fail
 */
- (void)getDetailVM:(NSString *)stringUrl :(void (^)(id ob))complete :(void (^)(NSError *error))fail {
    // 네트워크 통신 준비.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:stringUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // HTML Parser
        HTMLDocument *doc = [HTMLDocument documentWithString:html];
        NSArray *elements = [doc nodesMatchingSelector:@"div"];
        // ViewModel 객체 생성.
        DetailViewModel *vm = [[DetailViewModel alloc] init];
        
        for (HTMLElement *element in elements) {
            if ([[element attributes] objectForKey:@"class"]) {
                
                NSString *class = [[element attributes] objectForKey:@"class"];
                // 두가지 타입의 id를 가지고 있는 아이들을 리스트로 뺀다.
                if ([class isEqualToString:@"innerImageArea"] ||
                    [class isEqualToString:@"proddetails"]) {
                    
                    NSLog(@"");
                    // 내부를 반복 돌려 확인하기.
                    for (HTMLElement *childElement in [element childElementNodes]) {
                        // 1. 상세 이미지 URL
                        if ([@"" isEqualToString:vm.imageURL]) {
                            vm.imageURL = [[childElement attributes] objectForKey:@"src"];
                        }
                        
                        // 상세 정보. P 태그정보만 가져온다.
                        if ([@"p" isEqualToString:childElement.tagName]) {
                            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                            NSString *content = [childElement.textContent stringByTrimmingCharactersInSet:whitespace];
                            // 컨텐츠 내용들 받아주기.
                            if (![@"" isEqualToString:content]) {
                                vm.caption = [NSString stringWithFormat:@"%@\n%@",vm.caption,content];
                            }
                        }
                    }
                }
            }
        }

        complete(vm);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}
@end
