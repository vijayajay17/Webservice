//
//  AppDelegate.m
//  Webservice
//
//  Created by Vijay on 10/19/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "WebService.h"
#import <CFNetwork/CFNetwork.h>


@implementation WebService
@synthesize	mDelegate;
@synthesize	m_pHTTPRsp,m_pHttpResponceData,m_pSuccessData;


- (id) initWebService: (NSString*)l_pURLAddr
{
    m_pURLAddr	= [[NSString alloc] initWithString:l_pURLAddr];
    return self;

}



-(void) sendHTTPPostSync:(NSString *)request_body
{
	NSURL		*l_pURL		= [NSURL URLWithString:m_pURLAddr];
	NSMutableURLRequest *l_pRequest = [[NSMutableURLRequest alloc] initWithURL:l_pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	if(request_body != nil)
		[l_pRequest setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
	
	[l_pRequest setHTTPMethod:@"POST"];

	
	m_pSuccessData	=	YES;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:l_pURL
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                m_pHttpResponceData = data;
            }] resume];
    
	[mDelegate	webServiceRequestCompletedSync];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
}


- (void) sendHTTPRequest
{
	
	if (![NSThread isMainThread])
	{
		[self performSelectorOnMainThread:@selector(sendHTTPRequest) withObject:nil waitUntilDone:NO];
		return;
	}
	
	NSURL		*l_pURL		= [NSURL URLWithString:m_pURLAddr];
	NSMutableURLRequest	*l_pURLReq	= [[NSMutableURLRequest alloc] initWithURL:l_pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:l_pURLReq
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {

                                      }];
    
   
}


- (void) sendHTTPRequest:(NSMutableURLRequest *)l_pURLReq
{
    
	
	m_pConn	= [[NSURLConnection alloc] initWithRequest:l_pURLReq delegate:self  startImmediately:NO];
	[m_pConn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[m_pConn			start];
	
	
}

-(void) sendHTTPPost:(NSString *)request_body{
	
	if (![NSThread isMainThread])
	{
		[self performSelectorOnMainThread:@selector(sendHTTPPost:) withObject:request_body waitUntilDone:NO];
		return;
	}

	NSURL		*l_pURL		= [NSURL URLWithString:m_pURLAddr];
	NSMutableURLRequest *l_pRequest = [[NSMutableURLRequest alloc] initWithURL:l_pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	//NSLog(@"%@",l_pRequest);
	if(request_body != nil)
		[l_pRequest setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
	
	[l_pRequest setHTTPMethod:@"POST"];
	NSURLConnection	*l_pConn	= [[NSURLConnection alloc] initWithRequest:l_pRequest delegate:self  startImmediately:NO];
	[l_pConn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[l_pConn			start];
	
}
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	m_pHTTPRsp = [[NSMutableData alloc] init];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[m_pHTTPRsp appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error
{

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if ([error code] == kCFURLErrorNotConnectedToInternet)
	{	// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[error localizedDescription]  forKey:NSLocalizedDescriptionKey];
		NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
		[self handleError:noConnectionError];
	}
	else
	{   // otherwise handle the error generically
		[self handleError:error];
	}

}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection
{
	m_pSuccessData	=	YES;
	// create the queue to run our ParseOperation
	[mDelegate webServiceRequestCompleted];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

- (void)handleError:(NSError *)error
{
	
	m_pSuccessData	=	NO;
	[mDelegate webServiceRequestCompleted];
    NSString *errorMessage = [error localizedDescription];
	NSLog(@"%@",errorMessage);
    
}
- (void)cancelDownload
{
	self.m_pHTTPRsp = nil;
}

@end
