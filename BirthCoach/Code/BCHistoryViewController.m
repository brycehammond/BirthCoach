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

#define kHeaderHeight 40

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

//animating
@property (strong, nonatomic) UIDynamicAnimator *animator;

//contraction editing
@property (weak, nonatomic) IBOutlet UIView *contractionSlideOut;
@property (weak, nonatomic) IBOutlet UIView *contractionIntensityContainerView;
@property (assign, nonatomic) CGFloat slideOutOffset;
@property (weak, nonatomic) IBOutlet UIImageView *selectedContractionHandle;
@property (assign, nonatomic) NSInteger selectedContractionRow;

@end

@implementation BCHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)calculateFrequencies
{
    //go through and calculate all the frequencies
    self.frequencies = [[NSMutableArray alloc] initWithCapacity:self.contractions.count];
    for(BCContraction *contraction in self.contractions)
    {
        NSTimeInterval frequency = contraction.frequency;
        [self.frequencies addObject:@(frequency)];
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
    
    self.slideOutOffset = self.contractionSlideOut.frame.origin.y;
    
    UITapGestureRecognizer *handleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedContractionHandleTapped:)];
    UIPanGestureRecognizer *handlePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selectedContractionHandlePanned:)];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectedContractionSwiped:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.selectedContractionHandle addGestureRecognizer:handleTapGesture];
    [self.selectedContractionHandle addGestureRecognizer:handlePanGesture];
    [self.contractionSlideOut addGestureRecognizer:swipeGesture];
    
    if(self.contractions.count > 0)
    {        
        //start by selecting the first row
        [self selectContractionIndex:0];
        self.selectedContractionRow = 0;
    }
    else
    {
        [self.contractionSlideOut setFrameXOrigin:kSliderHiddenXCoordinate];
    }
    
    for(UIButton *intensityButton in self.contractionIntensityContainerView.subviews)
    {
        intensityButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:intensityButton.titleLabel.font.pointSize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractionAdded:) name:kFinishedContractionAddedNotification object:nil];
    self.contractions = [[BCContraction findAllSortedBy:@"endTime" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"endTime != nil"]] mutableCopy];
    
    [self calculateFrequencies];
    
    [self.frequencyTableView reloadData];
    [self.contractionTableView reloadData];
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

- (void)moveToBottomBound
{
    [self moveToYCoordinate:kHistoryViewBottomBound];
}

- (void)moveToTopBound
{
    [self moveToYCoordinate:kHistoryViewTopBound];
}

- (void)moveToYCoordinate:(CGFloat)yCoordinate
{
    [self.view setFrameYOrigin:yCoordinate];
    [self.frequencyTableView setContentOffset:CGPointZero animated:NO];
    [self.contractionTableView setContentOffset:CGPointZero animated:NO];
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
    
    if(self.frequencies.count > 0)
    {
        [self.frequencyTableView beginUpdates];
        [self.frequencyTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.frequencyTableView endUpdates];
    }
    
    [self selectContractionIndex:0];
    [self moveHandleToIndex:0];
    
    
}

- (void)deleteContractionAtIndex:(NSInteger)contractionIdx
{
    if(contractionIdx < self.contractions.count)
    {
        NSInteger initialFrequencyCount = self.frequencies.count;
        BCContraction *contraction = [self.contractions objectAtIndex:contractionIdx];
        [self.contractions removeObjectAtIndex:contractionIdx];
        [contraction deleteEntity];
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        
        [self calculateFrequencies];
        
        [self.contractionTableView beginUpdates];
        [self.contractionTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:contractionIdx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.contractionTableView endUpdates];
        
        if(initialFrequencyCount > 0)
        {
            [self.frequencyTableView beginUpdates];
            if(contractionIdx > 0)
            {
                [self.frequencyTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:contractionIdx - 1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self.frequencyTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.frequencyTableView endUpdates];
        }
        
        
        
        if(contractionIdx > 0)
        {
            [self selectContractionIndex:contractionIdx - 1];
            [self moveHandleToIndex:contractionIdx - 1];
            self.selectedContractionRow -= 1;
            
        }
        else
        {
            [self moveHandleToIndex:0];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kContractionDeletedNotification object:self userInfo:nil];
    }
    
}

#pragma mark -
#pragma mark Gesture Handling

- (void)selectedContractionHandleTapped:(UITapGestureRecognizer *)tapGesture
{
    [self toggleSelectedContractionSliderState:YES];
}

- (void)toggleSelectedContractionSliderState:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        if(self.contractionSlideOut.frame.origin.x >= 0)
        {
            [self.contractionSlideOut setFrameXOrigin:kSliderThumbShownXCoordinate];
        }
        else
        {
            [self.contractionSlideOut setFrameXOrigin:kSliderShownXCoordinate];
        }
    }];
}

