//
//  SCPhotoReviewCollectionViewCell.m
//  MKPhotoBroswerDemo
//
//  Created by Evan Yang on 2020/12/27.
//

#import "SCPhotoReviewCollectionViewCell.h"
#import "Masonry/Masonry.h"
#import "UIImageView+webCache.h"

@interface SCPhotoReviewCollectionViewCell()

@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation SCPhotoReviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.imageView = imageView;
}

- (void)setFilePath:(SCPhotoFilePath *)filePath{
    _filePath = filePath;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:filePath.filePath] placeholderImage:[UIImage imageNamed:nil]];
}

@end
