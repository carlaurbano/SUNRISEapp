//
//  AppDelegate.h
//  SunriseApp
//
//  Created by Carla Urbano on 28/12/2018.
//  Copyright © 2018 SUNRISE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

