//
//  BarViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "BarViewController.h"
#import "GlobalData.h"
#import <AVFoundation/AVFoundation.h>

@interface BarViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic, strong) AVAudioPlayer *clickSound;
@property (nonatomic, strong) NSURL *clickFile;

@property(nonatomic, strong) AVAudioPlayer *bgSound;
@property (nonatomic, strong) NSURL *bgFile;

@end

@implementation BarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![GlobalData globalData].commands) {
        [GlobalData globalData].commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", @"CHECK", @"TALK", @"INVENTORY", @"MOVE", nil];
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inside.jpg"]];
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
    
    self.bgFile = [[NSBundle mainBundle] URLForResource:@"barSound"
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.mainTableView reloadData];
    [self checkForScrolling];

    if ([cellText isEqualToString:@"LOOK AROUND"]) {
        self.textView.text = @"You are standing in a bar. There's a front door, a back door, and a restroom. The bartender is cleaning glasses. There's noone else is the bar.";
        if (![[GlobalData globalData].barInvestigates containsObject:@"Bartender"]) {
            [[GlobalData globalData].barInvestigates addObject:@"Bartender"];
        }
        if (![[GlobalData globalData].barTalks containsObject:@"Bartender >"]) {
            [[GlobalData globalData].barTalks addObject:@"Bartender >"];
        }
        if (![[GlobalData globalData].barMoves containsObject:@"Front Door"]) {
            [[GlobalData globalData].barMoves addObject:@"Front Door"];
            [[GlobalData globalData].barMoves addObject:@"Back Door"];
            [[GlobalData globalData].barMoves addObject:@"Restroom"];
        }
    }
    if ([cellText isEqualToString:@"CHECK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].barInvestigates;
    }
    if ([cellText isEqualToString:@"TALK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].barTalks;
    }
    if ([cellText isEqualToString:@"INVENTORY"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].inventory;
    }
    if ([cellText isEqualToString:@"MOVE"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].barMoves;
    }
    if ([cellText isEqualToString:@"<"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
        self.textView.text = @"You are in the bar.";
    }
    if ([cellText isEqualToString:@"Bartender"]) {
        self.textView.text = @"He's a big guy. He seems vaguely familiar.";
    }
    if ([cellText isEqualToString:@"Bartender >"]) {
        self.textView.text = @"\"Hey, pal, didn't see you come in. You feelin' okay today? You got pretty hammered last night. You should be home sleeping.\"";
        if (![[GlobalData globalData].bartenderTalks containsObject:@"About Last Night"]) {
            [[GlobalData globalData].bartenderTalks addObject:@"About Last Night"];
        }
        [GlobalData globalData].currentArray = [GlobalData globalData].bartenderTalks;
    }
    if ([cellText isEqualToString:@"About Restroom"]) {
        self.textView.text = @"\"Oh yeah, you gotta jiggle the handle to get it open.\"";
        [GlobalData globalData].restroomIsUnlocked = YES;
    }
    if ([cellText isEqualToString:@"About Last Night"]) {
        self.textView.text = @"\"You were drinking a lot, buddy. Something about your girlfriend I think. The next thing I knew, you were gone.\"";
    }
    if ([cellText isEqualToString:@"About Vagrant"]) {
        if ([GlobalData globalData].vagrantIsGone == NO) {
            self.textView.text = @"\"I can't get rid of that guy. He's like a cockroach.\"";
        } else {
            self.textView.text = @"\"He just came running through here. What did you do to him?\"";
        }
    }
    if ([cellText isEqualToString:@"About Cab Sign"]) {
        if ([GlobalData globalData].tabIsPaid == NO) {
            self.textView.text = @"\"I could call you a cab, but you never paid your tab last night.\"";
            [GlobalData globalData].tabIsKnown = YES;
        } else {
        self.textView.text = @"\"I'll call you cab. Go home and get sleep.\"";
        [GlobalData globalData].cabIsHere = YES;
        }
    }

    if ([cellText isEqualToString:@"Bug Spray >"]) {
        self.textView.text = @"There's nothing to use it on in here.";
    }
    if ([cellText isEqualToString:@"Crowbar >"]) {
        self.textView.text = @"There's nothing to do with it in here.";
    }
    if ([cellText isEqualToString:@"Wallet >"]) {
        if ([GlobalData globalData].tabIsKnown == NO) {
            self.textView.text = @"There's no reason to take it out right now.";
        } else {
            [GlobalData globalData].currentArray = [GlobalData globalData].walletActions;
        }
    }
    if ([cellText isEqualToString:@"Pay Tab"]) {
        self.textView.text = @"\"Well, I guess miracles do happen.\".";
        [GlobalData globalData].tabIsPaid = YES;
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    }
    if ([cellText isEqualToString:@"Back Door"]) {
        [GlobalData globalData].backDoorIsUnlocked = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"alleyViewSegue" sender:self];
        });
    }
    if ([cellText isEqualToString:@"Front Door"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"streetViewSegue" sender:self];
        });
    }
    if ([cellText isEqualToString:@"Restroom"]) {
        if ([GlobalData globalData].restroomIsUnlocked == NO) {
            self.textView.text = @"The door won't open.";
            if (![[GlobalData globalData].bartenderTalks containsObject:@"About Restroom"]) {
                [[GlobalData globalData].bartenderTalks addObject:@"About Restroom"];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"restroomViewSegue" sender:self];
            });
        }
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.bgSound stop];

    if ([segue.identifier isEqualToString:@"alleyViewSegue"]) {
        [segue destinationViewController];
        [GlobalData globalData].startingText = @"You go through the back door into the alley, making sure it's unlocked.";
    }
    if ([segue.identifier isEqualToString:@"streetViewSegue"]) {
        [segue destinationViewController];
        [GlobalData globalData].startingText = @"You go through the front door and out into the street.";
    }
    if ([segue.identifier isEqualToString:@"restroomViewSegue"]) {
        [segue destinationViewController];
        [GlobalData globalData].startingText = @"You jiggle the handle and enter the restroom.";
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
