//
//  OpenWeatherMapAPI.m
//  SUNRISE
//
//  Created by Carla Urbano on 27/12/2018.
//  Copyright © 2018 SUNRISE. All rights reserved.

#import "OpenWeatherMapAPI.h"
//#import "Keys.h"


@implementation OpenWeatherMapAPI

+ (OpenWeatherMapAPI *)sharedInstance {
    static OpenWeatherMapAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OpenWeatherMapAPI alloc] init];
    });
    return sharedInstance;
}

- (void)fetchCurrentWeatherDataForLocation:(CLLocation *)location completion:(void(^)(WeatherData *weatherData))completion failure:(void(^)(NSError* error))failure{
    //latitude and longitude of the current position
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial&appid=%s",latitude,longitude,"e86f13e401812555e52c8ccf7f4e5a8b"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error) {
            failure(error);
        } else {
            WeatherData *weather = [[WeatherData alloc] initWithJSON:data];
            completion(weather);
        }
        
    }] resume];
}

@end
