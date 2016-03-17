//
//  GBNumSecureKeyboard.h
//  GBNumSecureKeyboard
//
//  Created by xuguibin on 16-2-19.
//  Copyright (c) 2016年 LKGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumSecureKeyboardDelegate <UITextFieldDelegate>

@end

@interface UITextField (NumSecureKeyboard)

/** 数字密码键盘代理 */
@property (strong, nonatomic) id<NumSecureKeyboardDelegate> numSecureDelegate;

@end

@interface GBNumSecureKeyboard : UIView

@end
