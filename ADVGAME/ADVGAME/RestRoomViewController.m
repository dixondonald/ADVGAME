//
//  RestRoomViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/21/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "RestRoomViewController.h"
#import "GlobalData.h"
@interface RestRoomViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation RestRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![GlobalData globalData].commands) {
        [GlobalData globalData].commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", @"CHECK", @"TALK", @"INVENTORY", @"MOVE", nil];
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rr.jpg"]];
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * .5);
    [self.view addSubview:self.imageView];
    
    self.textView.delegate = self;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * .5, self.view.frame.size.width, self.view.frame.size.height * .2)];
    
    self.textView.text = [GlobalData globalData].startingText;
    
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
    return [GlobalData globalData].currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [[GlobalData globalData].currentArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([GlobalData globalData].currentArray == [GlobalData globalData].commands) {
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
        self.textView.text = @"It's a dirty bathroom. Not much in here besides a toilet and a sink";
        if (![[GlobalData globalData].restroomInvestigates containsObject:@"Toilet"]) {
            [[GlobalData globalData].restroomInvestigates addObject:@"Toilet"];
            [[GlobalData globalData].restroomInvestigates addObject:@"Sink"];
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"CHECK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].restroomInvestigates;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"TALK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].restroomTalks;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"INVENTORY"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].inventory;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"MOVE"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].restroomMoves;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"<"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
        self.textView.text = @"You are in the restroom.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Toilet"]) {
        self.textView.text = @"Yuck. You feel lucky that you don't have to go right now.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Sink"]) {
        self.textView.text = @"It's filthy. There's a cabinet underneath.";
        if (![[GlobalData globalData].restroomInvestigates containsObject:@"Cabinet"]) {
            [[GlobalData globalData].restroomInvestigates addObject:@"Cabinet"];
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Cabinet"]) {
        if ([GlobalData globalData].bugSprayIsTaken == NO) {
        self.textView.text = @"There's some bug spray under the sink.";
            if (![[GlobalData globalData].restroomInvestigates containsObject:@"Bug Spray"]) {
                [[GlobalData globalData].restroomInvestigates addObject:@"Bug Spray"];
            }
        } else {
            self.textView.text = @"It's empty.";
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Bug Spray"]) {
        self.textView.text = @"Hmm. This might come in handy. You take it.";
        [GlobalData globalData].bugSprayIsTaken = YES;
        if (![[GlobalData globalData].inventory containsObject:@"Bug Spray >"]) {
            [[GlobalData globalData].inventory addObject:@"Bug Spray >"];
            [[GlobalData globalData].restroomInvestigates removeObject:@"Bug Spray"];
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Bug Spray >"]) {
        self.textView.text = @"There's nothing to use it on in here.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Crowbar >"]) {
        self.textView.text = @"There's nothing to do with it in here.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Wallet >"]) {
        self.textView.text = @"No reason to take it out here.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }


    if ([cellText isEqualToString:@"Back to Bar"]) {
        [GlobalData globalData].backDoorIsUnlocked = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"restroomBarViewSegue" sender:self];
        });
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restroomBarViewSegue"]) {
        [segue destinationViewController];
        [GlobalData globalData].startingText = @"You leave the restroom and head back into the bar.";
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
