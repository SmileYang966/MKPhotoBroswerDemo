//
//  SCBroswerViewController.m
//  MKPhotoBroswerDemo
//
//  Created by Evan Yang on 2020/12/26.
//

#import "SCBroswerViewController.h"
#import "Masonry/Masonry.h"
#import "SCPhotoReviewCollectionViewCell.h"
#import "SCPhotoFilePath.h"
#import "SCVideoReviewCollectionViewCell.h"

@interface SCBroswerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *photoCollectionView;

@end

@implementation SCBroswerViewController

- (UICollectionView *)photoCollectionView{
    if (_photoCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 1.0f;
        _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        [self.view addSubview:_photoCollectionView];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.pagingEnabled = YES;
        _photoCollectionView.bounces = NO;
        _photoCollectionView.showsHorizontalScrollIndicator = NO;
        [_photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_photoCollectionView registerClass:[SCPhotoReviewCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_photoCollectionView registerClass:[SCVideoReviewCollectionViewCell class] forCellWithReuseIdentifier:@"video"];
    }
    return _photoCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self photoCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    static NSString *viddeoId = @"video";
    SCPhotoReviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    SCVideoReviewCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:viddeoId forIndexPath:indexPath];
    
    cell.backgroundColor = UIColor.blackColor;
    videoCell.backgroundColor = UIColor.blackColor;
    
    SCPhotoFilePath *filePath = self.dataList[indexPath.row];
    if ([filePath.type isEqual:@"video"]) {
        videoCell.videoFilePath = filePath;
        return videoCell;
    }else{
        cell.filePath = filePath;
        return cell;
    }
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [self.photoCollectionView reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

@end
