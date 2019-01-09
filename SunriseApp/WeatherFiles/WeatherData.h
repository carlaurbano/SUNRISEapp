//
//  WeatherData.h
//  SUNRISE
//
//  Created by Carla Urbano on 27/12/2018.
//  Copyright © 2018 SUNRISE. All rights reserved.

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSNumber *temp;
@property (strong, nonatomic) NSNumber *pressure;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *temp_min;
@property (strong, nonatomic) NSNumber *temp_max;
@property (strong, nonatomic) NSNumber *wind_speed;
@property (strong, nonatomic) NSNumber *wind_deg;
@property (strong, nonatomic) NSNumber *clouds;


-(id)initWithJSON:(NSData *)jsonData;
- (NSString *)cloudsString;


@end


