//
//  ViewController.h
//  Webservice
//
//  Created by Vijay on 10/19/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface ViewController : UIViewController<WebServiceCompleteDelegate>

@property(nonatomic)WebService  *m_pWebService;
@end

