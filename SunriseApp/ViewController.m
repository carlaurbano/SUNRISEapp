//
//  ViewController.m
//  SunriseApp
//
//  Created by Carla Urbano on 28/12/2018.
//  Copyright © 2018 SUNRISE. All rights reserved.
//

#import "ViewController.h"
#import "OpenWeatherMapAPI.h"

#define kUpdateInterval 10

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UILabel *degreesLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *OutputLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchObject;
@property (weak, nonatomic) IBOutlet UITextField *textf;
@property (weak, nonatomic) IBOutlet UILabel *lampuvlabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (double) IrradianceatEarthSurface:(double)uv;

@end

@implementation ViewController
@synthesize textf;

/*Initialize global variables */

double wavelength;
double cloudcover;
#define n_skintypes 5
#define n_uvindex 10
double total_weight[n_skintypes];

double partial_weight[n_skintypes][n_uvindex];
int skintype_index;
int uvlamp_index;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self enableLocationServices];
    
    
    for(int i = 0; i < n_skintypes; i++){
        total_weight[i] = 0;
    }
    
    /*RECOMMENDED TIMES WITH UVI TABLE*/
    // Reading the Data file oof UVI index compared to skin type
    NSString * pathuvi = [[NSBundle mainBundle] pathForResource:@"UVI_recommendedtime" ofType:@"csv"];
    NSString * contentuvi = [NSString stringWithContentsOfFile:pathuvi encoding:NSUTF8StringEncoding error:NULL];
    // Dividing the String by rows
    NSArray *rowsuvi = [contentuvi componentsSeparatedByString:@"\r\n"];
    //Dividing the String by columns
    
    for (NSString* currentStringuvi in rowsuvi)
    {
        //if a line is empty, jump to the next
        if ([currentStringuvi length] == 0){
            continue;
        }
        NSArray *columnsuvi = [currentStringuvi componentsSeparatedByString:@","];
        int UV_index= [columnsuvi[0] intValue];
        double minutes_skinI = [columnsuvi[1] doubleValue];
        double minutes_skinII = [columnsuvi[2] doubleValue];
        double minutes_skinIII = [columnsuvi[3] doubleValue];
        double minutes_skinIV = [columnsuvi[4] doubleValue];
        double minutes_skinV = [columnsuvi[5] doubleValue];
        
        //calculate partial weight of each type of skin and for each index of UV
        partial_weight[0][UV_index - 1] = 1/minutes_skinI;
        partial_weight[1][UV_index - 1] = 1/minutes_skinII;
        partial_weight[2][UV_index - 1] = 1/minutes_skinIII;
        partial_weight[3][UV_index - 1] = 1/minutes_skinIV;
        partial_weight[4][UV_index - 1] = 1/minutes_skinV;
        
        //calculate total weight of each type of skin
        total_weight[0] += partial_weight[0][UV_index - 1];
        total_weight[1] += partial_weight[1][UV_index - 1];
        total_weight[2] += partial_weight[2][UV_index - 1];
        total_weight[3] += partial_weight[3][UV_index - 1];
        total_weight[4] += partial_weight[4][UV_index - 1];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Location Services

- (void)enableLocationServices {
    //Accessing location through iPhones GPS
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self.locationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([[NSDate date] timeIntervalSinceDate:self.lastUpdate] > kUpdateInterval || !self.lastUpdate) {
        
        [[OpenWeatherMapAPI sharedInstance]
         fetchCurrentWeatherDataForLocation:[locations lastObject]
         completion:^(WeatherData *weatherData) {
             
             //FOR CLOUDS
             while (true) {
                 //NSDate *date = [NSDate date];
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 [formatter setDateFormat:@"HH:mm:ss"];
                 
                 //NSString *startTimeString = [formatter stringFromDate:date];
                
                 NSString *cloudsString = [weatherData cloudsString];

                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.degreesLabel.text = cloudsString;
                     self.lastUpdate = [NSDate date];
                 });
                 sleep(60); //wait in seconds: every minute to be compatible with the UV Sensor
             }
             
         }
         failure:^(NSError *error) {
             NSLog(@"Failed: %@",error);
         }
         ];
    }
}

