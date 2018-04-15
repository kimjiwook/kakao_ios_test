//
//  DetailViewController.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 12..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewModel.h"

@interface DetailViewController () {
    DetailViewModel *detailVM;
    AFHTTPSessionManager *manager;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView; // 메인 이미지.
@property (weak, nonatomic) IBOutlet UILabel *lbCaption; // 설명글.
@end

@implementation DetailViewController

#pragma mark - #. 기본적인 사항들.

/**
 초기화와 기본적인 셋팅을 맞는 부분.
 */
- (void)initData {
    self.protocolList = [[ProtocolList alloc] init];
    // 네트워크 생성.
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self setNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self requestHTML];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 네비게이션 정보.
 */
- (void)setNavigation {
    self.title = @"iOS_김지욱";
    if (_navigationTitle) {
        self.title = _navigationTitle;
    }
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.31 green:0.25 blue:0.21 alpha:1.0f]];
}

/**
 HTML ParserData 호출 후 뿌려주는 부분.
 */
- (void)requestHTML {
    [self startLodingView];
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, _detailUrl];
    [self.protocolList getDetailVM:stringUrl :^(id ob) {
        self->detailVM = (DetailViewModel *)ob;
        [self reloadDetailData];
    } :^(NSError *error) {
        NSLog(@"error : %@",error);
        [self stopLodingView];
    }];
}

- (void)reloadDetailData {
    if (!detailVM) {
        [self stopLodingView];
        return;
    }
    
    // 1. 이미지 영역 부분.
    if (detailVM.detailImage) {
        self.imageView.image = detailVM.detailImage;
        [self stopLodingView];
    } else {
        NSString *stringUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, _detailUrl];
        UIImage *documentCachedImage = [[ImageCache instance] getDocumentImageUrl:stringUrl];
        if (documentCachedImage) {
            self.imageView.image = documentCachedImage;
            detailVM.detailImage = documentCachedImage; // 메모리 저장.
            [self stopLodingView];
        } else {
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,detailVM.imageURL];
            [manager GET:imageUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.imageView.image = [UIImage imageWithData:(NSData *)responseObject];
                // #. 메모리, 도큐멘트 저장 로직.
                self->detailVM.detailImage = self.imageView.image;
                [[ImageCache instance] setDocumentImageUrl:imageUrl image:self->detailVM.detailImage];
                [self stopLodingView];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self stopLodingView];
                NSLog(@"%@",error);
            }];
        }
    }
    
    // 2. 설명 글 부분.
    self.lbCaption.text = detailVM.caption;
}
@end
