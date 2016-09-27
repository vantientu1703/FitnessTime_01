//
//  GymLocation+CoreDataProperties.h
//  GymManager
//
//  Created by Thinh on 9/27/16.
//  Copyright © 2016 vantientu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GymLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface GymLocation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *latitue;
@property (nullable, nonatomic, retain) NSNumber *longtitue;

@end

NS_ASSUME_NONNULL_END
