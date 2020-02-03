//
//  DBManager.m
//  AddressBook(sqliteDB)
//
//  Created by Ranajit Chandra on 31/01/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>


@interface DBManager()

@property (strong, nonatomic) NSString *documentsDirectory;
@property (strong, nonatomic) NSString *databaseFilename;
@property (strong, nonatomic) NSMutableArray *resultsArr;
-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)isExecutable;

@end

@implementation DBManager

-(instancetype)initWithDatabaseFileName:(NSString *)fileName {
    self=[super init];
    if(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = fileName;
        [self copyDatabaseIntoDocumentsDirectory];

    }
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory {
    NSString *desiredPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:desiredPath]){
        NSString *sourcePath = [[[NSBundle mainBundle]
                                 resourcePath]
                                stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:desiredPath error:&error];
        if(error!=nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (self.resultsArr != nil) {
        [self.resultsArr removeAllObjects];
        self.resultsArr = nil;
    }
    self.resultsArr = [[NSMutableArray alloc] init];

    if (self.arrCoumnNames != nil) {
        [self.arrCoumnNames removeAllObjects];
        self.arrCoumnNames = nil;
    }
    self.arrCoumnNames = [[NSMutableArray alloc] init];
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            if (!queryExecutable){
                NSMutableArray *arrDataRow;
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    arrDataRow = [[NSMutableArray alloc] init];
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    for (int i=0; i<totalColumns; i++){
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        if (dbDataAsChars != NULL) {
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        if (self.arrCoumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrCoumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    if (arrDataRow.count > 0) {
                        [self.resultsArr addObject:arrDataRow];
                    }
                }
            } else {
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == YES) {
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowId = sqlite3_last_insert_rowid(sqlite3Database);
                } else {
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        } else {
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        sqlite3_finalize(compiledStatement);

    }
    sqlite3_close(sqlite3Database);
}

-(NSArray *) loadDataFromDB:(NSString *)queryString {
    [self runQuery:[queryString UTF8String] isQueryExecutable:NO];
    return self.resultsArr;
    
}
-(void) executeQuery:(NSString *)queryString {
    [self runQuery:[queryString UTF8String] isQueryExecutable:YES];
}

@end
