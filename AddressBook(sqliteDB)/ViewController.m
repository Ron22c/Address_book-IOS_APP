//
//  ViewController.m
//  AddressBook(sqliteDB)
//
//  Created by Ranajit Chandra on 31/01/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", paths);
    
    NSString *sourcePath = [[NSBundle mainBundle]
     resourcePath];
    NSLog(@"%@", sourcePath);

    
}


@end
