//
//  CBProblemWhat.m
//  CorpBoard
//
//  Created by Justin Moore on 5/5/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBProblemWhat.h"

@implementation CBProblemWhat

BOOL addingScreenshots = NO;

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showMenu {
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.btnBack.alpha = 1;
                         self.btnSend.alpha = 1;
                         self.lblHeader.alpha = 1;
                     }];
}

-(void)showInParent {

    self.btnBack.alpha = 0;
    self.btnSend.alpha = 0;
    self.lblHeader.alpha = 0;
    
    self.btnSend.enabled = NO;


    [self.txtReportHolder becomeFirstResponder];
    
    self.lblPlaceholder.text = self.where;
    self.txtReportHolder.backgroundColor = [UIColor clearColor];
    self.txtReportHolder.text = @"";
    self.txtReportHolder.placeholder = @"Add an explanation...";
    
    self.txtReportHolder.delegate = self;
    
    NSString *strWhatType;
    if (self.isProblem) {
        strWhatType = @"Problem with ";
    } else {
        strWhatType = @"Incorrect Information in ";
    }
    NSMutableAttributedString *strIn = [[NSMutableAttributedString alloc] initWithString:strWhatType];
    [strIn addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[strIn length])];
    [strIn addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [strIn length])];
    
    NSMutableAttributedString *strWhere = [[NSMutableAttributedString alloc] initWithString:self.where];
    [strWhere addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[strWhere length])];
    [strWhere addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, [strWhere length])];
    
    NSMutableAttributedString *strHyphen = [[NSMutableAttributedString alloc] initWithString:@" –– "];
    [strHyphen addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[strHyphen length])];
    [strHyphen addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [strHyphen length])];
    
    
    NSMutableAttributedString *strfinal = [[NSMutableAttributedString alloc] initWithAttributedString:strIn];
    [strfinal appendAttributedString:strWhere];
    [strfinal appendAttributedString:strHyphen];
    
    self.lblPlaceholder.attributedText = strfinal;
    [self.lblPlaceholder sizeToFit];
    
    [self setViews];
    [self setImageViews];
}

-(void)setViews {
    
    
    self.textViewHeightConstraint.constant = [self.txtReportHolder sizeThatFits:CGSizeMake(self.txtReportHolder.frame.size.width, CGFLOAT_MAX)].height;
    
    //self.txtReportHolder.frame = CGRectMake(self.txtReportHolder.frame.origin.x, self.lblPlaceholder.frame.origin.y + self.lblPlaceholder.frame.size.height + 5, self.txtReportHolder.frame.size.width, newHeight);
    
    self.viewScreenshots.frame = CGRectMake(self.viewScreenshots.frame.origin.x, self.txtReportHolder.frame.origin.y + self.txtReportHolder.frame.size.height + 5, self.viewScreenshots.frame.size.width, self.viewScreenshots.frame.size.height);
    
    self.scrollProblemWhat.contentSize = CGSizeMake(self.scrollProblemWhat.frame.size.width, self.lblPlaceholder.frame.size.height + self.txtReportHolder.frame.size.height + self.viewScreenshots.frame.size.height + 20);
}

#pragma mark
#pragma mark - Actions
#pragma mark
- (IBAction)btnSend_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(sendProblem:withImages:whereAt:)]) {
        
        [delegate sendProblem:self.txtReportHolder.text withImages:self.arrayOfScreenshots whereAt:self.where];
    }
}

- (IBAction)btnBack_tapped:(id)sender {

    addingScreenshots = NO;
    [self.arrayOfScreenshots removeAllObjects];
    if ([delegate respondsToSelector:@selector(backFromProblemWhat)]) {
        [delegate backFromProblemWhat];
    }
}

- (IBAction)btnAddImage_tapped:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 1: if ([self.arrayOfScreenshots count] != 0) return;
            break;
        case 2: if ([self.arrayOfScreenshots count] != 1) return;
            break;
        case 3: if ([self.arrayOfScreenshots count] != 2) return;
            break;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.parent presentViewController:picker animated:YES completion:nil];
}

- (IBAction)btnDeleteImage_tapped:(id)sender {
}

#pragma mark
#pragma mark - UIImagePickerController Delegates
#pragma mark
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.arrayOfScreenshots addObject:image];
    [self setImageViews];
}

