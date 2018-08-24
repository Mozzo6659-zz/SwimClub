//
//  resultsCell.m
//  SwimClub
//
//  Created by Mick Mossman on 12/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "resultsCell.h"

@implementation resultsCell

@synthesize lbltbimprove;
@synthesize lbltbresult;
@synthesize lbltbEstCell;

- (void)awakeFromNib {
    [super awakeFromNib];
    /*
    lbltbEstCell = [[UILabel alloc] init];
    lbltbresult = [[UILabel alloc] init];
    lbltbimprove = [[UILabel alloc] init];
     */
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
