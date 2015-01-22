//
//  CBChatMessages.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/1/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBChatMessages.h"

@interface CBChatMessages ()

@end

@implementation CBChatMessages



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.messageView.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MessagesView *)messageView {
    if (!_messageView) {
        [[[NSBundle mainBundle] loadNibNamed:@"MessageView"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
    }
    return _messageView;
}

@end
