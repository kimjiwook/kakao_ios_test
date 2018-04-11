//
//  ViewModel.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject
@property (nonatomic, strong) NSString *detailURL; // 1. 상세정보 URL (호출후 Parser 진행해야함.)
@property (nonatomic, strong) NSString *thumImageURL; // 2. 썸네일 이미지 URL
@property (nonatomic, strong) NSString *caption; // 3. 해당 이미지의 설명글

@property (nonatomic, strong) UIImage *thumImage; // 2-1. 이미지 부분.
@end
