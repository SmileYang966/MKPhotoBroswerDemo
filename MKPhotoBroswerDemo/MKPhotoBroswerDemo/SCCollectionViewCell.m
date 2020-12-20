//
//  SCCollectionViewCell.m
//  MKPhotoBroswerDemo
//
//  Created by Evan Yang on 2020/12/20.
//

#import "SCCollectionViewCell.h"
#import "Masonry/Masonry.h"
#import "UIImageView+webCache.h"

@interface SCCollectionViewCell()

@property(nonatomic,strong)UIImageView *imgView;

@end

@implementation SCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupCellSubViews];
    }
    return self;
}

- (void)setupCellSubViews{
    //1.UIImageView
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    imgView.image = [UIImage imageNamed:@"11.png"];
    self.imgView = imgView;
}

- (void)setFilePath:(SCPhotoFilePath *)filePath{
    _filePath = filePath;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:filePath.filePath] placeholderImage:[UIImage imageNamed:@"11.png"]];
}

@end
