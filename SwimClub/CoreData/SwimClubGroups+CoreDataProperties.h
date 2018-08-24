//
//  SwimClubGroups+CoreDataProperties.h
//  SwimClub
//
//  Created by Mick Mossman on 8/1/18.
//  Copyright © 2018 Hammerhead Software. All rights reserved.
//
//

#import "SwimClubGroups+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SwimClubGroups (CoreDataProperties)

+ (NSFetchRequest<SwimClubGroups *> *)fetchRequest;

@property (nonatomic) int16_t groupid;
@property (nullable, nonatomic, copy) NSString *groupname;
@property (nonatomic) int16_t startseconds;
@property (nonatomic) int16_t endseconds;
@property (nullable, nonatomic, retain) NSSet<SwimClubMembers *> *members;

@end

@interface SwimClubGroups (CoreDataGeneratedAccessors)

- (void)addMembersObject:(SwimClubMembers *)value;
- (void)removeMembersObject:(SwimClubMembers *)value;
- (void)addMembers:(NSSet<SwimClubMembers *> *)values;
- (void)removeMembers:(NSSet<SwimClubMembers *> *)values;

@end

NS_ASSUME_NONNULL_END
