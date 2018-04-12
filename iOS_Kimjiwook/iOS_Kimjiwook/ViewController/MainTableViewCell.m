//
//  MainTableViewCell.m
//  iOS_Kimjiwook
//
//  Created by JW_Macbook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell() {
    AFHTTPSessionManager *manager;
}
@end


@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 네트워크 생성.
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 Cell 꾸며주는 부분

 @param vm
 @param indexPath
 */
- (void)configuration:(ViewModel *)vm indexPath:(NSIndexPath *)indexPath {
    // 만약에 데이터를 받고있는게 있다면 취소해준다.
    [_imgView.associatedObject cancel];
    
    // Cell 꾸미기.
    _lbTitle.text = vm.caption;
    
    // 다운로드 이미지 부분.
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,vm.thumImageURL];
    _imgView.image = [UIImage imageNamed:@"noimage"]; // 디폴트 이미지
    // 메모리 캐시 영역.
    if (vm.thumImage) {
        _imgView.image = vm.thumImage;
        [[ImageCache instance] setCached:imageUrl image:vm.thumImage]; // 도큐멘트 저장.
    } else {
        // 도큐멘트 영역.
        UIImage *documentCachedImage = [[ImageCache instance] getDocumentImageUrl:imageUrl];
        if (documentCachedImage) {
            _imgView.image = documentCachedImage;
            vm.thumImage = documentCachedImage; // 메모리 저장.
        } else {
            // 다운로드 로직.
            _imgView.associatedObject =
            [manager GET:imageUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%ld 이미지 다운로드",indexPath.row);
                self->_imgView.image = [UIImage imageWithData:(NSData *)responseObject];
                // 메모리, 도큐멘트 저장 로직.
                vm.thumImage = self->_imgView.image;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                dispatch_async(queue, ^{
                    [[ImageCache instance] setCached:imageUrl image:vm.thumImage];
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%ld, %@",indexPath.row, error);
            }];
        }
    }
}

@end
