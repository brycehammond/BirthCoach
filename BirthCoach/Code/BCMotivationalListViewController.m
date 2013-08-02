//
//  BCMotivationalListViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 7/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCMotivationalListViewController.h"
#import "BCMotivationalQuote+Convenience.h"
#import "BCSettingsTitleCell.h"
#import "BCMotivationalQuoteEditViewController.h"

@interface BCMotivationalListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;

@property (nonatomic, strong) NSMutableArray *quotes;

@end

@implementation BCMotivationalListViewController

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
    self.quoteTableView.backgroundColor = [UIColor colorWithHexString:kLightOrangeColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.quotes = [BCMotivationalQuote findAllSortedBy:@"position" ascending:YES].mutableCopy;
    [self.quoteTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate/Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BCSettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
    cell.titleLabel.text = [self.quotes[indexPath.row] text];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BCMotivationalQuote *quote = self.quotes[indexPath.row];
        [self.quotes removeObjectAtIndex:indexPath.row];
        [quote deleteEntity];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -
#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BCMotivationalQuoteEditViewController *editController = segue.destinationViewController;
    NSIndexPath *selectedIndexPath = [self.quoteTableView indexPathForSelectedRow];
    editController.quote = self.quotes[selectedIndexPath.row];
    [self.quoteTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

@end
