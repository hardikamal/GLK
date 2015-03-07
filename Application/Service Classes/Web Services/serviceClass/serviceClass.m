//
//  serviceClass.m
//  HomeWell
//
//  Created by user on 3/27/14.
//  Copyright (c) 2014 Ajay Awasthi. All rights reserved.
//

#import "serviceClass.h"
//#import "MBProgressHUD.h"



@implementation serviceClass
{
    //MBProgressHUD *progressHUD;
}


+(NSDictionary *)showfeedByanotherService:(NSString *)serviceName dictionary:(NSMutableDictionary *)tempDictionary
{
    
    NSString * url = [NSString stringWithFormat:@"http://caffiene.mobulous.com/services/%@",serviceName];
    NSMutableArray * content = [NSMutableArray array];
    for(NSString * key in tempDictionary)
        [content
         addObject: [NSString stringWithFormat: @"%@=%@", key, tempDictionary[key]]];
    
    NSString * body = [content componentsJoinedByString: @"&"];
    NSData * bodyData = [body dataUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableURLRequest * request =
    [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
    
    //NSString * msgLength =
    //  [NSString stringWithFormat: @"%ld", [jsonMessage length]];
    NSString * msgLength =
    [NSString stringWithFormat: @"%ld", (unsigned long)[bodyData length]];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField: @"Content-Length"];
    [request setHTTPMethod: @"POST"];
    //[request setHTTPBody: jsonMessage];
    [request setHTTPBody: bodyData];
    NSError *error;
    NSData * requestData = [NSURLConnection  sendSynchronousRequest: request returningResponse: nil error:&error];
    NSLog(@"%@",[error localizedDescription]);
    NSDictionary *json;
    if(error.code==-1009)
    {
        json=nil;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (requestData)
        {
            json = [NSJSONSerialization JSONObjectWithData:requestData options:kNilOptions error:&error];
        }
        
       if(!json)
        {
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Problem Occur" message:@"Check your network connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
            
        }
    }
    return json;
    
}


+(UIView *)addStattusBarView
{
   if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
   {
      UIView *addStatusBar = [[UIView alloc] init];
      addStatusBar.frame = CGRectMake(0, 0, 320, 20);
      //change this to match your navigation bar or view color or tool bar
      //You can also use addStatusBar.backgroundColor = [UIColor BlueColor]; or any other color
     addStatusBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:112/255.0 blue:161/255.0 alpha:1.0];
       return addStatusBar;
   }
    return Nil;
}

-(void)startAnimator:(UIViewController *)controller
{
//    progressHUD=[MBProgressHUD showHUDAddedTo:controller.view animated:YES];
//    progressHUD.labelText=@"Please wait...";
}

-(void)stopAnimator:(UIViewController *)controller
{
//    [MBProgressHUD hideHUDForView:controller.view animated:YES];
//    progressHUD=nil;
}



@end
