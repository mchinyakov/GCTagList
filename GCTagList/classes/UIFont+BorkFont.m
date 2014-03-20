//
// Created by Mikhail Chinyakov on 18.02.14.
// Copyright (c) 2014 themakers. All rights reserved.
//

#import "UIFont+BorkFont.h"


@interface UIFont ()

@end

@implementation UIFont (BorkFont)

+ (UIFont *)extraLightBorkFontWithSize:(CGFloat)size
{
    UIFont * font = [UIFont fontWithName:@"FranckerW1G-CondensedXLight"
                                    size:size];
    return font;
}

+ (UIFont *)regularBorkFontWithSize:(CGFloat)size
{
    UIFont * font = [UIFont fontWithName:@"FranckerW1G-CondensedReg"
                                    size:size];
    return font;
}


@end