//
//  ViewControllerTableViewController.h
//  AddressBook(sqliteDB)
//
//  Created by Ranajit Chandra on 31/01/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"

@interface ViewControllerTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblPeople;
- (IBAction)addNewRecord:(UIBarButtonItem *)sender;

@end


