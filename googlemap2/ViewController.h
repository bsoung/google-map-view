//
//  ViewController.h
//  googlemap2
//
//  Created by Aditya Narayan on 9/1/15.
//  Copyright (c) 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webController.h"

@import GoogleMaps;

@interface ViewController : UIViewController <GMSMapViewDelegate>

@property(strong, nonatomic) webController *webObject;
@property (weak, nonatomic) IBOutlet GMSMapView *google_map;
@property (nonatomic, retain) GMSPlacePicker *placePicker;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;


- (IBAction)changeMapType:(id)sender;


@end

