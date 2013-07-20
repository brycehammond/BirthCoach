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

#define kTopBound 162
#define kBottomBound 368

@interface BCHistoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contractionHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *intensityHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;

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
    
    [self calculateFrequencies];
    
}

- (void)calculateFrequencies
{
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerPanned:)];
    [self.headerContainerView addGestureRecognizer:tapGesture];
    [self.headerContainerView addGestureRecognizer:panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionAdded:) name:kFinishedContractionAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionWillDelete:) name:kContractionWillDeleteNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData
{
    [self.contractionTableView reloadData];
    [self.frequencyTableView reloadData];
}

#pragma mark -
#pragma mark Notification Handling

- (void)contractionAdded:(NSNotification *)note
{
    [self.contractions insertObject:note.userInfo[@"contraction"] atIndex:0];
    [self calculateFrequencies];
    [self.contractionTableView beginUpdates];
    [self.contractionTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.contractionTableView endUpdates];
    [self.frequencyTableView beginUpdates];
    [self.frequencyTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.frequencyTableView endUpdates];
}

- (void)contractionWillDelete:(NSNotification *)note
{
    NSInteger initialFrequencyCount = self.frequencies.count;
    NSInteger contractionIdx = [self.contractions indexOfObject:note.userInfo[@"contraction"]];
    [self.contractions removeObjectAtIndex:contractionIdx];
    [self calculateFrequencies];
    
    [self.contractionTableView beginUpdates];
    [self.contractionTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:contractionIdx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.contractionTableView endUpdates];
    
    if(initialFrequencyCount > 0)
    {
        [self.frequencyTableView beginUpdates];
        [self.frequencyTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:contractionIdx inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.frequencyTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.frequencyTableView endUpdates];
    }
}

#pragma mark -
#pragma mark Gesture Recognizers

- (void)headerTapped:(UITapGestureRecognizer *)gesture
{
    CGFloat newYOrigin = 0;
    if(self.view.frame.origin.y >= kBottomBound)
    {
        newYOrigin = kTopBound;
    }
    else
    {
        newYOrigin = kBottomBound;
    }
    
    CGFloat newViewHeight = [[UIScreen mainScreen] bounds].size.height - newYOrigin - 20;
    
    [UIView animateWithDuration:0 animations:^{
        [self.frequencyTableView setContentOffset:CGPointZero animated:NO];
        [self.contractionTableView setContentOffset:CGPointZero animated:NO];
        [self.view setFrameYOrigin:newYOrigin];
        [self.view setFrameHeight:newViewHeight];
        [self.frequencyTableView setFrameHeight:newViewHeight - self.frequencyTableView.frame.origin.y];
        [self.contractionTableView setFrameHeight:newViewHeight - self.contractionTableView.frame.origin.y];
        
        
    }];
        
}

- (void)headerPanned:(UIPanGestureRecognizer *)gesture
{
    static CGFloat originalGesturePosition = 0;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.frequencyTableView setContentOffset:self.frequencyTableView.contentOffset animated:NO];
        [self.contractionTableView setContentOffset:self.contractionTableView.contentOffset animated:NO];
        originalGesturePosition = self.view.frame.origin.y;
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint yTranslation = [gesture translationInView:self.view];
        CGFloat newYOrigin = originalGesturePosition + yTranslation.y;
        [self.view setFrameYOrigin:newYOrigin];
        CGFloat newViewHeight = [[UIScreen mainScreen] bounds].size.height - newYOrigin - 20;
        
        [self.view setFrameYOrigin:newYOrigin];
        [self.view setFrameHeight:newViewHeight];
        
        [self.view setFrameHeight:newViewHeight];
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [self finishAnimationToBound];
    }
}

- (void)finishAnimationToBound
{
    CGFloat newYOrigin = kTopBound;
    if(fabs(self.view.frame.origin.y - kBottomBound)
       < fabs(self.view.frame.origin.y - kTopBound))
    {
        newYOrigin = kBottomBound;
    }
    
    [UIView animateWithDuration:0 animations:^{
        CGFloat newViewHeight = [[UIScreen mainScreen] bounds].size.height - newYOrigin - 20;
        
        [self.view setFrameYOrigin:newYOrigin];
        [self.view setFrameHeight:newViewHeight];
        [self.frequencyTableView setContentOffset:CGPointZero animated:NO];
        [self.contractionTableView setContentOffset:CGPointZero animated:NO];
    }];
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
    CGFloat currentYOrigin = self.view.frame.origin.y;
    CGFloat newYOrigin = 0;
    
    if(scrollView.contentOffset.y < 0)
    {
        newYOrigin = MIN(kBottomBound, currentYOrigin - scrollView.contentOffset.y);
    }
    else
    {
        newYOrigin = MAX(kTopBound, currentYOrigin - scrollView.contentOffset.y);
    }
    
    CGFloat newViewHeight = [[UIScreen mainScreen] bounds].size.height - newYOrigin - 20;
    
    [self.view setFrameYOrigin:newYOrigin];
    [self.view setFrameHeight:newViewHeight];
    
    [self.view setFrameHeight:newViewHeight];
    
    if(newYOrigin > kTopBound && newYOrigin < kBottomBound)
    {
            self.frequencyTableView.contentOffset = CGPointZero;
            self.contractionTableView.contentOffset = CGPointZero;
            [self.frequencyTableView setFrameHeight:newViewHeight - self.frequencyTableView.frame.origin.y];
            [self.contractionTableView setFrameHeight:newViewHeight - self.contractionTableView.frame.origin.y];
    }
    else
    {
        self.frequencyTableView.contentOffset = scrollView.contentOffset;
        self.contractionTableView.contentOffset = scrollView.contentOffset;
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentYOrigin = self.view.frame.origin.y;
    if(currentYOrigin > kTopBound && currentYOrigin < kBottomBound)
    {
        [self finishAnimationToBound];
    }
}

@end
