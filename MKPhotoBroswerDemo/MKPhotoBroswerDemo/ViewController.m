//
//  ViewController.m
//  MKPhotoBroswerDemo
//
//  Created by Evan Yang on 2020/12/20.
//

#import "ViewController.h"
#import "MWPhotoBrowser.h"
#import "Masonry.h"
#import "SCCollectionViewCell.h"
#import "SCPhotoFilePath.h"
#import "SCBroswerViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *photoArrayM;
@property(nonatomic,strong)NSMutableArray *fileArrayM;

@end

@implementation ViewController

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat marginX = 20;
        CGFloat width = (UIScreen.mainScreen.bounds.size.width - 4*marginX) / 3.0f;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(width,width);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = marginX;
        layout.minimumInteritemSpacing = marginX;
        layout.sectionInset = UIEdgeInsetsMake(0, marginX,0, marginX);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[SCCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        collectionView.backgroundColor = UIColor.whiteColor;
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self collectionView];
    self.photoArrayM =[NSMutableArray array];
    self.fileArrayM = [NSMutableArray array];
    
    SCPhotoFilePath *file1 = [[SCPhotoFilePath alloc]init];
    file1.type = @"image";
    file1.filePath = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608452681707&di=1063abf4de70958bdd20baf7bc3ed52f&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F02%2F38%2F01300000237560123245382609951.jpg";
    
    SCPhotoFilePath *file2 = [[SCPhotoFilePath alloc]init];
    file2.type = @"image";
    file2.filePath = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608452681707&di=da4269b2caa9e6ab679987207aba2f7f&imgtype=0&src=http%3A%2F%2Fpic16.nipic.com%2F20110928%2F5200151_002314030000_2.jpg";
    
    SCPhotoFilePath *file3 = [[SCPhotoFilePath alloc]init];
    file3.type = @"image";
    file3.filePath = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608452681707&di=d85bd44d23e432fa2559ffbbcf3a9da1&imgtype=0&src=http%3A%2F%2Fa2.att.hudong.com%2F42%2F31%2F01300001320894132989315766618.jpg";
    
    SCPhotoFilePath *file4 = [[SCPhotoFilePath alloc]init];
    file4.type = @"image";
    file4.filePath = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608452681707&di=9f0bc17700fc16a20fbe3ca6f1dabcd5&imgtype=0&src=http%3A%2F%2Fa2.att.hudong.com%2F71%2F56%2F16300000988660128426569668958.jpg";
    
    SCPhotoFilePath *videoFile = [[SCPhotoFilePath alloc]init];
    videoFile.type = @"video";
    videoFile.filePath = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    
    [self.fileArrayM addObjectsFromArray:@[videoFile,file1,file2,file3,file4]];
    
    for (SCPhotoFilePath *file in self.fileArrayM) {
        if ([file.type isEqualToString:@"image"]) {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:file.filePath]];
            [self.photoArrayM addObject:photo];
        }else{
            MWPhoto *video = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1652123795,1945063222&fm=26&gp=0.jpg"]];
            video.videoURL = [NSURL URLWithString:file.filePath];
            [self.photoArrayM addObject:video];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArrayM.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.lightGrayColor;
    SCPhotoFilePath *photoPath = self.fileArrayM[indexPath.row];
    cell.filePath = photoPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self reviewSCPhotoWithIndex:indexPath.row];
}

- (void)reviewPhotoWithIndex:(NSInteger)index{
    MWPhotoBrowser  *photoBrowser = [[MWPhotoBrowser alloc]initWithPhotos:self.photoArrayM];
    // Set options
    photoBrowser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    photoBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    photoBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    photoBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    photoBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    photoBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    photoBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    photoBrowser.autoPlayOnAppear = NO; // Auto-play first video
    // Manipulate
    [photoBrowser showNextPhotoAnimated:YES];
    [photoBrowser showPreviousPhotoAnimated:YES];
    [photoBrowser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:photoBrowser animated:YES];
    
}

- (void)reviewSCPhotoWithIndex:(NSInteger)selectedIndex{
    SCBroswerViewController *broswerVC = [[SCBroswerViewController alloc]init];
    broswerVC.selectedIndex = selectedIndex;
    broswerVC.dataList = self.fileArrayM;
    [self.navigationController pushViewController:broswerVC animated:YES];
}

@end
