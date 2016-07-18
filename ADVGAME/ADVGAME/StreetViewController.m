//
//  StreetViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/21/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "StreetViewController.h"
#import "GlobalData.h"
#import <AVFoundation/AVFoundation.h>

@interface StreetViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic, strong) AVAudioPlayer *clickSound;
@property (nonatomic, strong) NSURL *clickFile;

@property(nonatomic, strong) AVAudioPlayer *bgSound;
@property (nonatomic, strong) NSURL *bgFile;

@end

@implementation StreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![GlobalData globalData].commands) {
        [GlobalData globalData].commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", @"CHECK", @"TALK", @"INVENTORY", @"MOVE", nil];
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"front.jpg"]];
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
    
    self.clickFile = [[NSBundle mainBundle] URLForResource:@"click"
                                             withExtension:@"mp3"];
    self.clickSound = [[AVAudioPlayer alloc] initWithContentsOfURL:self.clickFile
                                                             error:nil];
    self.clickSound.volume = .5;
    self.clickSound.numberOfLoops = 0;
    
    self.bgFile = [[NSBundle mainBundle] URLForResource:@"streetSound"
                                          withExtension:@"m4a"];
    self.bgSound = [[AVAudioPlayer alloc] initWithContentsOfURL:self.bgFile
                                                          error:nil];
    self.bgSound.volume = .5;
    self.bgSound.numberOfLoops = -1;
    [self.bgSound play];

    
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
    [self.clickSound play];

    if ([cellText isEqualToString:@"LOOK AROUND"]) {
        if ([GlobalData globalData].cabIsHere == NO) {
            self.textView.text = @"You are outside of the bar, on the street. There's noone around. You see a sign for cab company on a street pole.";
            if (![[GlobalData globalData].streetInvestigates containsObject:@"Cab Sign"]) {
                [[GlobalData globalData].streetInvestigates addObject:@"Cab Sign"];
            }
            if (![[GlobalData globalData].bartenderTalks containsObject:@"About Cab Sign"]) {
                [[GlobalData globalData].bartenderTalks addObject:@"About Cab Sign"];
            }
        } else {
            self.textView.text = @"The cab has just pulled up.";
            if (![[GlobalData globalData].streetMoves containsObject:@"Get into Cab"]) {
                [[GlobalData globalData].streetMoves addObject:@"Get into Cab"];
            }
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"CHECK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].streetInvestigates;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"TALK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].streetTalks;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"INVENTORY"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].inventory;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"MOVE"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].streetMoves;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"<"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
        self.textView.text = @"You are out front of the bar.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Cab Sign"]) {
        self.textView.text = @"It's not much more than a picture of cab, but there aren't any around right now.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Get into Cab"]) {
        self.textView.text = @"You climb into the cab and tell the driver where you live. You made it!";
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
        if ([GlobalData globalData].tabIsKnown == NO) {
            self.textView.text = @"There's no reason to take it out right now.";
        } else {
            [GlobalData globalData].currentArray = [GlobalData globalData].walletActions;
        }
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }


    if ([cellText isEqualToString:@"Back inside Bar"]) {
        [GlobalData globalData].backDoorIsUnlocked = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"streetBarViewSegue" sender:self];
        });
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.bgSound stop];

    if ([segue.identifier isEqualToString:@"streetBarViewSegue"]) {
        [segue destinationViewController];
        [GlobalData globalData].startingText = @"You go back into the bar.";
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
