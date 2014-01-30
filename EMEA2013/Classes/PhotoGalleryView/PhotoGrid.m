//
//  PhotoGrid.m
//  mgx2013
//
//  Created by Paul Johnson on 10/24/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PhotoGrid.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"
#import "User.h"
#import "CustomCollectionViewCell.h"
#import "PhotoDetailViewController.h"

#define iPhone_Item_Width 60.0
#define iPhone_Item_Height 60.0
#define iPhone_NO_of_Cols 4.0
#define iPad_Item_Width 60.0
#define iPad_Item_Height 60.0
#define iPad_NO_of_Cols 4.0

@implementation PhotoGrid

@synthesize objConnection, objData;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// create appdelegate upon initialization
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init
{
    /* first initialize the base class */
    if ((self = [super init])) {
        
        [self refresh];
        
    }
    
	return self;
	
}

-(void)refresh {
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_RECENT_FOR_DASHBOARD];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"GET"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_RECENT_FOR_DASHBOARD];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
 // CustomCollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    PhotoDetailViewController *photoDetail;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        photoDetail = [storyboard instantiateViewControllerWithIdentifier:@"idDetail"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        photoDetail = [storyboard instantiateViewControllerWithIdentifier:@"idDetail"];
    }
    
    NSDictionary *itm = [self.photoList objectAtIndex:indexPath.row];
    photoDetail.startPict = itm;
    
    [ [self.parent navigationController] pushViewController:photoDetail animated:YES];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.photoList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  
    NSString *img = [[self.photoList objectAtIndex:indexPath.row] objectForKey:@"PhotoUrl"];
    NSURL *imgURL = [NSURL URLWithString:img];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error){
        if (!error) {
            
            cell.articleImage.image = [UIImage imageWithData:data];
            
        } else {
            NSLog(@"error %@",error);
        }
    }];
    
    return cell;
}

- (CGRect)collectionViewContentSize
{
    double itemCount = [self.photoList count];
    
    if([DeviceManager IsiPad] == YES)
    {
        double totalHeight = ceil(itemCount/iPad_NO_of_Cols)*(iPad_Item_Height) +10;
        
        return CGRectMake(self.photoCollectionView.frame.origin.x, self.photoCollectionView.frame.origin.y, self.photoCollectionView.frame.size.width, totalHeight);
    }
    else{
        double totalHeight = ceil(itemCount/iPhone_NO_of_Cols)*(iPhone_Item_Height) +10;
        return CGRectMake(self.photoCollectionView.frame.origin.x, self.photoCollectionView.frame.origin.y, self.photoCollectionView.frame.size.width, totalHeight);
        
    }
    
    
}



#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
    NSLog(@"Error: %@",error);
    
    NSInteger intTag = (int)[connection getTag];
    
    switch (intTag)
    {
        case OPER_PHOTOS_GET_RECENT_FOR_DASHBOARD:
        {
            
             
        }
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    NSLog(@"Connection Tag: %d",intTag);
    
    //NSLog(@"data contents: %@", [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding]);
    
    NSString *string = [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding];
    
    // JSON has quotes, around the string, so we need to clean this up
    NSError *error;
    NSString *outerJson = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:NSJSONReadingAllowFragments error:&error];
    NSError *jsonError;
    NSArray *photos = [[NSArray alloc] init];
    photos = [NSJSONSerialization JSONObjectWithData:[outerJson dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:&jsonError];
    if(jsonError != nil){
        NSLog(@"JSON Error: %@", jsonError);
        return;
    } 

    self.photoList  =  photos;
    [self.photoCollectionView reloadData];
}
#pragma mark -


@end
