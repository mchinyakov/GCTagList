//
// Created by Mikhail Chinyakov on 18.02.14.
// Copyright (c) 2014 themakers. All rights reserved.
//

#import <Foundation/Foundation.h>

enum BorkFontStyle
{
    Regular,
    Semibold,
    Light,
    XLigth
};

@interface UIFont (BorkFont)

+(UIFont *)extraLightBorkFontWithSize:(CGFloat) size;
+(UIFont *)regularBorkFontWithSize:(CGFloat) size;

@end