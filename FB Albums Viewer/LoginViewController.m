//
//  LoginViewController.m
//  FB Albums Viewer
//
//  Created by Ryan Luce on 10/11/14.
//  Copyright (c) 2014 Ryan Luce. All rights reserved.
//

#import "LoginViewController.h"
#import "AlbumsListViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
{
    
}

- (IBAction)doLogin:(id)sender;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Override point for customization after application launch.
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_photos"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self pushAlbumsListAnimated:NO];
                                      }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender
{
    //@"user_photos"
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_photos"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self pushAlbumsListAnimated:YES];
     }];
}

- (void)pushAlbumsListAnimated:(BOOL)animated
{
    AlbumsListViewController *albumsListViewController = [self.storyboard
                                                    instantiateViewControllerWithIdentifier:@"albumsListViewController"];
    [self.navigationController pushViewController:albumsListViewController
                                         animated:animated];
                                                          
    
}




@end
