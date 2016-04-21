//
//  ViewController.m
//  googlemap2
//
//  Created by Aditya Narayan on 9/1/15.
//  Copyright (c) 2015 TTT. All rights reserved.
//

#import "ViewController.h"
#import "CustomInfoWindow.h"
#import "MapKit/MapKit.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@import GoogleMaps;

@interface ViewController ()

@end

@implementation ViewController {
   
}

#pragma mark: Using Google Maps API to set up current location for camera and zoom settings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:40.7414444 longitude:-73.99007 zoom:16];
    
    GMSMapView * mapView =  self.google_map;
    mapView.camera = camera;
    mapView.delegate = self;
    
    GMSMarker * marker = [[GMSMarker alloc]init];
    marker.position = camera.target;
    marker.title = @"Turn to Tech";
    marker.snippet = @"NYC";
    marker.userData = @{@"url" : [NSURL URLWithString:@"http://www.turntotech.io"], @"image": [UIImage imageNamed:@"TurnToTech.png"]};

    marker.map = mapView;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#pragma mark: Using MapKit to search surrounding area for information - previous questions
    
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.7414444, -73.99007);
//    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.002, 0.002));
//    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//    request.region = region;
//    request.naturalLanguageQuery = @"Restaurant";
//    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
//    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
//        if (response.mapItems.count == 0) {
//            NSLog(@"No Results Found!");
//        } else {
//            //            NSLog(@"%@", response.mapItems);
//            for (MKMapItem *item in response.mapItems) {
//                GMSMarker * marker = [[GMSMarker alloc] init];
//                marker.position = item.placemark.location.coordinate;
//                marker.title = item.placemark.name;
//                marker.snippet = item.placemark.thoroughfare;
//                marker.map = self.google_map;
//                marker.userData = @{@"url" : item.url};
//                
//            }
//        }
//    }];

#pragma mark: Using Google Places API GMSPlacePicker to individual pick locations - experiment

//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
//    GMSCoordinateBounds *viewPort = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
//    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewPort];
//    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
//    
//    [_placePicker pickPlaceWithCallback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
//        if (result == nil) {
//            NSLog(@"No Results found");
//        } else {
//            //NSLog(@"Success!");
//            GMSMarker * marker = [[GMSMarker alloc] init];
//            marker.position = result.coordinate;
//            marker.title = result.name;
//            marker.snippet = result.formattedAddress;
//            marker.map = self.google_map;
//            if (result.website) {
//                marker.userData = @{@"url" : result.website};
//            }
//            
//        }
//    }];
    
    [self findBusinessesWithType:@"food"];
    [self.searchbar setText:@"food"];
}

#pragma mark: Method to search anything in maps by AFNetworking and Google Places API

- (void)findBusinessesWithType:(NSString *)type
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.7414444, -73.99007);
    NSString *requestString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&types=%@&key=AIzaSyB7XWLobeEhDzkOCB6wOy7tQqj9MsnDVaM", center.latitude, center.longitude, type];
    NSURL *URL = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSArray *results = (NSArray *)([responseObject objectForKey:@"results"]);
        for (NSDictionary *restaurantObject in results){
            NSString *name = [restaurantObject objectForKey:@"name"];

            GMSMarker * marker = [[GMSMarker alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([restaurantObject[@"geometry"][@"location"][@"lat"] floatValue], [restaurantObject[@"geometry"][@"location"][@"lng"] floatValue]); //navigate the json hierarchy and convert strings to float values
            
            marker.position = coordinate;
            marker.title = name;
            marker.snippet = restaurantObject[@"vicinity"];
            marker.map = self.google_map;
            
            NSURL *url = [NSURL URLWithString:restaurantObject[@"icon"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            
            if (image) {
                marker.userData = @{@"url" : url, @"image":image};
            } else {
                marker.userData = @{@"url" : [NSURL URLWithString:@"http://www.google.com"], @"image": [UIImage imageNamed:@"TurnToTech.png"]};
            }
            
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];


}

#pragma mark: Setting up the info window when you press on a marker

-(UIView*) mapView: (GMSMapView*)mapView markerInfoWindow:(GMSMarker *)marker
{
    CustomInfoWindow * infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"CustomInfoWindows" owner:self options:nil]objectAtIndex:0];
    
    infoWindow.label1.text = marker.title;
    infoWindow.label2.text = marker.snippet;
    infoWindow.imageView.image = marker.userData[@"image"];
    
    return infoWindow;
}

#pragma mark: Setting up transition to webViewController

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    self.webObject = [[webController alloc]initWithNibName:@"webController" bundle:nil];
    self.webObject.someurl = [marker.userData objectForKey:@"url"];
    [self.navigationController pushViewController:self.webObject animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeMapType:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.google_map.mapType = kGMSTypeNormal;
            break;
        case 1:
            self.google_map.mapType = kGMSTypeSatellite;
            break;
        case 2:
            self.google_map.mapType = kGMSTypeHybrid;
            break;
        default:
            break;
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.google_map clear];
    [self findBusinessesWithType:searchBar.text];
}
@end
