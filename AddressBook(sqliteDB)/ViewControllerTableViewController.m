//
//  ViewControllerTableViewController.m
//  AddressBook(sqliteDB)
//
//  Created by Ranajit Chandra on 31/01/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.


#import "ViewControllerTableViewController.h"
#import "DBManager.h"

@interface ViewControllerTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic) int recordIDToEdit;

-(void)loadData;

@end

@implementation ViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"iosDB.sql"];
    self.tblPeople.delegate = self;
    self.tblPeople.dataSource = self;
    [self loadData];
}

-(void)loadData{
    NSString *query = @"select * from people;";
 
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%@", self.arrPeopleInfo);
    [self.tblPeople reloadData];
}

-(void)editingInfoWasFinished{
    NSLog(@"Inside editing info was finished");
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Inside prepareForSegue");
    EditInfoViewController *editInfoViewController = [segue destinationViewController];
    NSLog(@"rechord Id to edit is : %i", self.recordIDToEdit);
    editInfoViewController.delegate = self;
    editInfoViewController.recordIDToEdit = self.recordIDToEdit;
}

- (IBAction)addNewRecord:(UIBarButtonItem *)sender {
    NSLog(@"clicked on add new rechord");
    self.recordIDToEdit = -1;
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
    NSLog(@"clicked on add new rechord and action finished");
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1], [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2], [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:4]];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:3]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPeopleInfo.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.recordIDToEdit = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
 
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];

        NSString *query = [NSString stringWithFormat:@"delete from peopleInfo where peopleInfoID=%d", recordIDToDelete];

        [self.dbManager executeQuery:query];

        [self loadData];
    }
}

@end
