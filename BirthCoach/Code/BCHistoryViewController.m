//
//  BCHistoryViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/30/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCHistoryViewController.h"
#import "BCContractionCell.h"
#import "BCFrequencyCell.h"
#import "BCContraction.h"

@interface BCHistoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contractionHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *intensityHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyHeaderLabel;

@property (weak, nonatomic) IBOutlet UITableView *contractionTableView;
@property (weak, nonatomic) IBOutlet UITableView *frequencyTableView;

@property (strong, nonatomic) NSMutableArray *contractions;
@property (strong, nonatomic) NSMutableArray *frequencies;

@end

@implementation BCHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupController];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupController];
}

- (void)setupController
{
    self.contractions = [[BCContraction findAllSortedBy:@"endTime" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"endTime != nil"]] mutableCopy];
    
    //go through and calculate all the frequencies
    self.frequencies = [[NSMutableArray alloc] initWithCapacity:self.contractions.count];
    for(BCContraction *contraction in self.contractions)
    {
        NSTimeInterval frequency = contraction.frequency;
        if(frequency > 0)
        {
            [self.frequencies addObject:@(frequency)];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.contractionHistoryLabel.font = [UIFont fontWithName:@"SourceSansPro-Black" size:self.contractionHistoryLabel.font.pointSize];
    
    for(UILabel *headerLabel in @[self.durationHeaderLabel, self.intensityHeaderLabel, self.frequencyHeaderLabel])
    {
        headerLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:headerLabel.font.pointSize];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate/Datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.contractionTableView)
    {
        BCContractionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractionCell"];
        [cell setContraction:self.contractions[indexPath.row]];
        
        return cell;
    }
    else
    {
        if(0 == indexPath.section || 2 == indexPath.section)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PseudoHeader"];
            return cell;
        }
        else
        {
            BCFrequencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FrequencyCell"];
            [cell setFrequency:self.frequencies[indexPath.row]];
            
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.contractionTableView)
    {
        return self.contractions.count;
    }
    else
    {
        if(0 == section || 2 == section)
        {
            return 1;
        }
        else
        {
            return self.frequencies.count;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.frequencyTableView)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.frequencyTableView && (indexPath.section == 0 || indexPath.section == 2))
    {
        return 27;
    }

    return 54;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.frequencyTableView.contentOffset = scrollView.contentOffset;
    self.contractionTableView.contentOffset = scrollView.contentOffset;
}

@end
