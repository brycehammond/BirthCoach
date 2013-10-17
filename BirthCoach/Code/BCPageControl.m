//
//  BCPageControl.m
//  BirthCoach
//
//  Created by Bryce Hammond on 6/29/13.
//  Copyright (c) 2013 Fluidvision Design, LLC. All rights reserved.
//

#import "BCPageControl.h"

@interface BCPageControl ()

@property (nonatomic, strong) NSMutableArray *tapViews;

@end

@implementation BCPageControl

@synthesize numberOfPages, hidesForSinglePage, currentPage;
@synthesize dotSize = _dotSize;
@synthesize dotSpacing = _dotSpacing;
@synthesize currentSelectedPage = _currentSelectedPage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupView];
}

- (void)setupView
{
    self.tapViews = [[NSMutableArray alloc] init];
    self.hidesForSinglePage = NO;
    _dotSize = 10;
    _dotSpacing = 8;
}

- (void)drawRect:(CGRect)rect {
    
    [self clearTapViews];
    
    UIColor *activePageColor = [UIColor colorWithHexString:kMidGreenColor];
    UIColor *inactivePageColor = [[UIColor colorWithHexString:kMidGreenColor] colorWithAlphaComponent:0.15];
    
	if (hidesForSinglePage == NO || [self numberOfPages] > 1){
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		float dotSize = _dotSize;
		
		float offset = 5;
		
		for (NSInteger i = 1; i <= [self numberOfPages]; i++){
			if (i == [self currentSelectedPage]){
                CGContextSetStrokeColorWithColor(context, [activePageColor CGColor]);
				CGContextSetFillColorWithColor(context, [activePageColor CGColor]);
			} else {
                CGContextSetStrokeColorWithColor(context, [inactivePageColor CGColor]);
				CGContextSetFillColorWithColor(context, [inactivePageColor CGColor]);
			}
			
            CGRect dotRect = CGRectMake(offset + (dotSize + _dotSpacing) * (i - 1), floor((self.frame.size.height / 2) - (dotSize / 2)), dotSize, dotSize);
            
            CGContextStrokeEllipseInRect(context, dotRect);
            CGContextFillEllipseInRect(context, dotRect);
            
            //add a tapview
            UIView *tapView = [[UIView alloc] initWithFrame:dotRect];
            tapView.backgroundColor = [UIColor grayColor];
            tapView.alpha = 0.02;
            [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotTapped:)]];
            [self addSubview:tapView];
            [self.tapViews addObject:tapView];
		}
	}
}

- (void)clearTapViews
{
    for(UIView *tapView in self.tapViews)
    {
        [tapView removeFromSuperview];
    }
    
    [self.tapViews removeAllObjects];
}

- (void)dotTapped:(UITapGestureRecognizer *)tapRecognizer
{
    NSInteger tappedPage = [self.tapViews indexOfObject:tapRecognizer.view] + 1;
    if(tappedPage != self.currentPage)
    {
        self.currentSelectedPage = tappedPage;
        [self.delegate pageControl:self didSelectPage:tappedPage];
    }
}

- (void)setCurrentSelectedPage:(NSInteger)currentSelectedPage
{
    _currentSelectedPage = currentSelectedPage;
    [self setNeedsDisplay];
}

- (void)setDotSpacing:(float)dotSpacing
{
    _dotSpacing = dotSpacing;
    [self setNeedsDisplay];
}


@end
