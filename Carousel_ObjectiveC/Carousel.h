//
//  Carousel.h
//  Carousel_ObjectiveC
//
//

#ifndef Carousel_h
#define Carousel_h

#import <UIKit/UIKit.h>

@interface Carousel : UIView <UIScrollViewDelegate>

- (void) setTimerInterval: (CGFloat) time;
- (void) setResourceArray: (NSMutableArray *) data;
- (int) getCurrentIndex;
- (NSURL *) getCurrentURL;
- (void) invalidateTimer;
@end

#endif /* Carousel_h */
