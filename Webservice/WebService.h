//
//  AppDelegate.m
//  Webservice
//
//  Created by Vijay on 10/19/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WebServiceCompleteDelegate

- (void) webServiceRequestCompleted;
@optional
- (void)webServiceRequestCompletedSync;
@end

@interface WebService : NSObject
{
    NSString					*m_pURLAddr;
    NSMutableData				*m_pHTTPRsp;
    NSString					*m_pHTTPRspStr;
	NSURLConnection				*m_pConn;	
	NSData					*m_pHttpResponceData;
    id <WebServiceCompleteDelegate>		mDelegate;
	BOOL					m_pSuccessData;
}

- (id) initWebService: (NSString*)l_pURLAddr;
- (void) sendHTTPRequest;
-(void) sendHTTPPost:(NSString *)request_body;

-(void) sendHTTPPostSync:(NSString *)request_body;
- (void)handleError:(NSError *)error;
- (void)cancelDownload;

- (void) sendHTTPRequest:(NSMutableURLRequest *)l_pURLReq;

@property (nonatomic)BOOL					m_pSuccessData;
@property (nonatomic, retain) id <WebServiceCompleteDelegate>	mDelegate;
@property (nonatomic, strong) NSMutableData			*m_pHTTPRsp;
@property (nonatomic, strong) NSData				*m_pHttpResponceData;


@end