/* Getting Location */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self.locationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

//Switch button to allow for skin Selection

- (IBAction)skin1Selector:(UISwitch*)sender {
    if(sender.on)
    {
       skintype_index = 0 ;
    }
}
- (IBAction)skin2Selector:(UISwitch*)sender {
    if(sender.on)
    {
        skintype_index = 1 ;
        
    }
}
- (IBAction)skin3Selector:(UISwitch*)sender {
    if(sender.on)
    {
        skintype_index = 2 ;
    }
}
- (IBAction)skin4Selector:(UISwitch*)sender {
    if(sender.on)
    {
        skintype_index = 3 ;
    }
}

- (IBAction)skin5Selector:(UISwitch*)sender {
    if(sender.on)
    {
        skintype_index = 4 ;
    }
}

//Button to set up the Lamp's UV radiation

- (IBAction)sub:(UIButton*)sender {
    uvlamp_index = [textf.text intValue];
}



/* By pressing this button the app calculates the time of UV exposure the person needs */
- (IBAction)Pressme:(UIButton *)sender {

    /*Reading data from file (UV and Photocell)*/
    
    // Reading the Data file of the Current day
    NSString* path = [[NSBundle mainBundle] pathForResource:@"5jan_arduino" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    // Dividing the string by rows
    NSArray *rows_arduino = [content componentsSeparatedByString:@"\r\n"];

    /* Reading data from Clouds Bundle directory*/
    NSString* pathclouds = [[NSBundle mainBundle] pathForResource:@"5jan_clouds" ofType:@"txt"];
    NSString* contentclouds = [NSString stringWithContentsOfFile:pathclouds encoding:NSUTF8StringEncoding error:NULL];
    // Dividing the string by rows
    NSArray *rows_clouds = [contentclouds componentsSeparatedByString:@"\n"];
    
    
    /*Reading data from Clouds Directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirPath stringByAppendingPathComponent:@"fileName.txt"];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    NSData * contentclouds2 = [fileHandler readDataToEndOfFile];
    NSString * contentcloudsstr =[[NSString alloc] initWithData: contentclouds2 encoding:NSUTF8StringEncoding];
    NSArray * rows_clouds2 = [contentcloudsstr componentsSeparatedByString:@"\r\n"];

    
    
    
    // Reading the Data file of the Extraterrestrial solar iradiance
    NSString * pathirr = [[NSBundle mainBundle] pathForResource:@"ExSolarIrradiance" ofType:@"csv"];
    NSString * contentirr = [NSString stringWithContentsOfFile:pathirr encoding:NSUTF8StringEncoding error:NULL];
    // Dividing the String by rows
    NSArray *rowsirr = [contentirr componentsSeparatedByString:@"\r\n"];
    double solar_irradiance[[rowsirr count]];
    double wavelengthrange[[rowsirr count]];
    
    int uv_index[[rows_arduino count]];
    
    
    int counterirr = 0;
    for (NSString* currentString in rowsirr)
    {
        //if a line is empty, jump to the next
        if ([currentString length] == 0){
            continue;
        }
        
        NSArray *columns = [currentString componentsSeparatedByString:@","];
        wavelengthrange[counterirr] = [columns[0] doubleValue] * 1000;
        solar_irradiance[counterirr] = [columns[1] doubleValue];

        counterirr++;
    }
    
    
    int counter = 0;

    while(true){
        if(counter >= [rows_arduino count]) break;
        if(counter >= [rows_clouds count]) break;
        if ([rows_arduino[counter] length] == 0) break;
        if ([rows_clouds[counter] length] == 0) break;

        NSArray *arduinofield = [rows_arduino[counter] componentsSeparatedByString:@","];
        double visible = [arduinofield[0] doubleValue];
        double uv = [arduinofield[1] doubleValue]*0.3778 ;//converting analogue value into the wavelength irradiance (by calculating energy)
        NSArray *cloudsfield = [rows_clouds[counter] componentsSeparatedByString:@" "];
        double cloudcover = [cloudsfield[1] doubleValue];
        double irradianceES = [self IrradianceatEarthSurface:uv];
        
    
        /* CONSTANT X*/
        float xsigma = uv/10;
        /* CLOUD FACTOR */
        float cf = cloudcover/100;
        /* SPECTRAL CLOUD EFFECT */
        float spectralcloudeffect = 0.76 - 0.24*(1-cf)+0.24*(1-cf)*pow((uv/490),4);

        /* TOTAL IRRADIANCE AT EARTH SURFACE WITH CLOUDS */
        float total_irradiance_ec = irradianceES * xsigma * spectralcloudeffect;
        //printf("%f", total_irradiance_ec);

        /* EXTRATERRESTRIAL SOLAR IRRADIANCE */
        double solar_irradiance_ex = [self ExtraterrestrialSolarIrradiance:uv a1:solar_irradiance a2:wavelengthrange a3:[rowsirr count]];
        int tmp =  total_irradiance_ec * solar_irradiance_ex / 25.0;
        //if(tmp <= 0) continue;
        uv_index[counter] = tmp; //this way we can use uv_index[counter] as index of counteruv
        //make sure the values are inside the ranges
                if(uv_index[counter] < 0) uv_index[counter] = 0;
                if(uv_index[counter] > 10) uv_index[counter] = 10;
                //printf("%d\n", uv_index[counter]);
        counter++;
    }

    //counteruv has the number of minutes of each index (index 0 contains number of minutes with no UV radiation exposure)
    int counteruv[11];
    for(int i = 0; i < 11; i++){
        counteruv[i] = 0;
    }
    for(int i = 0; i < counter; i++){
        counteruv[uv_index[i]]++;
        
    }
    for(int i = 0; i < 11; i++){
        printf("UV%d:%d\n", i,counteruv[i]);
    }

    
    
    
    int minutesforvd3 = [self MinutesofUVexposureNeeded:skintype_index a1:counteruv a2:uvlamp_index];
    
    
    //transform float into string to return
    NSString* minutesforvitd3_str = [NSString stringWithFormat:@"you are missing %d minutes of exposure", minutesforvd3];
    NSString*uvlampindex_str = [NSString stringWithFormat:@"put your SUNRISE Lamp to a %d UVI", uvlamp_index];
    
    /* OUTPUT the message */
    //transform double into NSString
    self.OutputLabel.text = minutesforvitd3_str;
    self.lampuvlabel.text = uvlampindex_str;

    
}


