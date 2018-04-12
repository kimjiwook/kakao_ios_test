//
//  MainTableViewCell.h
//  iOS_Kimjiwook
//
//  Created by JW_Macbook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

@protocol MainTableViewDelegate <NSObject>
@optional
/// 1. 이미지 다운로드 요청
- (void)downloadCellImage:(NSIndexPath *)indexPath;
@end

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) id<MainTableViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

/// 1. Cell 내용 셋팅하는 부분.
- (void)configuration:(ViewModel *)vm indexPath:(NSIndexPath *)indexPath;
@end
