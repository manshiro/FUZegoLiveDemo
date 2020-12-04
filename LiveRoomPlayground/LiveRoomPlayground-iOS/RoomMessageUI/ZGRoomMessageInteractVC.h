//
//  ZGRoomMessageInteractVC.h
//  LiveRoomPlayground-iOS
//
//  Created by jeffreypeng on 2019/8/19.
//  Copyright © 2019 Zego. All rights reserved.
//
#ifdef _Module_RoomMessage

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGRoomMessageInteractVC : UIViewController

@property (nonatomic, copy) NSString *roomID;

+ (instancetype)instanceFromStoryboard;

@end

NS_ASSUME_NONNULL_END
#endif
