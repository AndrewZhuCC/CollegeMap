//
//  BarcodeItemStore.m
//  CollegeMap
//
//  Created by Andrew on 15/11/6.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "BarcodeItemStore.h"
#import "BarcodeItem.h"

@interface BarcodeItemStore ()

@property (nonatomic, strong) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BarcodeItemStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BarcodeItemStore *)sharedInstance
{
    static BarcodeItemStore *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BarcodeItemStore alloc]init];
    });
    
    return sharedInstance;
}

- (void)dealloc
{
    self.managedObjectModel         = nil;
    self.managedObjectContext       = nil;
    self.persistentStoreCoordinator = nil;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"BarcodeItem" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [storeURL URLByAppendingPathComponent:@"BarcodeItem.sqlite"];
        NSError *error = nil;
        [_persistentStoreCoordinator
            addPersistentStoreWithType:NSSQLiteStoreType
                         configuration:nil
                                   URL:storeURL
                               options:nil
                                 error:&error];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}

- (BarcodeItem *)creatItem
{
    BarcodeItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BarcodeItem" inManagedObjectContext:[BarcodeItemStore sharedInstance].managedObjectContext];
    
    return item;
}

- (NSArray *)allItem
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BarcodeItem"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

@end
