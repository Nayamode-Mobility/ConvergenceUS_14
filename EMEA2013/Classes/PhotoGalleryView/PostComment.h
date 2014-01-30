//
//  PostComment.h
//  mgx2013
//
//  Created by Paul Johnson on 10/25/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol PostCommentDelegate <NSObject>
@optional
- (void)likeSuccess;
- (void)unlikeSuccess;
- (void)commentsAddedSuccess;
@end

@interface PostComment : NSObject <UITextViewDelegate>
{
    id<PostCommentDelegate> delegate;
}

@property (strong, nonatomic) UITextView *commentText;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSDictionary *curPict;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) id<PostCommentDelegate> delegate;

- (void)likeButton;
- (void)unlikeButton;
- (void)postCommentButton;
- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath;
- (void)reset;
@end
