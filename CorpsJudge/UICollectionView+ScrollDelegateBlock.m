// Implementation file
#import "UICollectionView+ScrollDelegateBlock.h"
#import <objc/runtime.h>

NSString *const BLOCK_CALLED_NOTIFICATION = @"BlockCalled";

@interface ScrollDelegateWrapper : NSObject <UICollectionViewDelegate>

@property (copy) void(^scrollFinishedBlock)();

@end

@implementation ScrollDelegateWrapper

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.scrollFinishedBlock) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BLOCK_CALLED_NOTIFICATION object:nil];
        self.scrollFinishedBlock();
    }
}

@end

static const char kScrollDelegateWrapper;

static id<UITableViewDelegate>previousDelegate;

@implementation UITableView (ScrollDelegateBlock)

-(void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
             atScrollPosition:(UITableViewScrollPosition)scrollPosition
                     animated:(BOOL)animated
               scrollFinished:(void (^)())scrollFinished {
    previousDelegate = self.delegate;
    ScrollDelegateWrapper *scrollDelegateWrapper = [[ScrollDelegateWrapper alloc] init];
    scrollDelegateWrapper.scrollFinishedBlock = scrollFinished;
    self.delegate = scrollDelegateWrapper;
    
    objc_setAssociatedObject(self, &kScrollDelegateWrapper, scrollDelegateWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(blockCalled:)
                                                 name:BLOCK_CALLED_NOTIFICATION
                                               object:nil];
}

/*
 * Assigns delegate back to the original delegate
 */
-(void) blockCalled:(NSNotification *)notification {
    self.delegate = previousDelegate;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BLOCK_CALLED_NOTIFICATION
                                                  object:nil];
}

@end