//
//  AlbumsParallaxTableViewCell.h
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/12/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel;

@interface AlbumsParallaxTableViewCell : UITableViewCell

- (void)updateWithAlbumModel:(AlbumModel *)albumModel;
//parallax value should be 0.0 to 1.0
- (void)updateParallax:(CGFloat)parallaxValue;
@end
