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
    self.txtReport.delegate = self;
    self.btnSend.enabled = NO;
    [self.txtReport sizeToFit];
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
-(void)textViewDidChange:(UITextView *)textView {
    
    //self.lblPlaceholder.hidden = ([self.txtReport.text length] > 0);
    
    if ([self.txtReport.text length]) {
        self.btnSend.enabled = YES;
    } else {
        self.btnSend.enabled = NO;
    }
    
//  
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    CGSize maximumSize = CGSizeMake(280,999); //specify width of textView  and maximum height for text to fit in width of textView
    CGSize txtSize = [textView.text sizeWithFont:[UIFont fontWithName:@"Arial" size:16] constrainedToSize:maximumSize lineBreakMode:UILineBreakModeCharacterWrap]; //calulate size of text by specifying font here
    //Add UIViewAnimation here if needed
    [textView setFrame:CGRectMake(textView.frame.origin.x,textView.frame.origin.y,txtSize.width+10,txtSize.height+10)]; // change accordingly
    return YES;
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
