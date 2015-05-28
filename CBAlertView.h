//
//  CBAlertView.h
//  CorpBoard
//
//  Created by Isaias Favela on 5/14/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBAlertDelegate <NSObject>
@optional
-(void)didAcknowledgeCBAlert;
-(void)didAffirmCBAlert;
-(void)didDenyCBAlert;
@end

typedef enum : NSUInteger {
    CBAlertTypeOKOnly,
    CBAlertTypeYesNO,
    CBAlertTypeOKCancel,
} CBAlertType;

typedef enum : NSUInteger {
    CBAlertImageCheck,
    CBAlertImageInformation,
    CBAlertImageWarning,
} CBAlertImage;

@interface CBAlertView : UIView {
    id delegate;
}

@property (nonatomic, strong) UIVisualEffectView *viewBlur;
@property (nonatomic, strong) IBOutlet UIView *viewBottomBar;
@property (nonatomic, strong) IBOutlet UIButton *btnAffirm;
@property (nonatomic, strong) IBOutlet UIButton *btnDeny;
@property (nonatomic, strong) IBOutlet UIButton *btnAcknowledge;
@property (nonatomic, strong) IBOutlet UILabel *lblBody;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;

-(void)setDelegate:(id)newDelegate;
-(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message forAlertType:(CBAlertType)type withCBAlertImage:(CBAlertImage)image forView:(UIView *)parentView;
@end
