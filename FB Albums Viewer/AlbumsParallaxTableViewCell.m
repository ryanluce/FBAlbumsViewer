//
//  AlbumsParallaxTableViewCell.m
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/12/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import "AlbumsParallaxTableViewCell.h"
#import "ImageController.h"
#import "AlbumModel.h"

@interface AlbumsParallaxTableViewCell ()
{
    IBOutlet UILabel *_albumNameLabel;
    IBOutlet UILabel *_imageCountLabel;
    UIImageView *_imageView;
}
@end

@implementation AlbumsParallaxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithAlbumModel:(AlbumModel *)albumModel
{
    _albumNameLabel.text = albumModel.albumName;
    _imageCountLabel.text = [NSString stringWithFormat:@"%@", albumModel.imageCount];
    [[ImageController sharedImageController] loadImageWithURL:albumModel.albumImageURL
                                           andCompletionBlock:^(UIImage *image) {
                                               [self setupImage:image];
                                            }];
    
}

- (void)setupImage:(UIImage *)image
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithImage:image];
    } else
    {
        _imageView.image = image;
    }
    
    CGFloat imageAspectRatio = image.size.height/image.size.width;
    CGRect imageViewFrame = CGRectMake(0,
                                       0,
                                       320,
                                       image.size.height * imageAspectRatio);
    _imageView.frame = imageViewFrame;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if(!_imageView.superview)
    {
        [self.contentView insertSubview:_imageView
               belowSubview:_albumNameLabel];
    }
    
}

- (void)updateParallax:(CGFloat)parallaxValue
{
    CGRect imageViewFrame = _imageView.frame;
    CGFloat endValue = [self parallaxEndValue];
    CGFloat startValue = [self parallaxStartValue];
    imageViewFrame.origin.y = (endValue - startValue) * parallaxValue;
    _imageView.frame = imageViewFrame;
}

- (CGFloat)parallaxStartValue
{
    return 0.f;
}

- (CGFloat)parallaxEndValue
{
    //
    return -_imageView.image.size.height+self.frame.size.height;
}



@end