- (void)selectedContractionHandlePanned:(UIPanGestureRecognizer *)panGesture
{
    static CGFloat originalGesturePosition = 0;
    static CGFloat lastGesturePosition = 0;
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        originalGesturePosition = self.contractionSlideOut.frame.origin.x;
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGesture translationInView:self.view];
        lastGesturePosition = originalGesturePosition + translation.x;
        [self.contractionSlideOut setFrameXOrigin:lastGesturePosition];
    }
    else
    {
        //get velocity to complete at that velocity or distance based velocity (if they are moving slowly)
        CGPoint velocity = [panGesture velocityInView:self.view];
        CGFloat newFrameXOrigin = 0;
        CGFloat durationByVelocity = 0;
        CGFloat durationByDistance = 0;
        
        if(lastGesturePosition >= originalGesturePosition)
        {
            //moving to the right so complete
            newFrameXOrigin = 0;
            durationByVelocity = (self.contractionSlideOut.bounds.size.width - [self.contractionSlideOut rightBorderXValue]) / velocity.x;
            durationByDistance = ((self.contractionSlideOut.bounds.size.width - [self.contractionSlideOut rightBorderXValue]) / self.contractionSlideOut.bounds.size.width) * 0.3;
        }
        else
        {
            //moving to the left
            newFrameXOrigin = kSliderThumbShownXCoordinate;
            durationByVelocity = [self.contractionSlideOut rightBorderXValue] / velocity.x;
            durationByDistance = [self.contractionSlideOut rightBorderXValue] / self.contractionSlideOut.bounds.size.width * 0.3;
        }
        
        [UIView animateWithDuration:MIN(durationByDistance, durationByVelocity) animations:^{
            [self.contractionSlideOut setFrameXOrigin:newFrameXOrigin];
        }];
    }
}

- (void)selectedContractionSwiped:(UISwipeGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.contractionSlideOut setFrameXOrigin:kSliderThumbShownXCoordinate];
    }];
}

#pragma mark -
#pragma mark Gesture Recognizers

- (void)headerTapped:(UITapGestureRecognizer *)gesture
{
    CGFloat newYOrigin = 0;
    if(self.view.frame.origin.y >= kHistoryViewBottomBound)
    {
        newYOrigin = kHistoryViewTopBound;
    }
    else
    {
        newYOrigin = kHistoryViewBottomBound;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.frequencyTableView setContentOffset:CGPointZero animated:NO];
        [self.contractionTableView setContentOffset:CGPointZero animated:NO];
        [self.view setFrameYOrigin:newYOrigin];
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
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [self finishAnimationToBound];
    }
}

- (void)finishAnimationToBound
{
    CGFloat newYOrigin = kHistoryViewTopBound;
    if(fabs(self.view.frame.origin.y - kHistoryViewBottomBound)
       < fabs(self.view.frame.origin.y - kHistoryViewTopBound))
    {
        newYOrigin = kHistoryViewBottomBound;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrameYOrigin:newYOrigin];
        [self.frequencyTableView setContentOffset:CGPointZero animated:NO];
        [self.contractionTableView setContentOffset:CGPointZero animated:NO];
    }];
}

#pragma mark -
#pragma mark Contraction Editing

- (void)deleteLastContraction
{
    [self deleteContractionAtIndex:0];
}

- (IBAction)deleteSelectedContraction:(id)sender
{
    
    [self deleteContractionAtIndex:self.selectedContractionRow];

}

