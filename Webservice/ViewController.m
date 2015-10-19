//
//  ViewController.m
//  Webservice
//
//  Created by Vijay on 10/19/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "ViewController.h"


#define CommonUrl @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.m_pWebService			= [[WebService alloc] initWebService:CommonUrl];
    self.m_pWebService.mDelegate		= self;
    [self.m_pWebService  sendHTTPPost:nil];

}
- (void)webServiceRequestCompleted
{
    if (!self.m_pWebService.m_pSuccessData)
    {
        NSLog(@"%d",self.m_pWebService.m_pSuccessData);
        return;
    }else
    {
        NSString *json_string = [[NSString alloc] initWithData:self.m_pWebService.m_pHTTPRsp encoding:NSUTF8StringEncoding];
        NSLog(@"Success %@",json_string);

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
