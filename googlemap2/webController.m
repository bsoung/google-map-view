//
//  webController.m
//  googlemap2
//
//  Created by Aditya Narayan on 9/2/15.
//  Copyright (c) 2015 TTT. All rights reserved.
//

#import "webController.h"

@interface webController ()

@end

@implementation webController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webImage loadRequest:[NSURLRequest requestWithURL:self.someurl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