- (IBAction)selectedContractionIntensityPressed:(UIButton *)sender
{
    
    BCContraction *contraction = self.contractions[self.selectedContractionRow];
    contraction.intensity = @([sender titleForState:UIControlStateNormal].intValue);
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.selectedContractionRow inSection:0];
    
    [self.contractionTableView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.contractionTableView selectRowAtIndexPath:currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    for(UIButton *intensityButton in self.contractionIntensityContainerView.subviews)
    {
        intensityButton.enabled = [intensityButton titleForState:UIControlStateNormal].intValue != contraction.intensity.intValue;
    }
    
    [self toggleSelectedContractionSliderState:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kContractionEditedNotification object:self userInfo:@{ @"contraction" : contraction }];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *lookupPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    
    [self moveHandleToIndex:lookupPath.row];
    
    [self selectContractionIndex:lookupPath.row];
    
    self.selectedContractionRow = indexPath.row;
}

- (void)moveHandleToIndex:(NSInteger)contractionIndex
{
    CGRect cellRect = [self.contractionTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:contractionIndex inSection:0]];
    CGPoint newOffset = CGPointMake(MAX(kSliderThumbShownXCoordinate, self.contractionSlideOut.frameXOrigin), cellRect.origin.y - self.contractionTableView.contentOffset.y + 5 + kHeaderHeight);
    [UIView animateWithDuration:0.3 animations:^{
        [self.contractionSlideOut setFrameOrigin:newOffset];
    }];
    
    self.slideOutOffset = newOffset.y + self.contractionTableView.contentOffset.y;
}

- (void)selectContractionIndex:(NSInteger)contractionIdx
{
    [self.contractionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:contractionIdx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if(contractionIdx < self.frequencies.count )
    {
        [self.frequencyTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:contractionIdx inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        [self.frequencyTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedContractionRow inSection:1] animated:YES];
    }
    
    BCContraction *selectedContraction = self.contractions[contractionIdx];
    
    for(UIButton *intensityButton in self.contractionIntensityContainerView.subviews)
    {
        intensityButton.enabled = [intensityButton titleForState:UIControlStateNormal].intValue != selectedContraction.intensity.intValue;
    }
}

- (void)hideSlider
{
    [self.contractionSlideOut setFrameXOrigin:kSliderHiddenXCoordinate];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentYOrigin = self.view.frame.origin.y;
    CGFloat newYOrigin = 0;
    
    if(scrollView.contentOffset.y < 0)
    {
        newYOrigin = MIN(kHistoryViewBottomBound, currentYOrigin - scrollView.contentOffset.y);
    }
    else
    {
        newYOrigin = MAX(kHistoryViewTopBound, currentYOrigin - scrollView.contentOffset.y);
    }
    
    self.view.frameYOrigin = newYOrigin;
    
    if(newYOrigin > kHistoryViewTopBound && newYOrigin < kHistoryViewBottomBound)
    {
            self.frequencyTableView.contentOffset = CGPointZero;
            self.contractionTableView.contentOffset = CGPointZero;
    }
    else
    {
        self.frequencyTableView.contentOffset = scrollView.contentOffset;
        self.contractionTableView.contentOffset = scrollView.contentOffset;
    }
    
    [self.contractionSlideOut setFrameYOrigin:self.slideOutOffset - scrollView.contentOffset.y];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentYOrigin = self.view.frame.origin.y;
    if(currentYOrigin > kHistoryViewTopBound && currentYOrigin < kHistoryViewBottomBound)
    {
        [self finishAnimationToBound];
    }
}

#pragma mark -
#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ContractionEdit"])
    {
        BCContractionEditViewController *editController = segue.destinationViewController;
        editController.contraction = self.contractions[[self.contractionTableView indexPathForSelectedRow].row];
        editController.delegate = self;
    }
}

#pragma mark -
#pragma mark BCContractionEditViewController 

- (void)contractionEditViewController:(BCContractionEditViewController *)controller didFinishWithSave:(BOOL)saved
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self toggleSelectedContractionSliderState:YES];
    }];
}

@end
