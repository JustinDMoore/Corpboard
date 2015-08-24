//
//  UICollectionView+ScrollingCallback.h
//  Corpboard
//
//  Created by Isaias Favela on 8/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

// Header file
@interface UICollectionView (ScrollDelegateBlock)

-(void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
             atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                     animated:(BOOL)animated
               scrollFinished:(void (^)())scrollFinished;

@end
