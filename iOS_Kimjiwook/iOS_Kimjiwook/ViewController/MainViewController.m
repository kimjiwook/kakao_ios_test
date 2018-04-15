//
//  MainViewController.m
//  iOS_Kimjiwook
//
//  Created by kimjiwook on 2018. 4. 11..
//  Copyright © 2018년 kimjiwook. All rights reserved.
//

#import "MainViewController.h"
#import "ViewModel.h"

#import "DetailViewController.h"
#import "MainTableViewCell.h"

@interface MainViewController () {
    NSMutableArray *dataList;
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
    self.protocolList = [[ProtocolList alloc] init];
    [self setNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"시작점.");
    [self initData];
    [self requestHTML];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 네비게이션 정보.
 */
- (void)setNavigation {
    self.title = @"iOS_김지욱";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.31 green:0.25 blue:0.21 alpha:1.0f]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName
                                                                      , nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


/**
 HTML ParserData 호출 후 뿌려주는 부분.
 */
- (void)requestHTML {
    [self startLodingView];
    [self.protocolList getImageArray:^(id ob) {
        self->dataList = [(NSMutableArray *)ob mutableCopy];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self stopLodingView];
    } :^(NSError *error) {
        NSLog(@"error : %@",error);
        [self stopLodingView];
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

#pragma mark ㄴ TableView Cell 높이 관련.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark ㄴ TableView 꾸미는 관련.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MainTableViewCell";
    
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    // 데이터.
    ViewModel *vm = [dataList objectAtIndex:indexPath.row];
    // Cell 꾸며주는 부분.
    [cell configuration:vm indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 데이터.
    ViewModel *vm = [dataList objectAtIndex:indexPath.row];
    
    // 상세화면 이동
    DetailViewController *desc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    desc.navigationTitle = vm.caption;
    desc.detailUrl = vm.detailURL;
    [self.navigationController pushViewController:desc animated:YES];
}
@end
