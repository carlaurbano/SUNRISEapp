//
//  OpenWeatherMapAPI.h
//  SUNRISE
//
//  Created by Carla Urbano on 27/12/2018.
//  Copyright © 2018 SUNRISE. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherData.h"

@interface OpenWeatherMapAPI : NSObject

+ (OpenWeatherMapAPI *)sharedInstance;

- (void)fetchCurrentWeatherDataForLocation:(CLLocation *)location completion:(void(^)(WeatherData *weatherData))completion failure:(void(^)(NSError* error))failure;

@end
