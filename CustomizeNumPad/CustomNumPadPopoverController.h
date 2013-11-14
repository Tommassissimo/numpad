//
//  CustomNumPadPopoverController.h
//  CustomizeNumPad
//
//  Created by jiayi zhou on 10/31/13.
//  Copyright (c) 2013 jiayi zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol numPadPopoverDelegate;

@interface CustomNumPadPopoverController : UIViewController

@property (nonatomic,weak) id<numPadPopoverDelegate> delegate;

@end

@protocol numPadPopoverDelegate <NSObject>

-(void) numPadPopoverControll:(CustomNumPadPopoverController *)viewController
                   sendString:(NSString *)key;

@end
