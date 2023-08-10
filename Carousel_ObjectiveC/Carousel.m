//
//  Carousel.m
//  Carousel_ObjectiveC
//
//

#import "Carousel.h"

@interface Carousel ()<UIScrollViewDelegate> {
    int currentIndex;
    CGFloat timerInterval;
    NSTimer *switchPageTimer;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *lastImageView;
@property (strong, nonatomic) UIImageView *nowShowingImageView;
@property (strong, nonatomic) UIImageView *nextImageView;
@property (strong, nonatomic) UIPageControl *dotsPageControl;
@property (nonatomic, retain) NSMutableArray *resourceArray;

@end

@implementation Carousel

#pragma mark - Public
- (id) init {
    
    self = [super init];
    if (self) {
        currentIndex = 0;
        timerInterval = 3.0;
        [self setupScrollView];
    }
    return self;
}

- (id) initWithFrame: (CGRect) frame {
    
    self = [super initWithFrame: frame];
    if (self) {
        currentIndex = 0;
        timerInterval = 3.0;
        [self setupScrollView];
    }
    return self;
}

- (void) setTimerInterval: (CGFloat) time {
    timerInterval = time;
}

- (void) setResourceArray: (NSMutableArray *) data {
    if ([data count] != 0) {
        _resourceArray = data;
        _dotsPageControl.numberOfPages = [_resourceArray count];
        [self reloadImage];
        if ([_resourceArray count] == 1) {
            _scrollView.scrollEnabled = false;
        } else {
            [self setupTimer];
        }
        
    }
}

- (int) getCurrentIndex {
    int count = (int)[_resourceArray count];
    return currentIndex % count;
}

- (void) invalidateTimer {
    [switchPageTimer invalidate];
}

#pragma mark - Private
//- (void) setupScrollView: (CGRect) frame {
//    CGRect mframe = CGRectMake(0, 0, frame.size.width, frame.size.height);
//
//    _scrollView = [[UIScrollView alloc] initWithFrame: mframe];
//    _scrollView.contentSize = CGSizeMake(frameWidth*3, 0);
//    _scrollView.pagingEnabled = YES;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    [self addSubview:  _scrollView];
//
//    _lastImageView = [[UIImageView alloc]initWithFrame:mframe];
//    mframe.origin.x = frameWidth;
//    _nowShowingImageView = [[UIImageView alloc]initWithFrame:mframe];
//    mframe.origin.x = frameWidth * 2;
//    _nextImageView = [[UIImageView alloc]initWithFrame:mframe];
//
//    _lastImageView.backgroundColor = [UIColor redColor];
//    _nowShowingImageView.backgroundColor = [UIColor yellowColor];
//    _nextImageView.backgroundColor = [UIColor greenColor];
//
//
//    _dotsPageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0, mframe.size.height - 35, frameWidth, 35)];
//    _dotsPageControl.backgroundColor = [UIColor clearColor];
//    _dotsPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    _dotsPageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5];
//    _dotsPageControl.currentPage = currentIndex;
//    [self addSubview: _dotsPageControl];
//
//    [_scrollView addSubview: _lastImageView];
//    [_scrollView addSubview: _nowShowingImageView];
//    [_scrollView addSubview: _nextImageView];
//
//}

- (void) setupScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints: false];
    [self addSubview:  _scrollView];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints: false];
    [_scrollView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor].active = true;
    [_scrollView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor].active = true;
    [_scrollView.topAnchor  constraintEqualToAnchor: self.topAnchor].active = true;
    [_scrollView.bottomAnchor  constraintEqualToAnchor: self.bottomAnchor].active = true;
    
    _lastImageView = [[UIImageView alloc]init];
    [_lastImageView setTranslatesAutoresizingMaskIntoConstraints: false];
    [_scrollView addSubview: _lastImageView];
    [_lastImageView.leadingAnchor constraintEqualToAnchor: _scrollView.leadingAnchor].active = true;
    [_lastImageView.topAnchor  constraintEqualToAnchor: self.topAnchor].active = true;
    [_lastImageView.bottomAnchor  constraintEqualToAnchor: self.bottomAnchor].active = true;
    [_lastImageView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = true;

    _nowShowingImageView = [[UIImageView alloc]init];
    [_nowShowingImageView setTranslatesAutoresizingMaskIntoConstraints: false];
    [_scrollView addSubview: _nowShowingImageView];
    [_nowShowingImageView.leadingAnchor constraintEqualToAnchor: _lastImageView.trailingAnchor].active = true;
    [_nowShowingImageView.topAnchor  constraintEqualToAnchor: self.topAnchor].active = true;
    [_nowShowingImageView.bottomAnchor  constraintEqualToAnchor: self.bottomAnchor].active = true;
    [_nowShowingImageView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = true;
    
    _nextImageView = [[UIImageView alloc]init];
    [_nextImageView setTranslatesAutoresizingMaskIntoConstraints: false];
    [_scrollView addSubview: _nextImageView];
    [_nextImageView.leadingAnchor constraintEqualToAnchor: _nowShowingImageView.trailingAnchor].active = true;
    [_nextImageView.topAnchor  constraintEqualToAnchor: self.topAnchor].active = true;
    [_nextImageView.bottomAnchor  constraintEqualToAnchor: self.bottomAnchor].active = true;
    [_nextImageView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = true;

    _dotsPageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0, self.frame.size.height - 35, self.frame.size.width, 35)];
    _dotsPageControl.backgroundColor = [UIColor clearColor];
    _dotsPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _dotsPageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5];
    _dotsPageControl.currentPage = currentIndex;
    [self addSubview: _dotsPageControl];
}

- (void) setupTimer {
    switchPageTimer = [NSTimer timerWithTimeInterval: timerInterval
                                              target: self
                                            selector: @selector(switchPage)
                                            userInfo: nil
                                             repeats: true];
    [[NSRunLoop currentRunLoop] addTimer: switchPageTimer forMode: NSRunLoopCommonModes];
}

- (void) switchPage {
    if ([_resourceArray count] > 1) {
        currentIndex += 1;
        [self reloadImage];
    }
}

- (void) reloadImage {
    int count = (int)[_resourceArray count];
    currentIndex = currentIndex % count;
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated: false];
    int lastOne = (currentIndex - 1 + count) % count;
    _dotsPageControl.currentPage = currentIndex % count;
    int nextOne = (currentIndex + 1) % count;
    [_lastImageView setImage: [UIImage imageNamed: [_resourceArray[lastOne] objectForKey:@"image"]]];
    [_nowShowingImageView setImage: [UIImage imageNamed: [_resourceArray[currentIndex] objectForKey:@"image"]]];
    [_nextImageView setImage: [UIImage imageNamed: [_resourceArray[nextOne] objectForKey:@"image"]]];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *) scrollView {
    if (switchPageTimer) {
        [switchPageTimer invalidate];
        switchPageTimer = nil;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *) scrollView {
    int count = (int)[_resourceArray count];
    
    if (_scrollView.contentOffset.x > self.frame.size.width) {
        currentIndex = (currentIndex + 1) % count;
    } else if (_scrollView.contentOffset.x < self.frame.size.width) {
        currentIndex = (currentIndex - 1 + count) % count;
    }
    
    _dotsPageControl.currentPage = (currentIndex - 1 + count) % count;
    [self reloadImage];
    if (switchPageTimer) {
        [self setupTimer];
    } else {
        [self setupTimer];
    }
}


@end

