//
//  ViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/2/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "ViewController.h"
#import "GlobalData.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;


@property (nonatomic, strong) NSArray *currentArray;
@property (strong, nonatomic) NSMutableArray *commands;
@property (strong, nonatomic) NSMutableArray *investigates;
@property (strong, nonatomic) NSMutableArray *talks;
@property (strong, nonatomic) NSMutableArray *vagrantTalks;
@property (strong, nonatomic) NSMutableArray *candyBarActions;
@property (strong, nonatomic) NSMutableArray *moves;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;
@property BOOL vagrantIsAwake;
@property BOOL vagrantIsGone;
@property BOOL vagrantHasEaten;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.commands) {
        self.commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", nil];
        self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
        self.currentArray = self.commands;
    }
    
    if (!self.investigates) {
        self.investigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    
    if (!self.talks) {
        self.talks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    
    if (!self.vagrantTalks) {
        self.vagrantTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    
    if (!self.moves) {
        self.moves = [[NSMutableArray alloc] initWithObjects:@"<", nil];
    }
    if (!self.candyBarActions) {
        self.candyBarActions = [[NSMutableArray alloc] initWithObjects:@"<", @"Inspect Candybar", @"Eat Candybar", @"Give Candybar to Vagrant", nil];
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alley.png"]];
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * .5);
    [self.view addSubview:self.imageView];

    self.textView.delegate = self;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * .5, self.view.frame.size.width, self.view.frame.size.height * .2)];
    self.textView.text = @"You wake in an alley. You don't know where you are or how you got here.";
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
    
    if (self.currentArray == self.commands) {
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
        self.textView.text = @"There is a door on one end of the alley and a fence on the other. A vagrant lies sleeping next to a dumpster just a few feet from you.";
        if (![self.investigates containsObject:@"Door"]) {
            [self.investigates addObject:@"Door"];
            [self.investigates addObject:@"Fence"];
            [self.investigates addObject:@"Vagrant"];
            [self.investigates addObject:@"Dumpster"];
        }
        if (![self.commands containsObject:@"CHECK"]) {
            [self.commands addObject:@"CHECK"];
        }
        if (![self.commands containsObject:@"TALK"]) {
            [self.commands addObject:@"TALK"];
        }
        if (![self.talks containsObject:@"Vagrant >"]) {
            [self.talks addObject:@"Vagrant >"];
        }
        if (![self.vagrantTalks containsObject:@"About Door"]) {
            [self.vagrantTalks addObject:@"About Door"];
            [self.vagrantTalks addObject:@"About Fence"];
            [self.vagrantTalks addObject:@"About Himself"];
            [self.vagrantTalks addObject:@"About Dumpster"];
        }

        [self.mainTableView reloadData];
        [self checkForScrolling];
        
    }
    if ([cellText isEqualToString:@"CHECK"]) {
        self.currentArray = self.investigates;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"<"]) {
        self.currentArray = self.commands;
          self.textView.text = @"You are in the alley.";
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Door"]) {
        self.textView.text = @"It's locked. There's a small window above it.";
        if (![self.investigates containsObject:@"Window"]) {
            [self.investigates addObject:@"Window"];
            [self.mainTableView reloadData];
            [self checkForScrolling];
        }
        if (![self.vagrantTalks containsObject:@"About Window"]) {
            [self.vagrantTalks addObject:@"About Window"];
            [self.mainTableView reloadData];
            [self checkForScrolling];
        }
    }
    if ([cellText isEqualToString:@"Fence"]) {
        self.textView.text = @"A large chain with a padlock prevents you from opening it, and barbed wire lines the top. You can see something small on the ground just past the fence.";
    }
    if ([cellText isEqualToString:@"Vagrant"]) {
        if (self.vagrantIsAwake == NO) {
            self.textView.text = @"He's out cold. You nudge him with your foot to no avail.";
        }
        else {
            self.textView.text = @"He's awake now.";
        }
    }
    if ([cellText isEqualToString:@"Dumpster"]) {
        if (self.vagrantIsGone == NO) {
            if (self.vagrantIsAwake == NO) {
                self.vagrantIsAwake = YES;
                self.textView.text = @"You start to open the dumpster, but before you can get a look inside, the smelly vagrant wakes up. \"This is my dumpster! Back off!\"";
            } else {
                self.textView.text = @"\"I won't tell you twice, son.\"";
            }
            
        }
    
    }
    if ([cellText isEqualToString:@"Window"]) {
        self.textView.text = @"It looks big enough to fit through, but it's too high for you to reach.";
        
    }
    if ([cellText isEqualToString:@"TALK"]) {
        self.currentArray = self.talks;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Vagrant >"]) {
        if (self.vagrantIsAwake == YES) {
            if (self.vagrantHasEaten == NO) {
                self.textView.text = @"\"Where'd you come from? Got anything to eat?\"";
            } else {
                self.textView.text = @"\"Hello, again.\"";
            }
            self.currentArray = self.vagrantTalks;
            if (![self.commands containsObject:@"INVENTORY"]) {
                [self.commands addObject:@"INVENTORY"];
                [self.mainTableView reloadData];
                [self checkForScrolling];
            }
            [self.mainTableView reloadData];
            [self checkForScrolling];
        } else {
            self.textView.text = @"No amount of yelling is going to wake this tired bum.";
        }
    }
    if ([cellText isEqualToString:@"About Door"]) {
        self.textView.text = @"\"They only open that door when it's time to take out the trash. They don't like people like us goin' in there anyhow.\"";
    }
    if ([cellText isEqualToString:@"About Window"]) {
        if (self.vagrantHasEaten == NO) {
            self.textView.text = @"\"I guess you could climb inside through there, but you'd never reach it by yourself, heh.\"";
        } else {
            self.textView.text = @"\"I guess I can help up through that window, just let me know when you're ready.\"";
            self.currentArray = self.commands;
            [self.mainTableView reloadData];
            [self checkForScrolling];

            if (![self.commands containsObject:@"MOVE"]) {
                [self.commands addObject:@"MOVE"];
                [self.mainTableView reloadData];
                [self checkForScrolling];
            }
            if (![self.moves containsObject:@"Climb through Window"]) {
                [self.moves addObject:@"Climb through Window"];
                [self.mainTableView reloadData];
                [self checkForScrolling];
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
        self.currentArray = [GlobalData globalData].inventory;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Candybar"]) {
        self.currentArray = self.candyBarActions;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Inspect Candybar"]) {
        self.textView.text = @"It got squished and melted in your pocket.";
        
    }
    if ([cellText isEqualToString:@"Eat Candybar"]) {
        self.textView.text = @"This is a meal that would be hardly fit for a beggar.";
        
    }
    if ([cellText isEqualToString:@"Give Candybar to Vagrant"]) {
        self.vagrantHasEaten = YES;
        self.textView.text = @"The man happily devours the squishy glob of chocolate.";
        self.currentArray = self.commands;
        [self.mainTableView reloadData];
        [self checkForScrolling];
        [[GlobalData globalData].inventory removeObject:@"Candybar"];
    }
    if ([cellText isEqualToString:@"MOVE"]) {
        self.currentArray = self.moves;
        [self.mainTableView reloadData];
        [self checkForScrolling];
    }
    if ([cellText isEqualToString:@"Climb through Window"]) {
        self.textView.text = @"You get a boost from the old man and enter the building.";
        //segue goes here
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
