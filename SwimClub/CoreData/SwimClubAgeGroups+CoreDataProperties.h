//
//  SwimClubAgeGroups+CoreDataProperties.h
//  SwimClub
//
//  Created by Mick Mossman on 29/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubAgeGroups+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SwimClubAgeGroups (CoreDataProperties)

+ (NSFetchRequest<SwimClubAgeGroups *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *agegroupname;
@property (nonatomic) int16_t maxage;
@property (nonatomic) int16_t minage;
@property (nonatomic) int16_t agegroupid;
@property (nullable, nonatomic, retain) NSSet<SwimClubMembers *> *members;

@end

@interface SwimClubAgeGroups (CoreDataGeneratedAccessors)

- (void)addMembersObject:(SwimClubMembers *)value;
- (void)removeMembersObject:(SwimClubMembers *)value;
- (void)addMembers:(NSSet<SwimClubMembers *> *)values;
- (void)removeMembers:(NSSet<SwimClubMembers *> *)values;

@end

NS_ASSUME_NONNULL_END
