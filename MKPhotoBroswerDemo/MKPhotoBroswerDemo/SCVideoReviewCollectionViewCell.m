//
//  SCVideoReviewCollectionViewCell.m
//  MKPhotoBroswerDemo
//
//  Created by Evan Yang on 2020/12/27.
//

#import "SCVideoReviewCollectionViewCell.h"
#import "Masonry/Masonry.h"
#import <AVKit/AVKit.h>

@interface SCVideoReviewCollectionViewCell()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayer *player;

@end

@implementation SCVideoReviewCollectionViewCell

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
//    imageView.image = [UIImage imageNamed:@"view.jpg"];
    imageView.userInteractionEnabled = YES;
    self.imageView = imageView;
    
    UIImageView *icon = [[UIImageView alloc]init];
    [imageView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.mas_equalTo(imageView);
        make.centerY.mas_equalTo(imageView);
    }];
    icon.image = [UIImage imageNamed:@"video.png"];
    icon.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTapped:)];
    [icon addGestureRecognizer:iconTap];
}

- (void)setVideoFilePath:(SCPhotoFilePath *)videoFilePath{
    _videoFilePath = videoFilePath;
    
    [self getVideoFirstViewImage:[NSURL URLWithString:videoFilePath.filePath] completedBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
if ([keyPath isEqualToString:@"status"]) {
    //取出status的新值
    AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];

    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"视频资源有误，加载失败");
            break;
        case AVPlayerItemStatusReadyToPlay:{
            NSLog(@"视频资源加载成功，准备好播放了");
            [self.player play];
            break;
        }
        case AVPlayerItemStatusUnknown:
            NSLog(@"视频资源出现未知错误");
            break;
        default:
            break;
    }
}
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}


// 获取视频第一帧
- (void)getVideoFirstViewImage:(NSURL *)path completedBlock:(void(^)(UIImage *image))videoFinishedBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (videoFinishedBlock) {
                videoFinishedBlock(videoImage);
            }
        });
        CGImageRelease(image);
    });
}

- (void)iconTapped:(UITapGestureRecognizer *)tap{
    AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.videoFilePath.filePath]];
    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [[AVPlayer alloc]initWithPlayerItem:playItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self layoutIfNeeded];
    playerLayer.frame = self.imageView.bounds;
    [self.imageView.layer addSublayer:playerLayer];
}

@end
