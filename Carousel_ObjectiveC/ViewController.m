//
//  ViewController.m
//  Carousel_ObjectiveC
//
//

#import "ViewController.h"
#import "Carousel.h"

@interface ViewController ()
@property (weak, nonatomic) Carousel *carouselView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *imageList = @[@"banner1", @"banner2", @"banner3", @"banner4"];
    NSArray *urlList = @[@"www.google.com", @"chat.openai.com", @"www.apple.com", @"www.android.com"];
    for (int i = 0; i < [imageList count]; i++ ) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: imageList[i], @"image",
                                                                        urlList[i], @"url", nil];
        [mutableArray addObject: dic];
    }
    
    UILabel *title = [[UILabel alloc] init];
    [title setText: @"Carousel Sample"];
    [title sizeToFit];
    [self.view addSubview: title];
    [title setTranslatesAutoresizingMaskIntoConstraints: false];
    UILayoutGuide *guide = self.view.layoutMarginsGuide;
    [title.leadingAnchor constraintEqualToAnchor: guide.leadingAnchor].active = true;
    [title.topAnchor  constraintEqualToAnchor: guide.topAnchor constant: 20].active = true;
    
    UIImage *image = [UIImage imageNamed:@"banner1"];
    CGFloat widthInset = 10;
    CGFloat carouselWidth = (self.view.frame.size.width - widthInset * 2);
    CGFloat carouselHeight = carouselWidth / image.size.width * image.size.height;
    CGRect mFrame = CGRectMake(0, 0, carouselWidth, carouselHeight);

    Carousel *mCrouselView = [[Carousel alloc] initWithFrame: mFrame];
    _carouselView = mCrouselView;
    [_carouselView.layer setCornerRadius: 4];
    [_carouselView.layer setMasksToBounds: true];
    [_carouselView setTranslatesAutoresizingMaskIntoConstraints: false];
    [self.view addSubview: _carouselView];
    [_carouselView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor constant: widthInset].active = true;
    [_carouselView.topAnchor  constraintEqualToAnchor: title.bottomAnchor constant: 20].active = true;
    [_carouselView.widthAnchor constraintEqualToConstant: carouselWidth].active = true;
    [_carouselView.heightAnchor constraintEqualToConstant: carouselHeight].active = true;

    [_carouselView setResourceArray: mutableArray];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapAction:)];
    [_carouselView addGestureRecognizer: tapRecognizer];
}

- (void) tapAction: (UIGestureRecognizer *) gestureRecognizer {

    NSURL *url = [_carouselView getCurrentURL];
    if (url != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL: url options: nil completionHandler: nil];
        });
    }
}

@end
