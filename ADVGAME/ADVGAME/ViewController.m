//
//  ViewController.m
//  ADVGAME
//
//  Created by Ziggy on 6/2/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSArray *commands;
@property (strong, nonatomic) NSArray *cellImages;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * .5);
//    self.imageView.frame = CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.height * .2, 0, self.view.frame.size.height * .4, self.view.frame.size.height * .4);
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.imageView.layer.borderWidth = 1;

    
    self.textView.frame = CGRectMake(0, self.view.frame.size.height * .5, self.view.frame.size.width, self.view.frame.size.height * .15);
    self.textView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.textView.layer.borderWidth = 1;
    
    self.mainTableView.frame = CGRectMake(0, self.view.frame.size.height * .7, self.view.frame.size.width, self.view.frame.size.height * .3);
    self.mainTableView.rowHeight = self.mainTableView.frame.size.height / 5;
    self.mainTableView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.mainTableView.layer.borderWidth = 1;
    
    self.commands = [[NSArray alloc] initWithObjects:@"OBSERVE", @"INVESTIGATE", @"QUESTION", @"INVENTORY", @"RELOCATE", nil];
    self.cellImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"eye.png"], [UIImage imageNamed:@"magnifier.png"], [UIImage imageNamed:@"mouth.png"],  [UIImage imageNamed:@"briefcase.png"], [UIImage imageNamed:@"arrows.png"],nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"cellID"
                                    forIndexPath:indexPath];
    
    long row = [indexPath row];
    cell.textLabel.text = [self.commands objectAtIndex:row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];

    
    UIImageView *image = [[UIImageView alloc] initWithImage:[self.cellImages objectAtIndex:row]];
    image.frame = CGRectMake(0, 0, self.mainTableView.rowHeight * .75, self.mainTableView.rowHeight * .75);
    cell.accessoryView = image;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSLog(@"%@", cellText);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
