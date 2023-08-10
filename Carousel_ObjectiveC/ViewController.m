//
//  ViewController.m
//  Carousel_ObjectiveC
//
//

#import "ViewController.h"
#import "Carousel.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *imageList = @[@"banner1", @"banner2", @"banner3", @"banner4"];
    NSArray *urlList = @[@"www.google.com", @"chat.openai.com", @"www.apple.com", @"www.android.com"];
    //[imageList count]
    for (int i = 0; i < 1; i++ ) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: imageList[i], @"image",
                                                                        urlList[i], @"url", nil];
        [mutableArray addObject: dic];
    }
//    NSLog(@"%@", mutableArray);
    
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

    Carousel *carouselView = [[Carousel alloc] initWithFrame: mFrame];
    carouselView.layer.cornerRadius = 4;
    carouselView.layer.masksToBounds = true;
    [carouselView setTranslatesAutoresizingMaskIntoConstraints: false];
    [self.view addSubview: carouselView];
    [carouselView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor constant: widthInset].active = true;
    [carouselView.topAnchor  constraintEqualToAnchor: title.bottomAnchor constant: 20].active = true;
    [carouselView.widthAnchor constraintEqualToConstant: carouselWidth].active = true;
    [carouselView.heightAnchor constraintEqualToConstant: carouselHeight].active = true;

    [carouselView setResourceArray: mutableArray];
    
//    CGRect mframe = CGRectMake(0, 0, 300, 168);
//    UIImageView *lastImageView = [[UIImageView alloc]initWithFrame:mframe];
//    [self.view addSubview: lastImageView];
//    [lastImageView setImage:[UIImage imageNamed:@"banner1"]];
    
}


@end
