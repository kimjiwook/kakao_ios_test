//
//  ViewModel.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 1. 메인 리스트. VM
@interface ViewModel : NSObject
@property (nonatomic, strong) NSString *detailURL; // 1. 상세정보 URL (호출후 Parser 진행해야함.)
@property (nonatomic, strong) NSString *thumImageURL; // 2. 썸네일 이미지 URL
@property (nonatomic, strong) NSString *caption; // 3. 해당 이미지의 설명글

@property (nonatomic, strong) UIImage *thumImage; // 2-1. 이미지 부분.
@end

/// 2. 상세화면. VM
@interface DetailViewModel : NSObject
@property (nonatomic, strong) NSString *imageURL; // 1. 상세 이미지 URL
@property (nonatomic, strong) NSString *caption; // 2. 설명글

@property (nonatomic, strong) UIImage *detailImage; // 1-1. 이미지 영역.
@end
