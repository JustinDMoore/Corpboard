//
//  CBProblemWhat.m
//  CorpBoard
//
//  Created by Justin Moore on 5/5/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBProblemWhat.h"

@implementation CBProblemWhat

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

-(void)showInParent {

    //self.txtReport.backgroundColor = [UIColor whiteColor];
    self.txtReport.text = @"";
    //self.txtReport.placeholder = @"Add an explanation";
    //self.txtReport.placeholderColor = [UIColor lightGrayColor];
    //self.txtReport.delegate = self;
    self.btnSend.enabled = NO;

    
    
    self.txtReport = [[HPGrowingTextView alloc] initWithFrame:self.txtReportHolder.frame];
    self.txtReportHolder.hidden = YES;
    self.txtReport.minNumberOfLines = 1;
    [self.scrollProblemWhat addSubview:self.txtReport];
    [self.txtReport becomeFirstResponder];
    
    
    NSMutableAttributedString *strAddAnExplanation = [[NSMutableAttributedString alloc] initWithString:@"Add an explanation"];
    [strAddAnExplanation addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,[strAddAnExplanation length])];
    [strAddAnExplanation addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [strAddAnExplanation length])];

    
    NSMutableAttributedString *strHyphen = [[NSMutableAttributedString alloc] initWithString:@" –– in "];
    [strHyphen addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[strHyphen length])];
    [strHyphen addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [strHyphen length])];
    
    NSMutableAttributedString *strWhere = [[NSMutableAttributedString alloc] initWithString:self.where];
    [strWhere addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[strWhere length])];
    [strWhere addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, [strWhere length])];

    NSMutableAttributedString *strfinal = [[NSMutableAttributedString alloc] initWithAttributedString:strAddAnExplanation];
    [strfinal appendAttributedString:strHyphen];
    [strfinal appendAttributedString:strWhere];
    
    self.lblPlaceholder.attributedText = strfinal;
    [self.lblPlaceholder sizeToFit];
    
    [self setViews];
}

-(void)setViews {
    
    self.txtReport.frame = CGRectMake(self.txtReport.frame.origin.x, self.lblPlaceholder.frame.origin.y + self.lblPlaceholder.frame.size.height + 5, self.txtReport.frame.size.width, newHeight);
    
    self.viewScreenshots.frame = CGRectMake(self.viewScreenshots.frame.origin.x, self.txtReport.frame.origin.y + self.txtReport.frame.size.height + 5, self.viewScreenshots.frame.size.width, self.viewScreenshots.frame.size.height);
    
    self.scrollProblemWhat.contentSize = CGSizeMake(self.scrollProblemWhat.frame.size.width, self.lblPlaceholder.frame.size.height + self.txtReport.frame.size.height + self.viewScreenshots.frame.size.height + 20);
}

#pragma mark
#pragma mark - Actions
#pragma mark
- (IBAction)btnSend_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(sendProblem:withImages:)]) {
        [delegate sendProblem:self.txtReport.text withImages:self.arrayOfScreenshots];
    }
}

- (IBAction)btnBack_tapped:(id)sender {

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
}

#pragma mark
#pragma mark - UITextView Delegate
#pragma mark
CGFloat newHeight;
-(void)textViewDidChange:(UITextView *)textView {
    
    //self.lblPlaceholder.hidden = ([self.txtReport.text length] > 0);
    
    if ([self.txtReport.text length]) {
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
    textView.scrollEnabled = NO;
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

@end
