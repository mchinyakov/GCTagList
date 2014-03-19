//
//  ViewController.m
//  GCTagList
//
//  Created by Green on 13/2/27.
//  Copyright (c) 2013年 greenchiu. All rights reserved.
//

#import "ViewController.h"
#import "GCTagList.h"
#import "BorkColor.h"
#import "UIFont+BorkFont.h"

#define ARY @[@"ЛУК-ПОРЕЙ", @"ЖЕМЧУЖНЫЙ ЛУК", @"САЛАТНЫЙ ЛУК", @"Gina Sun", @"Jeremy Chang", @"Sandra Hsu"]

@interface ViewController () <GCTagListDataSource, GCTagListDelegate>
@property (nonatomic, retain) NSMutableArray* tagNames;
@end

@implementation ViewController

- (void)loadView {
    self.tagNames = [NSMutableArray arrayWithArray:ARY];
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     * the firstRowLeftMargin default is zero.
     * the xib did not support the inspector to set custom view's property, so 
     * if you need this setting, set it and call reloadData after.
     */
    self.nibTagList.firstRowLeftMargin = 30.f;
    
    /*
    GCTagList* taglist = [[[GCTagList alloc] initWithFrame:CGRectMake(0, 180, 320, 200)] autorelease];
    taglist.firstRowLeftMargin = 80.f;
    taglist.delegate = self;
    taglist.dataSource = self;
    [self.view addSubview:taglist];
    [taglist reloadData];
     */
}

- (NSInteger)numberOfTagLabelInTagList:(GCTagList *)tagList {
    return self.tagNames.count;
}

- (GCTagLabel*)tagList:(GCTagList *)tagList tagLabelAtIndex:(NSInteger)index {
    
    static NSString* identifier = @"TagLabelIdentifier";
    
    GCTagLabel* tag = [tagList dequeueReusableTagLabelWithIdentifier:identifier];
    
    if(!tag)
        tag = [GCTagLabel tagLabelWithReuseIdentifier:identifier];
    
    NSString* labelText = self.tagNames[index];

    [tag setLabelText:labelText
        accessoryType:GCTagLabelAccessoryCustom
             textFont:[UIFont extraLightBorkFontWithSize:20.0f]];
    [tag setCustomAccessoryImage:[UIImage imageNamed:@"add_icon"]
                      withInsets:UIEdgeInsetsMake(0, 10, 0, 0)
                         andSize:11.0f];
    //set inactive tag style
    [tag setTagBackgroundColor:[UIColor blackColor]
       andLabelBackgroundColor:[UIColor clearColor]
            withLabelTextColor:[UIColor borkOrangeColor]];
    [tag setCornerRadius:15.0f];
    
    return tag;
}

- (void)tagList:(GCTagList *)tagList accessoryButtonTappedAtIndex:(NSInteger)index {

    /**
     * this is the delete method how to use.
     */
    /**
    [self.tagNames removeObjectsInRange:NSMakeRange(index, 2)];
    [tagList deleteTagLabelWithRange:NSMakeRange(index, 2)];
    [tagList deleteTagLabelWithRange:NSMakeRange(index, 2) withAnimation:YES];
     */
    
    
    /**
     * this is the reload method how to use.
     */
    /**
    self.tagNames[index] = @"Kim Jong Kook";
    [tagList reloadTagLabelWithRange:NSMakeRange(index, 1)];
    [tagList reloadTagLabelWithRange:NSMakeRange(index, 1) withAnimation:YES];
    
    self.tagNames[index] = @"Kim Jong Kook";
    self.tagNames[index+1] = @"Girls' Generation";
    [tagList reloadTagLabelWithRange:NSMakeRange(index, 2) withAnimation:YES];
    */
    
    /**
     * this is the insert method how to use.
     */
    [self.tagNames insertObject:@"ЛУК-ШАРЛОТ" atIndex:index];
    [self.tagNames insertObject:@"ЖЕМЧУЖНЫЙ ЛУК" atIndex:index];
    [tagList insertTagLabelWithRange:NSMakeRange(index, 2) withAnimation:YES];
    
}

- (void)tagList:(GCTagList *)taglist didChangedHeight:(CGFloat)newHeight {
    NSLog(@"%s:%.1f", __func__, newHeight);
}

- (NSString*)tagList:(GCTagList *)tagList labelTextForGroupTagLabel:(NSInteger)interruptIndex {
    return [NSString stringWithFormat:@"和其他%d位", self.tagNames.count - interruptIndex];
}

- (void)tagList:(GCTagList *)taglist didSelectedLabelAtIndex:(NSInteger)index {
    [taglist deselectedLabelAtIndex:index animated:YES];
}

/**
 * 
 */
- (NSInteger)maxNumberOfRowAtTagList:(GCTagList *)tagList {
    return 2;
}

- (GCTagLabelAccessoryType)accessoryTypeForGroupTagLabel {
    return GCTagLabelAccessoryArrowSign;
}

@end
