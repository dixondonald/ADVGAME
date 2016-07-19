//
//  ViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/2/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "ViewController.h"
#import "GlobalData.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic, strong) AVAudioPlayer *clickSound;
@property (nonatomic, strong) NSURL *clickFile;

@property(nonatomic, strong) AVAudioPlayer *bgSound;
@property (nonatomic, strong) NSURL *bgFile;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.cellImages) {
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
    }
    [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    
   
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alley.jpg"]];
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

    self.bgFile = [[NSBundle mainBundle] URLForResource:@"alleySound"
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
        if ([GlobalData globalData].vagrantIsGone == NO) {
            self.textView.text = @"There is a door on one end of the alley and a fence on the other. A vagrant lies sleeping next to a dumpster just a few feet from you. Is it morning?";
            if (![[GlobalData globalData].alleyInvestigates containsObject:@"Door"]) {
                [[GlobalData globalData].alleyInvestigates addObject:@"Door"];
                [[GlobalData globalData].alleyInvestigates addObject:@"Fence"];
                [[GlobalData globalData].alleyInvestigates addObject:@"Vagrant"];
                [[GlobalData globalData].alleyInvestigates addObject:@"Dumpster"];
                if (![[GlobalData globalData].alleyTalks containsObject:@"Vagrant >"]) {
                    [[GlobalData globalData].alleyTalks addObject:@"Vagrant >"];
                }
            }
            if (![[GlobalData globalData].commands containsObject:@"CHECK"]) {
                [[GlobalData globalData].commands addObject:@"CHECK"];
            }
            if (![[GlobalData globalData].commands containsObject:@"TALK"]) {
                [[GlobalData globalData].commands addObject:@"TALK"];
            }
            if (![[GlobalData globalData].vagrantTalks containsObject:@"About Door"]) {
                [[GlobalData globalData].vagrantTalks addObject:@"About Door"];
                [[GlobalData globalData].vagrantTalks addObject:@"About Fence"];
                [[GlobalData globalData].vagrantTalks addObject:@"About Himself"];
                [[GlobalData globalData].vagrantTalks addObject:@"About Dumpster"];
            }
            if (![[GlobalData globalData].bartenderTalks containsObject:@"About Vagrant"]) {
                [[GlobalData globalData].bartenderTalks addObject:@"About Vagrant"];
            }
        } else {
             self.textView.text = @"The vagrant is gone. It's just you and the dumpster.";
        }
        
    }
    if ([cellText isEqualToString:@"CHECK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].alleyInvestigates;
    
    }
    if ([cellText isEqualToString:@"<"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
          self.textView.text = @"You are in the alley.";
    
    }
    if ([cellText isEqualToString:@"Door"]) {
        if ([GlobalData globalData].backDoorIsUnlocked == YES) {
            self.textView.text = @"You unlocked it from inside.";
        } else {
            self.textView.text = @"It's locked. There's a small window above it.";
            if (![[GlobalData globalData].alleyInvestigates containsObject:@"Window"]) {
                [[GlobalData globalData].alleyInvestigates addObject:@"Window"];
            }
            if (![[GlobalData globalData].vagrantTalks containsObject:@"About Window"]) {
                [[GlobalData globalData].vagrantTalks addObject:@"About Window"];
            }
        }
    }
    if ([cellText isEqualToString:@"Fence"]) {
        if ([GlobalData globalData].fenceIsOpen == NO) {
            self.textView.text = @"A large chain with a padlock prevents you from opening it, and barbed wire lines the top. It looks like a wallet is on the other side on the ground.";
            if (![[GlobalData globalData].alleyInvestigates containsObject:@"Wallet"]) {
                [[GlobalData globalData].alleyInvestigates addObject:@"Wallet"];
            }
        } else {
            self.textView.text = @"You broke the lock and the fence is now open. There's a wallet on the ground a few feet past the gate.";
            if (![[GlobalData globalData].alleyInvestigates containsObject:@"Wallet"]) {
                [[GlobalData globalData].alleyInvestigates addObject:@"Wallet"];
            }
        }
    }
    if ([cellText isEqualToString:@"Vagrant"]) {
        if ([GlobalData globalData].vagrantIsAwake == NO) {
            self.textView.text = @"He's out cold. You nudge him with your foot to no avail.";
        }
        else {
            self.textView.text = @"He's awake now.";
        }
    }
    if ([cellText isEqualToString:@"Dumpster"]) {
        if ([GlobalData globalData].vagrantIsGone == NO) {
            if ([GlobalData globalData].vagrantIsAwake == NO) {
                [GlobalData globalData].vagrantIsAwake = YES;
                self.textView.text = @"You start to open the dumpster, but before you can get a look inside, the smelly vagrant wakes up. \"This is my dumpster! Back off!\"";
            } else {
                self.textView.text = @"\"I won't tell you twice, son.\"";
            }
        } else {
            self.textView.text = @"With the vagrant gone, you rummage through the dumpster. You find a crowbar below a load of garbage and you take it.";
            [[GlobalData globalData].alleyInvestigates removeObject:@"Dumpster"];
            [[GlobalData globalData].inventory addObject:@"Crowbar >"];
        }
    }
    if ([cellText isEqualToString:@"Wallet"]) {
        if ([GlobalData globalData].fenceIsOpen == NO) {
            self.textView.text = @"You can't get to it.";
            } else {
            self.textView.text = @"Hey, this is your wallet! It looks like everything is still there.";
            [[GlobalData globalData].alleyInvestigates removeObject:@"Wallet"];
            [[GlobalData globalData].inventory addObject:@"Wallet >"];
        }
    }
    if ([cellText isEqualToString:@"Window"]) {
        if ([GlobalData globalData].backDoorIsUnlocked == YES) {
            self.textView.text = @"You climbed through it once already.";
        } else {
            self.textView.text = @"It looks big enough to fit through, but it's too high for you to reach.";
        }
    }
    if ([cellText isEqualToString:@"TALK"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].alleyTalks;
    }
    if ([cellText isEqualToString:@"Vagrant >"]) {
        if ([GlobalData globalData].vagrantIsAwake == YES) {
            if ([GlobalData globalData].vagrantHasEaten == NO) {
                self.textView.text = @"\"Where'd you come from? Got anything to eat?\"";
            } else {
                self.textView.text = @"\"Hello, again.\"";
            }
            [GlobalData globalData].currentArray = [GlobalData globalData].vagrantTalks;
            if (![[GlobalData globalData].commands containsObject:@"INVENTORY"]) {
                [[GlobalData globalData].commands addObject:@"INVENTORY"];
            }

        } else {
            self.textView.text = @"No amount of yelling is going to wake this tired bum.";
        }
    }
    if ([cellText isEqualToString:@"About Door"]) {
        if ([GlobalData globalData].backDoorIsUnlocked == YES) {
            self.textView.text = @"\"You got it open, so what. I ain't leavin this spot.\"";
        } else {
            self.textView.text = @"\"They only open that door when it's time to take out the trash. They don't like people like us goin' in there anyhow.\"";
        }
    }
    if ([cellText isEqualToString:@"About Window"]) {
        if ([GlobalData globalData].backDoorIsUnlocked == YES) {
            self.textView.text = @"\"Pulled my groin when I helped you up there.\"";
        } else if ([GlobalData globalData].vagrantHasEaten == NO) {
            self.textView.text = @"\"I guess you could climb inside through there, but you'd never reach it by yourself, heh.\"";
        } else {
            self.textView.text = @"\"I guess I can help up through that window, just let me know when you're ready.\"";
            [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    
            if (![[GlobalData globalData].commands containsObject:@"MOVE"]) {
                [[GlobalData globalData].commands addObject:@"MOVE"];
            }
            if (![[GlobalData globalData].alleyMoves containsObject:@"Climb through Window"]) {
                [[GlobalData globalData].alleyMoves addObject:@"Climb through Window"];
            }
        }
    }
    if ([cellText isEqualToString:@"About Fence"]) {
        self.textView.text = @"\"Can't go in the door, can't get through the fence. But I got everything I need right here.\" The old man points to the dumpster.";
    }
    if ([cellText isEqualToString:@"About Himself"]) {
        self.textView.text = @"\"I been livin' in this alley for a while now. Never seen you around before though.\"";
    }
    if ([cellText isEqualToString:@"About Dumpster"]) {
        self.textView.text = @"\"Hands off, if you wanna keep your fingers.\"";
    }
    if ([cellText isEqualToString:@"INVENTORY"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].inventory;
    }
    if ([cellText isEqualToString:@"Candybar >"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].candyBarActions;
    }
    if ([cellText isEqualToString:@"Inspect Candybar"]) {
        self.textView.text = @"It got squished and melted in your pocket.";
    }
    if ([cellText isEqualToString:@"Eat Candybar"]) {
        self.textView.text = @"This is a meal that would be hardly fit for a beggar.";
    }
    if ([cellText isEqualToString:@"Give Candybar to Vagrant"]) {
        [GlobalData globalData].vagrantHasEaten = YES;
        self.textView.text = @"The man happily devours the squishy glob of chocolate.";
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    
        [[GlobalData globalData].inventory removeObject:@"Candybar >"];
    }
    if ([cellText isEqualToString:@"Bug Spray >"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].bugSprayActions;
    }
    if ([cellText isEqualToString:@"Use Bug Spray on Vagrant"]) {
        [GlobalData globalData].vagrantIsGone = YES;
        [[GlobalData globalData].alleyInvestigates removeObject:@"Vagrant"];
        [[GlobalData globalData].alleyTalks removeObject:@"Vagrant >"];
        [[GlobalData globalData].inventory removeObject:@"Bug Spray >"];

        self.textView.text = @"The old man screams like a banshee and vanishes through the back door into the bar.";
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
    }
    if ([cellText isEqualToString:@"Crowbar >"]) {
        if ([GlobalData globalData].fenceIsOpen == NO) {
            [GlobalData globalData].currentArray = [GlobalData globalData].crowbarActions;
        } else {
            self.textView.text = @"You already opened the fence.";
        }
    }
    if ([cellText isEqualToString:@"Use Crowbar on Fence"]) {
        [GlobalData globalData].fenceIsOpen = YES;
        [GlobalData globalData].currentArray = [GlobalData globalData].commands;
        [[GlobalData globalData].crowbarActions removeObject:@"Use Crowbar on Fence"];
        self.textView.text = @"The lock easily falls off when you apply the crowbar to it.";
    }
    if ([cellText isEqualToString:@"Wallet >"]) {
        self.textView.text = @"Best to keep it your pocket in case that bum shows back up.";
    }

    if ([cellText isEqualToString:@"MOVE"]) {
        [GlobalData globalData].currentArray = [GlobalData globalData].alleyMoves;
    }
    if ([cellText isEqualToString:@"Climb through Window"]) {
        [[GlobalData globalData].alleyMoves removeObject:@"Climb through Window"];
        [[GlobalData globalData].alleyMoves addObject:@"Back Door"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"barViewSegue" sender:self];
        });
    }
    if ([cellText isEqualToString:@"Back Door"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"barViewSegue" sender:self];
        });
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.bgSound stop];

    if ([segue.identifier isEqualToString:@"barViewSegue"]) {
        [segue destinationViewController];
        if ([GlobalData globalData].backDoorIsUnlocked == NO) {
            [GlobalData globalData].startingText = @"The old man boosts you up and you crawl through the window.";
        } else {
        [GlobalData globalData].startingText = @"You go back into the bar.";
        }
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
    // Dispose of any resources that can be recreated.
}

@end
