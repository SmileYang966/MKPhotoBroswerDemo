//
//  SCCollectionViewCell.h
//  MKPhotoBroswerDemo
//
//  Created by Evan Yang on 2020/12/20.
//

#import <UIKit/UIKit.h>
#import "SCPhotoFilePath.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)SCPhotoFilePath *filePath;

@end

NS_ASSUME_NONNULL_END
