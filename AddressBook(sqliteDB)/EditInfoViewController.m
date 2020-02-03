//
//  EditInfoViewController.m
//  AddressBook(sqliteDB)
//
//  Created by Ranajit Chandra on 31/01/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DBManager.h"

@interface EditInfoViewController ()
@property(strong, nonatomic)DBManager *dbManager;
@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.recordIDToEdit != -1) {
        [self loadInfoToEdit];
    }
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.age.delegate = self;
    self.address.delegate = self;
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"iosDB.sql"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveInfo:(id)sender {
    NSString *query;
    NSLog(@"inside save Info and recordid is %i", self.recordIDToEdit);
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"INSERT INTO people (id, firstName, lastName, age, address) VALUES (null, '%@', '%@', %d, '%@');", self.firstName.text, self.lastName.text, [self.age.text intValue], self.address.text];
    }
    else{
        query = [NSString stringWithFormat:@"update people set firstName='%@', lastName='%@', age=%d, address='%@' where id=%d", self.firstName.text, self.lastName.text, self.age.text.intValue, self.address.text, self.recordIDToEdit];
    }


    [self.dbManager executeQuery:query];
    NSLog(@"%@", query);
    if(self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        [self.navigationController popViewControllerAnimated:YES];
       } else {
           NSLog(@"Could not execute the query.");
       }
    
}

-(void)loadInfoToEdit{
    NSString *query = [NSString stringWithFormat:@"select * from people where id=%d", self.recordIDToEdit];
     NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
 
    self.firstName.text = [[results objectAtIndex:0] objectAtIndex:1];
    self.lastName.text = [[results objectAtIndex:0] objectAtIndex:2];
    self.age.text = [[results objectAtIndex:0] objectAtIndex:3];
    self.address.text = [[results objectAtIndex:0] objectAtIndex:4];
}
@end