- (double) IrradianceatEarthSurface:(double)uv {
    /* IRRADIANCE AT EARTH SURFACE */
    
    double irradianceES;
    /* check the boolean condition */
    if( uv <= 298 ) {
        /* if condition is true then print the following */
        irradianceES = 1;
    } else if( uv> 298 && uv <= 328 ) {
        /* if else if condition is true */
        irradianceES = pow(10,0.094*(298-uv));
    } else if( uv> 328 && uv <= 400 ) {
        /* if else if condition is true  */
        irradianceES = pow(10,0.015*(139-uv));
    } else {
        /* if none of the conditions is true */
        irradianceES = 0;
    }
    return irradianceES;
}

- (double) ExtraterrestrialSolarIrradiance:(double)uv a1:(double*)solar_irradiance a2:(double*)wavelengthrange a3:(unsigned long)datalength{
    if (uv < wavelengthrange [0]) return 1;
    for (int i = 0; i<datalength-1 ;  i++){
        
        if (uv >= wavelengthrange[i] && uv < wavelengthrange[i+1]) return solar_irradiance[i];
    }
    return solar_irradiance[datalength - 1];
}


- (int) MinutesofUVexposureNeeded:(int)skintype_index a1:(int*)counteruv a2:(int)lamp_uvindex{
    double weighted_sum = 0;
    
    
    for (int i = 0; i <10 ; i++){
        weighted_sum += counteruv[i+1]*partial_weight[skintype_index][i];
    }
    if(weighted_sum > 1) return 0;//overexposure
    return (1/partial_weight[skintype_index][lamp_uvindex])*(1-weighted_sum);


}


@end

