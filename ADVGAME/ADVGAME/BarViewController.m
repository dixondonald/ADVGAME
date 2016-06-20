//
//  BarViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "BarViewController.h"
#import "GlobalData.h"
@interface BarViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSArray *currentArray;
@property (strong, nonatomic) NSMutableArray *barcommands;
@property (strong, nonatomic) NSMutableArray *investigates;
@property (strong, nonatomic) NSMutableArray *talks;
@property (strong, nonatomic) NSMutableArray *moves;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;


@end

@implementation BarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.barcommands) {
        self.barcommands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", @"CHECK", @"TALK", @"INVENTORY", @"MOVE", nil];
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
        self.currentArray = self.barcommands;
    }
    if (!self.investigates) {
        self.investigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    if (!self.talks) {
        self.talks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    if (!self.moves) {
        self.moves = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inside.png"]];
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * .5);
    [self.view addSubview:self.imageView];
    
    self.textView.delegate = self;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * .5, self.view.frame.size.width, self.view.frame.size.height * .2)];
    self.textView.text = self.startingText;
    self.textView.backgroundColor = [UIColor blackColor];
    self.textView.textColor = [UIColor whiteColor];
    [self.textView setFont:[UIFont systemFontOfSize:15]];
    [self.textView setEditable:NO];
    [self.textView setUserInteractionEnabled:NO];
    [self.view addSubview:self.textView];
    
    self.mainTableView.frame = CGRectMake(0, self.view.frame.size.height * .7, self.view.frame.size.width, self.view.frame.size.height * .3);
    self.mainTableView.rowHeight = self.mainTableView.frame.size.height / 5.5;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [self.currentArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.currentArray == self.barcommands) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[self.cellImages objectAtIndex:indexPath.row]];
        image.frame = CGRectMake(0, 0, self.mainTableView.rowHeight * .75, self.mainTableView.rowHeight * .75);
        cell.accessoryView = image;
    } else {
        cell.accessoryView = nil;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    if ([cellText isEqualToString:@"LOOK AROUND"]) {
        self.textView.text = @"You are standing in a bar. There's a front door, a back door, and a restroom. ";
        if (![self.moves containsObject:@"Front Door"]) {
            [self.moves addObject:@"Front Door"];
            [self.moves addObject:@"Back Door"];
            [self.moves addObject:@"Restroom"];
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"CHECK"]) {
        self.currentArray = self.investigates;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"TALK"]) {
        self.currentArray = self.talks;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"INVENTORY"]) {
        self.currentArray = [GlobalData globalData].inventory;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"MOVE"]) {
        self.currentArray = self.moves;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"<"]) {
        self.currentArray = self.barcommands;
        self.textView.text = @"You are in the bar.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Back Door"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"alleyViewSegue" sender:self];
        });
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"alleyViewSegue"]) {
        NSLog(@"segue");
        ViewController *alleyVC =
        [segue destinationViewController];
        alleyVC.startingText = @"You go through the back door into the alley, making sure it's unlocked.";
    }
}


- (void) checkForScrolling {
    if (self.mainTableView.contentSize.height < self.mainTableView.frame.size.height) {
        self.mainTableView.scrollEnabled = NO;
    }
    else {
        self.mainTableView.scrollEnabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
