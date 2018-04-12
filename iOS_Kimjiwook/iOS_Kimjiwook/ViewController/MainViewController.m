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

@interface MainViewController () <MainTableViewDelegate> {
    NSMutableArray *dataList;
    ProtocolList *protocolList;
    NSURLSessionTask *imageTasks;
    
    AFHTTPSessionManager *manager;
    
    NSOperationQueue *imageLoadQueue;
    NSMutableDictionary *queueDic;
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
    imageTasks = [[NSURLSessionTask alloc] init];
    
    imageLoadQueue = [[NSOperationQueue alloc] init];
    queueDic = [[NSMutableDictionary alloc] init];
    
    // 네트워크 통신 준비.
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
        self->dataList = [(NSMutableArray *)ob mutableCopy];
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
    cell.delegate = self;
    [cell configuration:vm indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self cancelDownloadCellIamge:indexPath];
//}

//- (void)downloadCellImage:(NSIndexPath *)indexPath {
//    ViewModel *vm = [dataList objectAtIndex:indexPath.row];
//    if (vm.thumImage) {
//        // 이미지가 존재함으로 다운로드 받지 않는다.
//        NSLog(@"이미지가 존재함 %ld",indexPath.row);
//        return;
//    }
//    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,vm.thumImageURL];
//
//    NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
//    __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
//    [loadImageIntoCellOp addExecutionBlock:^{
//
//        NSLog(@"%ld 다운로드 큐 들어옴",indexPath.row);
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
//        NSLog(@"%ld 다운로드 됨",indexPath.row);
//        vm.thumImage = image;
//        NSLog(@"%ld 리로드 시킴.",indexPath.row);
//        [UIView setAnimationsEnabled:NO];
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
//        [UIView setAnimationsEnabled:YES];
//
////        NSLog(@"%ld 다운로드 큐 들어옴",indexPath.row);
////        [manager GET:imageUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////            NSLog(@"%ld 다운로드 됨/",indexPath.row);
////            vm.thumImage = [UIImage imageWithData:(NSData *)responseObject];
////
////            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
////                if (!weakOp.isCancelled) {
////                    [self cancelDownloadCellIamge:indexPath];
////                    // 정상적일때 큐에서 뺴고 리로드 시키기.
////                    // 애니메이션 없이 리로드 시킴.
////                    NSLog(@"%ld 리로드 시킴.",indexPath.row);
////                    [UIView setAnimationsEnabled:NO];
////                    [self.tableView beginUpdates];
////                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
////                    [self.tableView endUpdates];
////                    [UIView setAnimationsEnabled:YES];
////                }
////            }];
////        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////            NSLog(@"error");
////        }];
//
//
//        [[ImageCache instance] loadFromUrl:imageUrl callback:^(UIImage *image) {
//            // 보여지고 있는 Cell 중에 리로드 해야하는 항목만 리로드 시켜주기.
//            NSLog(@"다운로드 됨. %ld",indexPath.row);
//            for (UITableViewCell *cell in self.tableView.visibleCells) {
//                NSIndexPath *tempIndexPath = [self.tableView indexPathForCell:cell];
//                vm.thumImage = image;
//                if (indexPath.row == tempIndexPath.row) {
//                    NSLog(@"비교후 리로드.%ld",indexPath.row);
////                    MainTableViewCell *inCell = (MainTableViewCell *)cell;
////                    [inCell configuration:vm indexPath:indexPath];
//                    // 애니메이션 없이 리로드 시킴.
//                    [UIView setAnimationsEnabled:NO];
//                    [self.tableView beginUpdates];
//                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                    [self.tableView endUpdates];
//                    [UIView setAnimationsEnabled:YES];
//                }
//            }
//        }];
//    }];
//
//    // 큐에 담기.
//    if (loadImageIntoCellOp) {
//        [imageLoadQueue addOperation:loadImageIntoCellOp];
//        [queueDic setObject:loadImageIntoCellOp forKey:[NSString stringWithFormat:@"%ld",indexPath.row]]; // 삭제예정인것 들.
//    }
//}
//
//- (void)cancelDownloadCellIamge:(NSIndexPath *)indexPath {
//    NSBlockOperation *loadImageIntoCellOp = [queueDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    if (loadImageIntoCellOp) {
//        [loadImageIntoCellOp cancel];
//        loadImageIntoCellOp = nil;
//        [queueDic removeObjectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
//        NSLog(@"%@ : 다운로드 삭제함.", [NSString stringWithFormat:@"%ld",indexPath.row]);
//    }
//}


@end
