//
//  BCMotivationalQuoteEditViewController.m
//  BirthCoach
//
//  Created by Bryce Hammond on 8/2/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCMotivationalQuoteEditViewController.h"
#import "BCMotivationalQuote.h"

@interface BCMotivationalQuoteEditViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BCMotivationalQuoteEditViewController

@synthesize quote = _quote;

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
	self.textView.text = self.quote.text;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    self.quote.text = self.textView.text;
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    [super backButtonPressed:sender];
}

@end
