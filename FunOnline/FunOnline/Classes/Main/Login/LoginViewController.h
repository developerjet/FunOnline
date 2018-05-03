//
//  LoginViewController.h
//  FunOnline
//
//  Created by Mac on 2018/5/3.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BasicViewController.h"

typedef void(^LogonDidFinisedBlock)(void);

@interface LoginViewController : BasicViewController

@property (nonatomic, copy) LogonDidFinisedBlock logonDidFinisedBlock;

@end
