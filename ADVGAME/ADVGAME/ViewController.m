//
//  ViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/2/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;


@property (nonatomic, strong) NSArray *currentArray;
@property (strong, nonatomic) NSMutableArray *commands;
@property (strong, nonatomic) NSMutableArray *investigates;

@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imageView;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.investigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];

    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"bg1.png"];
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * .5);
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.imageView.layer.borderWidth = 1;
    [self.view addSubview:self.imageView];

    self.textView.delegate = self;
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(0, self.view.frame.size.height * .5, self.view.frame.size.width, self.view.frame.size.height * .2);
//    self.textView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.textView.layer.borderWidth = 1;
    self.textView.text = @"You are in an alley";
    self.textView.backgroundColor = [UIColor blackColor];
    self.textView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
//    self.mainTableView = [[UITableView alloc] init];
//    self.mainTableView.delegate = self;
//    self.mainTableView.dataSource = self;
    self.mainTableView.frame = CGRectMake(0, self.view.frame.size.height * .7, self.view.frame.size.width, self.view.frame.size.height * .3);
    self.mainTableView.rowHeight = self.mainTableView.frame.size.height / 5;
    self.mainTableView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.mainTableView.layer.borderWidth = 1;
//    [self.view addSubview:self.mainTableView];
    
    self.commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", nil];
    self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];
    self.currentArray = self.commands;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    
    cell.textLabel.text = [self.currentArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];

    if (self.currentArray == self.commands) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[self.cellImages objectAtIndex:indexPath.row]];
        image.frame = CGRectMake(0, 0, self.mainTableView.rowHeight * .75, self.mainTableView.rowHeight * .75);
        cell.accessoryView = image;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    if ([cellText isEqualToString:@"LOOK AROUND"]) {
        self.textView.text = @"Grafitti covers the walls. You see two cars parked nearby";
        if (![self.investigates containsObject:@"Grafitti"]) {
            [self.investigates addObject:@"Grafitti"];
            [self.investigates addObject:@"Cars"];
        }
        if (![self.commands containsObject:@"CHECK"]) {
            [self.commands addObject:@"CHECK"];
        }
        [self.mainTableView reloadData];

    } else if ([cellText isEqualToString:@"CHECK"]) {
        self.currentArray = self.investigates;
        [self.mainTableView reloadData];
    } else if ([cellText isEqualToString:@"<"]) {
        self.currentArray = self.commands;
        [self.mainTableView reloadData];
    } else if ([cellText isEqualToString:@"Grafitti"]) {
        self.textView.text = @"There's a hole in the wall near the center of the artwork";
        if (![self.investigates containsObject:@"Hole"]) {
            [self.investigates addObject:@"Hole"];
            [self.mainTableView reloadData];
        }

        
    }
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
