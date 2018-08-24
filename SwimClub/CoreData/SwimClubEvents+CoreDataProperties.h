//
//  SwimClubEvents+CoreDataProperties.h
//  SwimClub
//
//  Created by Mick Mossman on 27/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubEvents+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SwimClubEvents (CoreDataProperties)

+ (NSFetchRequest<SwimClubEvents *> *)fetchRequest;

@property (nonatomic) int16_t datachanged;
@property (nonatomic) int32_t distancemtrs;
@property (nullable, nonatomic, copy) NSDate *downloadeddate;
@property (nullable, nonatomic, copy) NSDate *eventdate;
@property (nonatomic) int32_t eventid;
@property (nullable, nonatomic, copy) NSString *eventname;
@property (nonatomic) int16_t isfinished;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSDate *uploadeddate;
@property (nonatomic) int32_t webid;
@property (nullable, nonatomic, retain) NSSet<SwimClubEventResults *> *eventResults;

@end

@interface SwimClubEvents (CoreDataGeneratedAccessors)

- (void)addEventResultsObject:(SwimClubEventResults *)value;
- (void)removeEventResultsObject:(SwimClubEventResults *)value;
- (void)addEventResults:(NSSet<SwimClubEventResults *> *)values;
- (void)removeEventResults:(NSSet<SwimClubEventResults *> *)values;

@end

NS_ASSUME_NONNULL_END
