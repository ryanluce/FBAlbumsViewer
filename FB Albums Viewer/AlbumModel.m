//
//  AlbumModel.m
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/12/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import "AlbumModel.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AlbumModel

//helper method to get image url based on the album id
- (NSString *)albumImageURL
{
    NSString *imageUrl = [NSString stringWithFormat:
                          @"https://graph.facebook.com/%@/picture?access_token=%@",
                          self.albumId,
                          [[FBSession activeSession] accessTokenData]];
    return imageUrl;
}

@end
