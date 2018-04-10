//
//  CameraViewController.m
//  PleaseAllowSample
//
//  Created by Gagandeep Singh on 23/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

#import "PleaseAllowSample-Swift.h"
#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [PermissionRequester request:PermissionTypeCamera handler:^(Result result, NSError * error) {
        NSLog(@"%@", error.localizedDescription);
        NSLog(@"%ld", (long)result);
    }];
}

@end
