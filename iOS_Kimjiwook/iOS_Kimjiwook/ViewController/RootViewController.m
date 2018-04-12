//
//  RootViewController.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 12..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 로딩뷰 시작.
 */
- (void)startLodingView {
    if (!self.lotAnimationView) {
        self.lotAnimationView = [LOTAnimationView animationNamed:@"loding1"];
    }
    [self.view addSubview:self.lotAnimationView];
    [self addConstraintZero:self.lotAnimationView toView:self.view];
    [self.lotAnimationView play];
}


/**
 로딩뷰 종료.
 */
- (void)stopLodingView {
    [self.lotAnimationView stop];
    [self.lotAnimationView removeFromSuperview];
}

/**
 *  AutoLayout 위,아래,왼쪽,오른쪽이 (0)인 경우!!!
 *
 *  @param view   적용할 View
 *  @param toView 부모 View
 */
- (void)addConstraintZero:(UIView *)view toView:(UIView *)toView {
    [self addConstraint:view toView:toView topConstraint:@(0) topIdentifier:nil bottomConstraint:@(0) bottomIdentifier:nil leadingConstraint:@(0) leadingIdentifier:nil trailingConstraint:@(0) trailingIdentifier:nil widthConstraint:nil widthIdentifier:nil heightConstraint:nil heightIdentifier:nil centerXConstraint:nil centerXIdentifier:nil centerYConstraint:nil centerYIdentifier:nil];
}

//Autolayout 설정
- (void)addConstraint:(UIView *)view toView:(UIView *)toView
        topConstraint:(NSNumber *)topConstraint topIdentifier:(NSString *)topIdentifier
     bottomConstraint:(NSNumber *)bottomConstraint bottomIdentifier:(NSString *)bottomIdentifier
    leadingConstraint:(NSNumber *)leadingConstraint leadingIdentifier:(NSString *)leadingIdentifier
   trailingConstraint:(NSNumber *)trailingConstraint trailingIdentifier:(NSString *)trailingIdentifier
      widthConstraint:(NSNumber *)widthConstraint widthIdentifier:(NSString *)widthIdentifier
     heightConstraint:(NSNumber *)heightConstraint heightIdentifier:(NSString *)heightIdentifier
    centerXConstraint:(NSNumber *)centerXConstraint centerXIdentifier:(NSString *)centerXIdentifier
    centerYConstraint:(NSNumber *)centerYConstraint centerYIdentifier:(NSString *)centerYIdentifier
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (topConstraint) {
        if(toView && toView) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:toView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f
                                                                           constant:[topConstraint floatValue]];
            if (topIdentifier && ![@"" isEqualToString:topIdentifier]) {
                constraint.identifier = topIdentifier;
            }
            
            [toView addConstraint:constraint];
        }
    }
    
    if (bottomConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:toView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f
                                                                       constant:[bottomConstraint floatValue]];
        if (bottomIdentifier && ![@"" isEqualToString:bottomIdentifier]) {
            constraint.identifier = bottomIdentifier;
        }
        
        [toView addConstraint:constraint];
    }
    
    if (leadingConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:toView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0f
                                                                       constant:[leadingConstraint floatValue]];
        if (leadingIdentifier && ![@"" isEqualToString:leadingIdentifier]) {
            constraint.identifier = leadingIdentifier;
        }
        
        [toView addConstraint:constraint];
    }
    
    if (trailingConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeTrailing
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:toView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0f
                                                                       constant:[trailingConstraint floatValue]];
        if (trailingIdentifier && ![@"" isEqualToString:trailingIdentifier]) {
            constraint.identifier = trailingIdentifier;
        }
        
        [toView addConstraint:constraint];
    }
    
    if (widthConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:[widthConstraint floatValue]];
        if (widthIdentifier && ![@"" isEqualToString:widthIdentifier]) {
            constraint.identifier = widthIdentifier;
        }
        
        [view addConstraint:constraint];
    }
    
    if (heightConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:[heightConstraint floatValue]];
        if (heightIdentifier && ![@"" isEqualToString:heightIdentifier]) {
            constraint.identifier = heightIdentifier;
        }
        
        [view addConstraint:constraint];
    }
    
    if (centerXConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:toView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0f
                                                                       constant:[centerXConstraint floatValue]];
        if (centerXIdentifier && ![@"" isEqualToString:centerXIdentifier]) {
            constraint.identifier = centerXIdentifier;
        }
        
        [toView addConstraint:constraint];
    }
    
    if (centerYConstraint) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:toView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0f
                                                                       constant:[centerYConstraint floatValue]];
        if (centerYIdentifier && ![@"" isEqualToString:centerYIdentifier]) {
            constraint.identifier = centerYIdentifier;
        }
        
        [toView addConstraint:constraint];
    }
    
}

@end
