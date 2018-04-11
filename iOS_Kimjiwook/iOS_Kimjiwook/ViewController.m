//
//  ViewController.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "ViewController.h"

#import "ProtocolList.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getImageList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 HTML 분석하기.
 */
- (void)getImageList {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,BASE_URL_GET_PARAM];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // Progress 사용안함.
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"확인중.");
        NSLog(@"%@",responseObject);
        NSData *data = (NSData *)responseObject;
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"확인중. \n %@",html);
        
        // HTML Parser
        HTMLDocument *doc = [HTMLDocument documentWithString:html];
        NSArray *elemnts = [doc nodesMatchingSelector:@"div"];
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        for (HTMLElement *elemt in elemnts) {
            if ([[elemt attributes] objectForKey:@"class"]) {
                NSString *class = [[elemt attributes] objectForKey:@"class"];
                // 두가지 타입의 id를 가지고 있는 아이들을 리스트로 뺀다.
                if ([class isEqualToString:@"gallery-item-group lastitemrepeater"] ||
                    [class isEqualToString:@"gallery-item-group exitemrepeater"]) {
                    [listArray addObject:elemt];
                }
            }
        }
        
        NSLog(@"%ld",listArray.count);
        // 1차 데이터 가져오는 로직 완료. (갯수임.)
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


@end
