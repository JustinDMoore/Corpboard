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
#import "KVNProgress.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"

#import "PrivateView.h"
#import "ChatView.h"

@interface PrivateView() {
    
	NSMutableArray *users;
    NSMutableArray *arrayOfChatsWithUsers;

}

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation PrivateView

@synthesize viewHeader, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_private"]];
		self.tabBarItem.title = @"Private";
	}
	return self;
}

- (void)viewDidLoad {
    
	[super viewDidLoad];
	self.title = @"Private";

	self.tableView.tableHeaderView = viewHeader;
	self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
	users = [[NSMutableArray alloc] init];
    arrayOfChatsWithUsers = [[NSMutableArray alloc] init];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [arrayOfChatsWithUsers removeAllObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];

	if ([PFUser currentUser] != nil) {
        
		[self loadMessages];
	}
	else LoginUser(self);
}

- (void)viewWillDisappear:(BOOL)animated {
    
	[super viewWillDisappear:animated];

	[self searchBarCancelled];
}

#pragma mark - User actions

- (void)actionCleanup {
    
	[users removeAllObjects];
	[self.tableView reloadData];
}

#pragma mark - Backend methods

BOOL isLoading = NO;

-(void)loadMessages {
    
    if (isLoading == NO) {
        [KVNProgress show];
        isLoading = YES;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
        [query whereKey:PF_CHAT_ROOMID containsString:[PFUser currentUser].objectId];
        //[query whereKey:@"user" notEqualTo:[PFUser currentUser].objectId];
        [query whereKey: @"user" notEqualTo: [PFUser currentUser]];
        [query includeKey:@"user"];
        [query orderByDescending:@"updatedAt"];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error == nil) {
                
                [arrayOfChatsWithUsers addObjectsFromArray:objects];
                
            }
            else [KVNProgress showErrorWithStatus:@"Network error"];
            isLoading = NO;
            [self.tableView reloadData];
            [KVNProgress dismiss];
        }];
    }
}

- (void)loadUsers {

	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
	[query orderByAscending:PF_USER_FULLNAME];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
		if (error == nil) {
            
			[users removeAllObjects];
			[users addObjectsFromArray:objects];
			[self.tableView reloadData];
		}
		else [KVNProgress showErrorWithStatus:@"Network error"];
	}];
}

- (void)searchUsers:(NSString *)search_lower {
    
	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
	[query whereKey:PF_USER_FULLNAME_LOWER containsString:search_lower];
	[query orderByAscending:PF_USER_FULLNAME];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
		if (error == nil) {
            
			[users removeAllObjects];
			[users addObjectsFromArray:objects];
			[self.tableView reloadData];
		}
		else [KVNProgress showErrorWithStatus:@"Network error"];
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [arrayOfChatsWithUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PrivateMessageCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }

    PFObject *lastMessage = arrayOfChatsWithUsers[indexPath.row];
    
    UIImageView *imgNew = (UIImageView *)[cell viewWithTag:2];
    UILabel *lblUser = (UILabel *)[cell viewWithTag:3];
    UILabel *lblTimestamp = (UILabel *)[cell viewWithTag:4];
    UILabel *lblLastMessageHidden = (UILabel *)[cell viewWithTag:5];
    lblLastMessageHidden.hidden = YES;
    
    BOOL isRead = [lastMessage[@"read"] boolValue];

    if (!isRead) {
        imgNew.hidden = NO;
    } else {
        imgNew.hidden = YES;
    }
   
    PFUser *user = lastMessage[@"user"];
    lblUser.text = user[@"nickname"];
    [lblUser sizeToFit];
    
    UILabel *lblLastMessage = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 282, 41)];
    lblLastMessage.text = lastMessage[@"lastMessage"];
    lblLastMessage.textColor = [UIColor lightGrayColor];
    lblLastMessage.font = [UIFont systemFontOfSize:14];
    lblLastMessage.numberOfLines = 2;
    [lblLastMessage sizeToFit];
    [cell addSubview:lblLastMessage];
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//	PFUser *user1 = [PFUser currentUser];
//	PFUser *user2 = users[indexPath.row];
//	NSString *id1 = user1.objectId;
//	NSString *id2 = user2.objectId;
//	NSString *roomId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
//
//	CreateMessageItem(user1, roomId, user2[PF_USER_FULLNAME]);
//	CreateMessageItem(user2, roomId, user1[PF_USER_FULLNAME]);
    PFObject *lastMessage = arrayOfChatsWithUsers[indexPath.row];
	ChatView *chatView = [[ChatView alloc] initWith:lastMessage[@"roomId"]];
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
	if ([searchText length] > 0) {
        
		[self searchUsers:[searchText lowercaseString]];
	}
	else [self loadUsers];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_ {
    
	[searchBar_ setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_ {
    
	[searchBar_ setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
	[self searchBarCancelled];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
    
	[searchBar_ resignFirstResponder];
}

- (void)searchBarCancelled {
    
	searchBar.text = @"";
	[searchBar resignFirstResponder];

    
	[self loadUsers];
}

@end
