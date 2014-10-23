//
//  CBCorpsDetailViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 7/1/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBCorpsDetailViewController.h"

@interface CBCorpsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *corpsName;
@property (weak, nonatomic) IBOutlet UILabel *corpsFrom;
@property (weak, nonatomic) IBOutlet UITextView *corpsShow;
@property (weak, nonatomic) IBOutlet UIButton *btnLink;
@property (weak, nonatomic) IBOutlet UILabel *corpsShowTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCorps;
@property (nonatomic, strong) IBOutlet UILabel *lblChamps;
- (IBAction)openLink:(UIButton*)sender;

@end

@implementation CBCorpsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.corpsName.text = self.corps[@"corpsName"];
    self.corpsFrom.text = self.corps[@"from"];
    self.corpsShow.text = self.corps[@"repertoire"];
    self.imgCorps.image = [UIImage imageNamed:self.corps[@"corpsName"]];
    [self.btnLink setTitle:self.corps[@"website"] forState:UIControlStateNormal];
    self.corpsShowTitle.text = self.corps[@"showTitle"];
    
    self.title = self.corps[@"corpsName"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationItem.title = @"";
    
    self.corpsShow.textColor = [UIColor lightGrayColor];
    self.btnLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.corpsShow flashScrollIndicators];
    
    if (self.corps[@"champs"]) {
        
        self.lblChamps.text = [NSString stringWithFormat:@"%@", self.corps[@"champs"]];
        
        [self.lblChamps sizeToFit];
        
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(30, 10 +self.lblChamps.frame.origin.y + self.lblChamps.frame.size.height) toPointB:CGPointMake(self.view.frame.size.width - 30, 10 +self.lblChamps.frame.origin.y + self.lblChamps.frame.size.height)];
        
        self.corpsShowTitle.frame = CGRectMake(self.corpsShowTitle.frame.origin.x, self.lblChamps.frame.origin.y + self.lblChamps.frame.size.height, self.corpsShowTitle.frame.size.width, self.corpsShowTitle.frame.size.height);
        
    } else {
        
        self.lblChamps.hidden = YES;
        
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(30, 10 +self.btnLink.frame.origin.y + self.btnLink.frame.size.height) toPointB:CGPointMake(self.view.frame.size.width - 30, 10 +self.btnLink.frame.origin.y + self.btnLink.frame.size.height)];
        
        self.corpsShowTitle.frame = CGRectMake(self.corpsShowTitle.frame.origin.x, self.btnLink.frame.origin.y + 30, self.corpsShowTitle.frame.size.width, self.corpsShowTitle.frame.size.height);
    }
    
    self.corpsShow.frame = CGRectMake(self.corpsShow.frame.origin.x, self.corpsShowTitle.frame.origin.y + self.corpsShowTitle.frame.size.height, self.corpsShow.frame.size.width, self.corpsShow.frame.size.height);
    
}

-(void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: pointA];
    [linePath addLineToPoint:pointB];
    line.path=linePath.CGPath;
    line.fillColor = nil;
    line.lineWidth = .5;
    line.opacity = 1.0;
    line.strokeColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:line];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openLink:(UIButton*)sender {
    
    NSString *url = [NSString stringWithFormat:@"http://%@", sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
