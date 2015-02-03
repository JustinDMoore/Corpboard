//
//  CBNewsCell.h
//  CorpBoard
//
//  Created by Justin Moore on 2/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBNewsCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgLogo;
@property (nonatomic, strong) NSString *link;
@property (nonatomic) int colorNumber;

-(void)createBackground;

@end
