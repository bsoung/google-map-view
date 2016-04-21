//
//  AppDelegate.h
//  googlemap2
//
//  Created by Aditya Narayan on 9/1/15.
//  Copyright (c) 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CustomInfoWindow.h"

@import GoogleMaps;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) UINavigationController * navigationController;
@property(strong, nonatomic) CustomInfoWindow * viewController;


@end

