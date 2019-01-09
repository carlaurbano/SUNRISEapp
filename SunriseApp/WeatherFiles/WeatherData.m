//
//  WeatherData.m
//  SUNRISE
//
//  Created by Carla Urbano on 27/12/2018.
//  Copyright © 2018 SUNRISE. All rights reserved.

#import "WeatherData.h"

@implementation WeatherData

- (id)initWithJSON:(NSData *)jsonData {
    if (self = [super init]){
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"NSJSONSerialization failed with error: %@", [error localizedDescription]);
            return self;
        } 
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            id idName = [jsonObject objectForKey:@"name"];
            if ([idName isKindOfClass:[NSString class]]) {_name = idName;}
            id idWeatherArr = [jsonObject objectForKey:@"weather"];
            if ([idWeatherArr isKindOfClass:[NSArray class]]) {
                id idWeather = [idWeatherArr objectAtIndex:0];
                if ([idWeather isKindOfClass:[NSDictionary class]]) {
                    id idMain = [idWeather objectForKey:@"main"];
                    if ([idMain isKindOfClass:[NSString class]]) {_main = idMain;}
                    id idDesc = [idWeather objectForKey:@"description"];
                    if ([idDesc isKindOfClass:[NSString class]]) {_desc = idDesc;}
                }
            }
            id idMainD = [jsonObject objectForKey:@"main"];
            if ([idMainD isKindOfClass:[NSDictionary class]]) {
                _temp = [NSNumber numberWithDouble: [[idMainD objectForKey:@"temp"] doubleValue]];
                _pressure = [NSNumber numberWithDouble: [[idMainD objectForKey:@"pressure"] doubleValue]];
                _humidity = [NSNumber numberWithDouble: [[idMainD objectForKey:@"humidity"] doubleValue]];
                _temp_min = [NSNumber numberWithDouble: [[idMainD objectForKey:@"temp_min"] doubleValue]];
                _temp_max = [NSNumber numberWithDouble: [[idMainD objectForKey:@"temp_max"] doubleValue]];
                _clouds = [NSNumber numberWithDouble: [[idMainD objectForKey:@"clouds"] doubleValue]];
            }
            id idWind = [jsonObject objectForKey:@"wind"];
            if ([idWind isKindOfClass:[NSDictionary class]]) {
                _wind_speed = [NSNumber numberWithDouble:[[idWind objectForKey:@"speed"] doubleValue]];
                _wind_deg = [NSNumber numberWithDouble:[[idWind objectForKey:@"deg"] doubleValue]];
            }
        } else {
            NSLog(@"Data is not a Dictionary");
        }
    }
    return self;
}

- (NSString *)cloudsString {
    //printing percentage of clouds
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *startTimeString = [formatter stringFromDate:date];
    
    NSString * someString = [NSString stringWithFormat: @"%i", [self.clouds intValue]];
    
    NSString * cloudsNow = [NSString stringWithFormat:@"%@ %@\r\n", startTimeString, someString];
    
    NSLog(@"%@", cloudsNow);
    

    //returning percentage of clouds to iPhone
    return [NSString stringWithFormat:@"%i percent of clouds",[self.clouds intValue]];
    
}


@end
