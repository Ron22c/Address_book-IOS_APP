//
//  DBManager.h
//  AddressBook(sqliteDB)
//
//  Created by Ranajit Chandra on 31/01/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

@property (strong, nonatomic) NSMutableArray *arrCoumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long lastInsertedRowId;

-(instancetype)initWithDatabaseFileName:(NSString *)fileName;
-(NSArray *) loadDataFromDB:(NSString *)queryString;
-(void) executeQuery:(NSString *)queryString;

@end

NS_ASSUME_NONNULL_END
