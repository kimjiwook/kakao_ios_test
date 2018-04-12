//
//  DetailViewController.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 12..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface DetailViewController : RootViewController
@property (nonatomic, strong) NSString *navigationTitle; // 타이틀 정보.
@property (nonatomic, strong) NSString *detailUrl; // 상세Url 정보.
@end
