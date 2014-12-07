//
//  LiveChatCell.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/7/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "LiveChatCell.h"

@implementation LiveChatCell

- (void)awakeFromNib {
    // Initialization code
    self.imgLastUser.layer.cornerRadius = self.imgLastUser.frame.size.width/2;
    self.imgLastUser.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
