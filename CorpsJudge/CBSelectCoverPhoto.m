//
//  CBSelectCoverPhoto.m
//  CorpBoard
//
//  Created by Justin Moore on 12/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBSelectCoverPhoto.h"

@interface CBSelectCoverPhoto ()
@property (strong, nonatomic) IBOutlet UITableView *tablePhotos;
@property (nonatomic, strong) NSMutableArray *arrayOfPhotoObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfPhotos;
@end

@implementation CBSelectCoverPhoto

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tablePhotos.hidden = YES;
    [self getPhotos];
}

int progress = 1;
-(void)getPhotos {
    PFQuery *query = [PFQuery queryWithClassName:@"photos"];
    [query whereKey:@"type" equalTo:@"Cover"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.arrayOfPhotoObjects addObjectsFromArray:objects];
        for (PFObject *obj in objects) {
            PFFile *imgFile = obj[@"photo"];
            PFImageView *imgView = [PFImageView new];
            [imgView setFile:imgFile];
            [imgView loadInBackground:^(UIImage *image, NSError *error) {
                NSLog(@"%i", progress);
                NSLog(@"..%li", [objects count]);
                [self.arrayOfPhotos addObject:imgView];
                if ([self.arrayOfPhotos count] == [objects count]) {
                    self.tablePhotos.hidden = NO;
                    [self.tablePhotos reloadData];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UITableview Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!tableView.hidden)
        return [self.arrayOfPhotoObjects count];
    else
        return 0;
    //if ([self.arrayOfPhotos count]) return [self.arrayOfPhotos count];
    //else return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    
    PFObject *obj = [self.arrayOfPhotoObjects objectAtIndex:indexPath.row];
    PFFile *imgFile = obj[@"photo"];
    PFImageView *imgView = (PFImageView *)[cell viewWithTag:1];
    [imgView setFile:imgFile];
    [imgView loadInBackground];
    imgView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSMutableArray *)arrayOfPhotoObjects {
    if (!_arrayOfPhotoObjects) {
        _arrayOfPhotoObjects = [[NSMutableArray alloc] init];
    }
    return _arrayOfPhotoObjects;
}

-(NSMutableArray *)arrayOfPhotos {
    if (!_arrayOfPhotos) {
        _arrayOfPhotos = [[NSMutableArray alloc] init];
    }
    return _arrayOfPhotos;
}
@end
