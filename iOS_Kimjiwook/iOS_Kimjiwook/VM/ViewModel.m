//
//  ViewModel.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "ViewModel.h"

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

- (id)copyWithZone:(NSZone *)zone {
    ViewModel *vm = [[self class] allocWithZone:zone];
    vm->_detailURL = self->_detailURL;
    vm->_thumImageURL = self->_thumImageURL;
    vm->_caption = self->_caption;
    vm->_thumImage = self->_thumImage;
    return vm;
}
@end
