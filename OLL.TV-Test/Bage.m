//
//  Bage.m
//  OLL.TV-Test
//
//  Created by Viktor on 20/03/17.
//  Copyright © 2017 Viktor. All rights reserved.
//

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#import "Bage.h"

@implementation Bage


- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);
    CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(context);
    
    CGContextSetRGBFillColor(context, 255/255.0, 208/255.0, 71/255.0, 1);
    CGContextFillPath(context);
    
    //
    // Rotate context 45 degrees
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
    CGContextConcatCTM(context, transform1);
    
    // Move context
    CGContextTranslateCTM(context, 16, -13);
    
    // Draw string
    UIFont* font = [UIFont systemFontOfSize:11];
    UIColor* textColor = [UIColor blackColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor };;
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"HD" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.f, 0.f)];
}


@end
