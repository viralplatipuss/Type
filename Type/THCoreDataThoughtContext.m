//
//  THCoreDataThoughtContext.m
//  Thoughts
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THCoreDataThoughtContext.h"
#import "THCoreDataThought.h"

static NSString * const kThoughtsDataModelFileName = @"Thoughts";


@interface THCoreDataThoughtContext()

@property (nonatomic, copy, readonly) NSString *persistentStoreType;

@property (nonatomic, copy, readonly) NSURL *persistentStoreURL;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation THCoreDataThoughtContext

@synthesize persistentStoreType = _persistentStoreType, persistentStoreURL = _persistentStoreURL, managedObjectContext = _managedObjectContext, managedObjectModel = _managedObjectModel, persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Init

-(instancetype)initWithPersistentStoreType:(NSString *)storeType URL:(NSURL *)url
{
    self = [super init];
    if(self) {
        _persistentStoreType = storeType;
        _persistentStoreURL = url;
    }
    return self;
}


#pragma mark - Public Protocol Methods

-(THCoreDataThought *)anyThought
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:[THCoreDataThought coreDataEntityName] inManagedObjectContext:self.managedObjectContext];
    fetchRequest.fetchLimit = 1;
    
    NSError *fetchError;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if(!fetchedObjects) {
        if(fetchError) {
            NSLog(@"FirstThought Fetch Error: %@", [fetchError localizedDescription]);
        }
        return nil;
    }
    
    if([fetchedObjects count] < 1) {
        return nil;
    }
    
    THCoreDataThought *thought = fetchedObjects[0];
    thought.thoughtContext = self;
    
    return thought;
}

-(THCoreDataThought *)thoughtForUnqiueToken:(NSString *)uniqueToken
{
    NSURL *url = [NSURL URLWithString:uniqueToken];
    //NSURL *url = [NSURL URLWithString:[uniqueToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSManagedObjectID *objectID = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
    
    THCoreDataThought *thought = (THCoreDataThought *)[self.managedObjectContext objectWithID:objectID];
    thought.thoughtContext = self;
    
    return thought;
}

-(THCoreDataThought *)createThoughtWithSpecification:(THThoughtSpecification *)thoughtSpecification
{
    THCoreDataThought *firstThought = [self anyThought];
    
    if(firstThought) {
        return [self createThoughtWithSpecification:thoughtSpecification afterThought:firstThought.nextThought];
    }
    
    //Start new chain
    
    THCoreDataThought *newThought = [self newThoughtWithSpecification:thoughtSpecification];
    newThought.nextThought = newThought;
    newThought.previousThought = newThought;
    
    [self saveContext];
    
    return newThought;
}


#pragma mark - Public Methods

-(NSString *)uniqueTokenForThought:(THCoreDataThought *)thought
{
    if(![self containsThought:thought]) {
        return nil;
    }
    
    return [thought.objectID.URIRepresentation absoluteString];
}

-(THCoreDataThought *)createThoughtWithSpecification:(THThoughtSpecification *)thoughtSpecification afterThought:(THCoreDataThought *)thought
{
    if(![self containsThought:thought]) {
        return nil;
    }
    
    THCoreDataThought *previousThought = thought;
    THCoreDataThought *nextThought = previousThought.nextThought;
    
    THCoreDataThought *newThought = [self newThoughtWithSpecification:thoughtSpecification];
    newThought.previousThought = previousThought;
    newThought.nextThought = nextThought;
    
    previousThought.nextThought = newThought;
    nextThought.previousThought = newThought;
    
    [self saveContext];
    
    return newThought;
}

-(void)removeThought:(THCoreDataThought *)thought
{
    if(![self containsThought:thought]) {
        return;
    }
    
    //Pop out of linked list
    THCoreDataThought *previousThought = thought.previousThought;
    THCoreDataThought *nextThought = thought.nextThought;

    previousThought.nextThought = nextThought;
    nextThought.previousThought = previousThought;
    
    [self.managedObjectContext deleteObject:thought];
    
    [self saveContext];
}


#pragma mark - Private Helpers

-(BOOL)containsThought:(THCoreDataThought *)thought
{
    if(thought.managedObjectContext == self.managedObjectContext) {
        return YES;
    }

    return NO;
}

-(THCoreDataThought *)newThoughtWithSpecification:(THThoughtSpecification *)thoughtSpecification
{
    THCoreDataThought *newThought = [NSEntityDescription insertNewObjectForEntityForName:[THCoreDataThought coreDataEntityName] inManagedObjectContext:self.managedObjectContext];
    
    newThought.thoughtContext = self;
    
    newThought.text = thoughtSpecification.text;
    
    return newThought;
}


//---------------------------------------------------------------------------------------------------------------

#pragma mark - Core Data

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the Dao.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the Dao.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if(!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kThoughtsDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {

        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:self.persistentStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

@end
