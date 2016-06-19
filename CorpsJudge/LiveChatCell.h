//
//  LiveChatCell.h
//  CorpBoard
//
//  Created by Isaias Favela on 12/7/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>


@interface LiveChatCell : UITableViewCell

@property (nonatomic, strong) IBOutlet PFImageView *imgLastUser;
@property (nonatomic, strong) IBOutlet UILabel *lblLastUser;
@property (nonatomic, strong) IBOutlet UILabel *lblLastUserHowLongAgo;
@property (nonatomic, strong) IBOutlet UILabel *lblChatName;
@property (nonatomic, strong) IBOutlet UILabel *lblStartedByUserAndWhen;
@property (nonatomic, strong) IBOutlet UILabel *lblNumberOfMessagesAndViews;

@end