#pragma mark
#pragma mark - UITextView Delegate
#pragma mark
CGFloat newHeight;
-(void)textViewDidChange:(UITextView *)textView {
    
    if ([self.txtReportHolder.text length]) {
        self.btnSend.enabled = YES;
    } else {
        self.btnSend.enabled = NO;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    newHeight = newFrame.size.height;
    //self.viewScreenshots.frame = CGRectMake(self.viewScreenshots.frame.origin.x, textView.frame.origin.y + textView.frame.size.height + 5, self.viewScreenshots.frame.size.width, self.viewScreenshots.frame.size.height);
//    textView.scrollEnabled = NO;
    [self setViews];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    //self.lblPlaceholder.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)txtView {
    
    //self.lblPlaceholder.hidden = ([txtView.text length] > 0);
}

-(NSMutableArray *)arrayOfScreenshots {
    if (!_arrayOfScreenshots) {
        _arrayOfScreenshots = [[NSMutableArray alloc] init];
    }
    return _arrayOfScreenshots;
}

-(void)addScreenshots:(id)sender {
    
    if (sender == self.imgView1) {
        if ([self.arrayOfScreenshots count] != 0) return;
    } else if (sender == self.imgView2) {
        if ([self.arrayOfScreenshots count] != 1) return;
    } else if (sender == self.imgView3) {
        if ([self.arrayOfScreenshots count] != 2) return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.parent presentViewController:picker animated:YES completion:nil];
}

-(void)deleteScreenShots:(id)sender {
    if (sender == self.btnDelete1) {
        [self.arrayOfScreenshots removeObjectAtIndex:0];
    } else if (sender == self.btnDelete2) {
        [self.arrayOfScreenshots removeObjectAtIndex:1];
    } else if (sender == self.btnDelete3) {
        [self.arrayOfScreenshots removeObjectAtIndex:2];
    }
    [self setImageViews];
}

-(void)setImageViews {
    
//    self.btnDelete1 = (UIButton *)[self.view1 viewWithTag:7];
//    self.imgView1 = (UIButton *)[self.view1 viewWithTag:8];
//    
//    self.btnDelete2 = (UIButton *)[self.view2 viewWithTag:7];
//    self.imgView2 = (UIButton *)[self.view2 viewWithTag:8];
//    
//    self.btnDelete3 = (UIButton *)[self.view3 viewWithTag:7];
//    self.imgView3 = (UIButton *)[self.view3 viewWithTag:8];
    
    [self.imgView1 addTarget:self action:@selector(addScreenshots:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView2 addTarget:self action:@selector(addScreenshots:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView3 addTarget:self action:@selector(addScreenshots:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnDelete1 addTarget:self action:@selector(deleteScreenShots:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDelete2 addTarget:self action:@selector(deleteScreenShots:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDelete3 addTarget:self action:@selector(deleteScreenShots:) forControlEvents:UIControlEventTouchUpInside];
    
    switch ([self.arrayOfScreenshots count]) {
        case 0:
            self.view1.hidden = NO;
            self.imgView1.hidden = NO;
            self.btnDelete1.hidden = YES;
            [self.imgView1 setImage:[UIImage imageNamed:@"screenshot"] forState:UIControlStateNormal];
            
            self.view2.hidden = YES;
            self.imgView2.hidden = YES;
            self.btnDelete2.hidden = YES;
            
            self.view3.hidden = YES;
            self.imgView3.hidden = YES;
            self.btnDelete3.hidden = YES;
            break;
        case 1:
            self.view1.hidden = NO;
            self.imgView1.hidden = NO;
            self.btnDelete1.hidden = NO;
            [self.imgView1 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:0] forState:UIControlStateNormal];
            
            self.view2.hidden = NO;
            self.imgView2.hidden = NO;
            self.btnDelete2.hidden = YES;
            [self.imgView2 setImage:[UIImage imageNamed:@"screenshot"] forState:UIControlStateNormal];
            
            self.view3.hidden = YES;
            self.imgView3.hidden = YES;
            self.btnDelete3.hidden = YES;
            break;
        case 2:
            self.view1.hidden = NO;
            self.imgView1.hidden = NO;
            self.btnDelete1.hidden = NO;
            [self.imgView1 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:0] forState:UIControlStateNormal];
            
            self.view2.hidden = NO;
            self.imgView2.hidden = NO;
            self.btnDelete2.hidden = NO;
            [self.imgView2 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:1] forState:UIControlStateNormal];
            
            self.view3.hidden = NO;
            self.imgView3.hidden = NO;
            self.btnDelete3.hidden = YES;
            [self.imgView3 setImage:[UIImage imageNamed:@"screenshot"] forState:UIControlStateNormal];
            break;
        case 3:
            self.view1.hidden = NO;
            self.imgView1.hidden = NO;
            self.btnDelete1.hidden = NO;
            [self.imgView1 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:0] forState:UIControlStateNormal];
            
            
            self.view2.hidden = NO;
            self.imgView2.hidden = NO;
            self.btnDelete2.hidden = NO;
            [self.imgView2 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:1] forState:UIControlStateNormal];
            
            self.view3.hidden = NO;
            self.imgView3.hidden = NO;
            self.btnDelete3.hidden = NO;
            [self.imgView3 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:2] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

@end
