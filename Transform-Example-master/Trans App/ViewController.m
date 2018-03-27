#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redBox;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(CGFloat)distanceBetweenPoints:(CGPoint) pt1 and:(CGPoint) pt2
{
    CGFloat distance;
    
    CGFloat xDifferenceSquared = pow(pt1.x - pt2.x, 2);
    CGFloat yDifferenceSquared = pow(pt1.y - pt2.y, 2);
    distance = sqrt(xDifferenceSquared + yDifferenceSquared);
    
    return distance;
}


-(CGAffineTransform)transformWithScale:(CGAffineTransform)oldTransform and:(UITouch *) touch1 and:(UITouch *)touch2
{
    
    CGPoint touch1Location = [touch1 locationInView:nil];
    CGPoint touch1PreviousLocation = [touch1 previousLocationInView:nil];
    CGPoint touch2Location = [touch2 locationInView:nil];
    CGPoint touch2PreviousLocation = [touch2 previousLocationInView:nil];
    
    CGFloat distance = [self distanceBetweenPoints:touch1Location
                                               and:touch2Location];
    
    CGFloat prevDistance = [self distanceBetweenPoints:touch1PreviousLocation
                                                   and:touch2PreviousLocation];
    
    CGFloat scaleRatio = distance / prevDistance;
    
    CGAffineTransform newTransform = CGAffineTransformScale(oldTransform, scaleRatio, scaleRatio);
    
    return newTransform;
}

CGAffineTransform transformWithRotation(CGAffineTransform oldTransform,
                                        UITouch *touch,
                                        UIView *view,
                                        id superview)
{
    CGPoint pt1 = [touch locationInView:superview];
    CGPoint pt2 = [touch previousLocationInView:superview];
    CGPoint center = view.center;
    CGFloat angle1 = atan2( center.y - pt2.y, center.x - pt2.x );
    CGFloat angle2 = atan2( center.y - pt1.y, center.x - pt1.x );
    
    CGAffineTransform newTransform = CGAffineTransformRotate(oldTransform, angle2-angle1);
    
    return newTransform;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    
    if ([[allTouches allObjects] count] == 1)
    {
        UITouch *touch  = [[[event touchesForView:_redBox] allObjects] objectAtIndex:0];
        self.redBox.transform = transformWithRotation(_redBox.transform,touch,_redBox,self.view);
    }
    else if ([[allTouches allObjects] count] == 2)
    {
        UITouch *touch1  = [[[event touchesForView:_redBox] allObjects]
                            objectAtIndex:0];
        UITouch *touch2 = [[[event touchesForView:_redBox] allObjects]
                           objectAtIndex:1];
        
        _redBox.transform = [self transformWithScale:_redBox.transform and:touch1 and:touch2];
    }
}

@end
