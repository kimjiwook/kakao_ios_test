//
//  MainViewController.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "MainViewController.h"
#import "ProtocolList.h"
#import "ViewModel.h"

#import "MainTableViewCell.h"

@interface MainViewController () {
    NSMutableArray *dataList;
    ProtocolList *protocolList;
}

/// 메인으로 사용되는 테이블 뷰.
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - #. 기본적인 사항들.

/**
 초기화와 기본적인 셋팅을 맞는 부분.
 */
- (void)initData {
    dataList = [[NSMutableArray alloc] init];
    protocolList = [[ProtocolList alloc] init];
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
 HTML ParserData 호출 후 뿌려주는 부분.
 */
- (void)requestHTML {
    [protocolList getImageArray:^(id ob) {
        dataList = [(NSMutableArray *)ob mutableCopy];
        [self.tableView reloadData];
    } :^(NSError *error) {
        NSLog(@"error : %@",error);
    }];
}

#pragma mark- UITableView Delegate,DataSource
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
}

// 테이블뷰 Cell 크기 고정
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MainTableViewCell";
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    // 데이터.
    ViewModel *vm = [dataList objectAtIndex:indexPath.row];
    
    // Cell 꾸미기.
    cell.lbTitle.text = vm.caption;
    
    // 재사용 되는 부분 확인해야할듯.
    cell.imgView.image = [UIImage imageNamed:@"noimage"];
    [[ImageCache instance] loadFromUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,vm.thumImageURL] callback:^(UIImage *image) {
        cell.imgView.image = image;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
