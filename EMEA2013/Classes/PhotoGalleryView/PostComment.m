//
//  PostComment.m
//  mgx2013
//
//  Created by Paul Johnson on 10/25/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PostComment.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"
#import "User.h"

@implementation PostComment

@synthesize objConnection, objData;
@synthesize delegate;

- (void)likeButton
{
    if (![self.curPict objectForKey:@"PhotoID"] ) return;
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_ADD_PHOTO_LIKE];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[[self.curPict objectForKey:@"PhotoID"] stringValue] forHTTPHeaderField:@"PhotoID"];
    
    [self.activityView setHidden:NO];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_ADD_PHOTO_LIKE];
}

- (void)unlikeButton
{
    if (![self.curPict objectForKey:@"PhotoID"] ) return;
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_UPDATE_PHOTO_LIKE];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:@"false" forHTTPHeaderField:@"Status"];
    [objRequest addValue:[[self.curPict objectForKey:@"PhotoID"] stringValue] forHTTPHeaderField:@"PhotoID"];
    
    [self.activityView setHidden:NO];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_UPDATE_PHOTO_LIKE];
}

- (void)postCommentButton
{
    /*if (self.commentText.text.length == 0)
    {
        //self.commentText.layer.masksToBounds=YES;
        //self.commentText.layer.borderColor=[[UIColor redColor]CGColor];
        //self.commentText.layer.borderWidth= 1.0f;
        
        [self showAlert:@"" withMessage:@"Please enter your comment." withButton:@"OK" withIcon:nil];
        
        return;
    }*/
    
    [self.commentText resignFirstResponder];
    
    self.commentText.layer.borderColor=[[UIColor clearColor]CGColor];
    
    /* ADD API CALL ... CURRENTLY POST COMMENT IS UNDOCUMENTED */
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_ADD_PHOTO_COMMENT];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[[self.curPict objectForKey:@"PhotoID"] stringValue] forHTTPHeaderField:@"PhotoID"];
    [objRequest addValue:self.commentText.text forHTTPHeaderField:@"Comments"];
    
    [self.activityView setHidden:NO];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_ADD_PHOTO_COMMENT];
}

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
    [self.activityView setHidden:YES];
    
    NSInteger intTag = (int)[connection getTag];
    
    switch (intTag)
    {
        case OPER_PHOTOS_ADD_PHOTO_LIKE:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
    //  NSLog(@"didReceiveResponse: %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
}

- (void)reset
{
    [self.activityView setHidden:YES];
    self.commentText.layer.borderColor=[[UIColor clearColor]CGColor];
    self.commentText.text = @"";
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_PHOTOS_ADD_PHOTO_LIKE:
            {
                if ([strData isEqualToString:@"true"])
                {
                    //[self showAlert:@"" withMessage:@"Photo has been liked!" withButton:@"OK" withIcon:nil];
                    
                    //if ([delegate respondsToSelector:@selector(likeSuccess)])
                    //{
                        [delegate likeSuccess];
                    //}
                }
            }
            break;
        case OPER_PHOTOS_UPDATE_PHOTO_LIKE:
            {
                if ([strData isEqualToString:@"true"])
                {
                    //[self showAlert:@"" withMessage:@"Photo has been unliked!" withButton:@"OK" withIcon:nil];
                    
                    //if ([delegate respondsToSelector:@selector(unlikeSuccess)])
                    //{
                        [delegate unlikeSuccess];
                    //}
                }
            }
            break;
        case OPER_PHOTOS_ADD_PHOTO_COMMENT:
            {
                if ([strData isEqualToString:@"true"])
                {
                    [self showAlert:@"" withMessage:@"Your comment posted successfully. It will be visible in the photo comment section after approval." withButton:@"OK" withIcon:nil];

                    //if ([delegate respondsToSelector:@selector(commentsAddedSuccess)])
                    //{
                        [delegate commentsAddedSuccess];
                    //}
                }
            }
            break;
        default:
            break;
    }

    [self reset];
}
#pragma mark -

- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}

@end
