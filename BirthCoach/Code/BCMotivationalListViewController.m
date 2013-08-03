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
@property (weak, nonatomic) IBOutlet UIButton *editButton;

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

- (IBAction)editPressed:(id)sender
{
    [self.quoteTableView setEditing:! self.quoteTableView.editing animated:YES];
    
    [self.editButton setTitle:self.quoteTableView.editing ? @"Done" : @"Edit" forState:UIControlStateNormal];
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
    cell.showsReorderControl = self.quoteTableView.isEditing;
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    BCMotivationalQuote *quote = self.quotes[sourceIndexPath.row];
    [self.quotes removeObjectAtIndex:sourceIndexPath.row];
    [self.quotes insertObject:quote atIndex:destinationIndexPath.row];
    
    NSUInteger quoteIdx = 1;
    for(BCMotivationalQuote *quoteEntry in self.quotes)
    {
        quoteEntry.position = quoteIdx++; //update all the positions
    }
    
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:nil];
}

#pragma mark -
#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BCMotivationalQuoteEditViewController *editController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"CellPush"])
    {
        NSIndexPath *selectedIndexPath = [self.quoteTableView indexPathForSelectedRow];
        editController.quote = self.quotes[selectedIndexPath.row];
        [self.quoteTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    else if([segue.identifier isEqualToString:@"AddPush"])
    {
        BCMotivationalQuote *newQuote = [BCMotivationalQuote createEntity];
        newQuote.text = @"";
        newQuote.position = 1;
        
        editController.quote = newQuote;
        
        [self.quotes insertObject:newQuote atIndex:0];
        
        NSUInteger quoteIdx = 1;
        for(BCMotivationalQuote *quote in self.quotes)
        {
            quote.position = quoteIdx++;
        }
    }
}

@end
