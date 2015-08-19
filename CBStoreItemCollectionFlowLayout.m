//
//  CBStoreItemCollectionFlowLayout.m
//  Corpboard
//
//  Created by Justin Moore on 8/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreItemCollectionFlowLayout.h"

@implementation CBStoreItemCollectionFlowLayout

- (void)awakeFromNib {
    self.itemSize = CGSizeMake(116.0, 168.0);
    //self.minimumInteritemSpacing = 2.0;
    //self.minimumLineSpacing = 2.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
//
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalOffset = proposedContentOffset.x + 5;
//    
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    
//    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
//        CGFloat itemOffset = layoutAttributes.frame.origin.x;
//        if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemOffset - horizontalOffset;
//        }
//    }
//    
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//}

@end
