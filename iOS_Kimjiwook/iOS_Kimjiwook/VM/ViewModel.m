//
//  ViewModel.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "ViewModel.h"

/// 1. 메인.
@implementation ViewModel
- (id)init {
    self = [super init];
    if (self) {
        _detailURL = @"";
        _thumImageURL = @"";
        _caption = @"";
        _thumImage = nil;
    }
    return self;
}

@end

/// 2. 상세
@implementation DetailViewModel
- (id)init {
    self = [super init];
    if (self) {
        _imageURL = @"";
        _caption = @"";
        _detailImage = nil;
    }
    return self;
}
@end
