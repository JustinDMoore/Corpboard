//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"

#import "GroupView.h"
#import "ChatView.h"

#import "LiveChatCell.h"
#import "JSQMessagesTimestampFormatter.h"
#import "NSDate+Utilities.h"

#import "KVNProgress.h"
#import "IQKeyboardManager.h"

@interface GroupView() {
    
	NSMutableArray *chatrooms;
    UIRefreshControl *refreshControl;
    
}
@end

@implementation GroupView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		//[self.tabBarItem setImage:[UIImage imageNamed:@"tab_group"]];
		self.tabBarItem.title = @"Live Chat";
	}
	return self;
}

- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatNameCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"LiveChatCell"];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
	self.title = @"Live Chat";

	self.tableView.separatorInset = UIEdgeInsetsZero;

	chatrooms = [[NSMutableArray alloc] init];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [self refreshTableAndOpenRecent:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *addBtnImg = [UIImage imageNamed:@"Add"];
    [addBtn setBackgroundImage:addBtnImg forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(actionNew) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addBtn] ;
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

	if ([PFUser currentUser] != nil) {
        
		[self refreshTableAndOpenRecent:NO];
	}
	else LoginUser(self);
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - User actions

- (void)actionNew {
    
    [self toggleSubviews:NO];
    [self.navigationController.view addSubview:self.viewNewChat];
    [self.viewNewChat showInParent:self.view.frame];
}

- (void)refreshTableAndOpenRecent:(BOOL)open {
    
    [KVNProgress show];
    
	PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:@"lastMessageDate"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil) {
            
			[chatrooms removeAllObjects];
			for (PFObject *object in objects) {
                
				[chatrooms addObject:object];
			}
            [KVNProgress dismiss];
            [refreshControl endRefreshing];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
			//[self.tableView reloadData];
            if (open) {
                if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
		}
        else [KVNProgress showErrorWithStatus:@"Network error"];
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [chatrooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LiveChatCell";
    LiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.lblLastUser.text = @"";
    cell.lblLastUserHowLongAgo.text = @"";
    cell.lblNumberOfMessagesAndViews.text = @"";
    cell.lblStartedByUserAndWhen.text = @"";
    
    PFObject *chatroom = chatrooms[indexPath.row];
    PFUser *lastUser = chatroom[@"lastUser"];

    NSString *d = [[JSQMessagesTimestampFormatter sharedFormatter] timeForDate:chatroom[@"lastMessageDate"]];
    NSDate *updated = chatroom[@"lastMessageDate"];
    
    int diff = (int)[updated minutesBeforeDate:[NSDate date]];
    
    NSString *timeDiff;
    if (diff < 3) {
        timeDiff = @"Just Now";
    } else if (diff <= 50) {
        timeDiff = [NSString stringWithFormat:@"%i min ago", diff];
    } else if ((diff > 50) && (diff < 65)) {
        timeDiff = @"An hour ago";
    } else {
        if ([updated isYesterday]) timeDiff = @"Yesterday";
        if ([updated daysBeforeDate:[NSDate date]] == 2) {
            timeDiff = @"2 days ago";
        } else {
            if ([updated isToday]) {
                timeDiff = d;
            }
        }
    }
    
    cell.lblLastUserHowLongAgo.text = timeDiff;
   
    [lastUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *imgFile = lastUser[@"picture"];
            [cell.imgLastUser setFile:imgFile];
            [cell.imgLastUser loadInBackground];
            cell.lblLastUser.text = lastUser[@"nickname"];
            cell.lblStartedByUserAndWhen.text = [NSString stringWithFormat:@"by %@", lastUser[@"nickname"]];
        } else {
            NSLog(@"Error loading user image for chat room - %@", error.userInfo);
        }
    }];
    
    int views = [chatroom[@"numberOfViews"] intValue];
    int messages = [chatroom[@"numberOfMessages"] intValue];
    NSString *m;
    if (messages == 1) {
        m = @"message";
    } else {
        m = @"messages";
    }
    
    NSString *v;
    if (views == 1) {
        v = @"view";
    } else {
        v = @"views";
    }
    
    cell.lblNumberOfMessagesAndViews.text = [NSString stringWithFormat:@"%i %@ - %i %@", views, v, messages, m];

    cell.lblChatName.text = chatroom[PF_CHATROOMS_NAME];
    cell.lblChatName.numberOfLines = 3;
    [cell.lblChatName sizeToFit];
    
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 104;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 104;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	PFObject *chatroom = chatrooms[indexPath.row];
	NSString *roomId = chatroom.objectId;
    
    int numViews = [chatroom[@"numberOfViews"] intValue];
    numViews++;
    chatroom[@"numberOfViews"] = [NSNumber numberWithInt:numViews];
    [chatroom saveInBackground];

	CreateMessageItem([PFUser currentUser], nil, roomId, chatroom[PF_CHATROOMS_NAME]);

    roomIdForChat = roomId;
//  ChatView *chatView = [[ChatView alloc] initWith:roomId];
//  chatView.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"chat" sender:self];
//  [self.navigationController pushViewController:chatView animated:YES];
}

NSString *roomIdForChat;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"chat"]) {
        
        ChatView *vc = [segue destinationViewController];
        [vc setRoomId:roomIdForChat];
        vc.isPrivate = NO;
        vc.user2 = nil;
        if ([msg length]) { //this sends the initial message to the chat
            [vc sendMessage:msg Picture:nil];
            msg = nil;
        }
    }
}

-(CBNewChatView *)viewNewChat {
    
    if (!_viewNewChat) {
        
        _viewNewChat =
        [[[NSBundle mainBundle] loadNibNamed:@"CBNewChatView"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_viewNewChat setDelegate:self];
    }
    return _viewNewChat;
}

-(void)toggleSubviews:(BOOL)enableInteraction {
    
    self.view.userInteractionEnabled = enableInteraction;
    for (UIView *view in [self.view subviews]) {
        [view setUserInteractionEnabled:enableInteraction];
    }
}

-(void)newChatCancelled {
    
    [self toggleSubviews:YES];
    self.viewNewChat = nil;
}

NSString *msg;

-(void)newChatWithTopic:(NSString *)topic withMessage:(NSString *)message {
    
    [self toggleSubviews:YES];
    self.viewNewChat = nil;
    
    msg = message;
    
    PFObject *object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_NAME];
    object[PF_CHATROOMS_NAME] = topic;
    object[@"user"] = [PFUser currentUser];
    object[@"lastUser"] = [PFUser currentUser];
    object[@"lastMessageDate"] = [NSDate date];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
         if (error == nil) {
             
             [self refreshTableAndOpenRecent:YES];
         }
         else [KVNProgress showErrorWithStatus:@"Network error"];
     }];
}

@end
