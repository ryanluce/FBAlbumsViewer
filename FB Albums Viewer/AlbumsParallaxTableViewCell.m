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
    CGFloat _lastParallaxValue;
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

//add the image and resize it to the width of the screen.
- (void)setupImage:(UIImage *)image
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithImage:image];
    } else
    {
        _imageView.image = image;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageAspectRatio = screenWidth/image.size.width;
    CGRect imageViewFrame = CGRectMake(0,
                                       0,
                                       screenWidth,
                                       image.size.height * imageAspectRatio);
    _imageView.frame = imageViewFrame;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self updateParallax:_lastParallaxValue];
    
    if(!_imageView.superview)
    {
        [self.contentView insertSubview:_imageView
               belowSubview:_albumNameLabel];
    }
    
    
}

//more parallax magic
- (void)updateParallax:(CGFloat)parallaxValue
{
    //set this so when the cell is created and the image hasn't loaded, the cell has an initial value to go to.
    _lastParallaxValue = parallaxValue;
    CGRect imageViewFrame = _imageView.frame;
    CGFloat endValue = [self parallaxEndValue];
    CGFloat startValue = [self parallaxStartValue];
    imageViewFrame.origin.y = (endValue - startValue) * parallaxValue + startValue;
    _imageView.frame = imageViewFrame;
}

- (CGFloat)parallaxStartValue
{
    //the top of the image rooted at the top of the cell
    return 0.f;
}

- (CGFloat)parallaxEndValue
{
    //the bottom of the image rooted at the bottom of the cell
    return -_imageView.frame.size.height+self.frame.size.height;
}



@end
