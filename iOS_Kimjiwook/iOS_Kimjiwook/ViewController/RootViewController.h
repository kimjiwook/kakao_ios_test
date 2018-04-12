//
//  RootViewController.h
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 12..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolList.h"

@interface RootViewController : UIViewController
@property (strong, nonatomic) LOTAnimationView *lotAnimationView;
@property (strong, nonatomic) ProtocolList *protocolList;

/// 로딩뷰 시작 / 종료
- (void)startLodingView;
- (void)stopLodingView;
/// AutoLayout 잡을 용도.
- (void)addConstraintZero:(UIView *)view toView:(UIView *)toView;
@end
