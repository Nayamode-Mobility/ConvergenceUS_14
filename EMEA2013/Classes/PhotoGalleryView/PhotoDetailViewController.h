//
//  PhotoDetailViewController.h
//  mgx2013
//
//  Created by Paul Johnson on 10/25/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//
#import "PostComment.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PhotoDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PostCommentDelegate>
{
}

@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSDictionary *startPict;
@property (strong, nonatomic) NSMutableArray *photoList;
@property (strong, nonatomic) NSArray *commentList;
@property (strong, nonatomic) NSArray *arrLikesCommentsCount;
@property (nonatomic, assign) NSInteger intPhotoIndex;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView2;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UIView *galleryView;
@property (strong, nonatomic) IBOutlet UIView *listView;
@property (strong, nonatomic) IBOutlet UIView *postView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UIView *commentsView;
@property (strong, nonatomic) IBOutlet UIButton *popularButton;
@property (strong, nonatomic) IBOutlet UIButton *recentButton;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *commentsCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityViewSearch;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSearch;
@property int filterSelect;
@property (strong, nonatomic) IBOutlet UIButton *rbtnUser;
@property (strong, nonatomic) IBOutlet UIButton *rbtnHashtag;
@property (nonatomic, assign) BOOL IsUserSelected;
@property (strong, nonatomic) NSArray *searchPhotoList;
@property (strong, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblSearchTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnImageSelected;
@property (nonatomic) BOOL blnCalledFromMyUploads;

- (IBAction)popularClicked:(id)sender;
- (IBAction)recentClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (void) refresh;
- (void) loadImage;
- (IBAction)prevClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;
- (IBAction)imageSelected:(id)sender;
- (void)updateButtons;
- (IBAction)search:(id)sender;
- (IBAction)searchTypeSelected:(id)sender;

// comments
@property (nonatomic, retain) PostComment *postComment;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnUnlike;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnPostComment;
@property (strong, nonatomic) IBOutlet UILabel *lblCommentsPlaceHolder;


- (IBAction)likeButton:(id)sender;
- (IBAction)unlikeButton:(id)sender;
- (IBAction)postCommentButton:(id)sender;
- (IBAction)deleteButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;

@property (strong, nonatomic) IBOutlet UILabel *lblPostedDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLikesCount;
@property (strong, nonatomic) IBOutlet UILabel *lblCommentsCount;
@property (strong, nonatomic) IBOutlet UILabel *lblUploadedBy;

@property (nonatomic, retain) IBOutlet UIView *vwLoading;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoading;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoadingLike;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoadingPostComment;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoadingDelete;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoadingSearch;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)loadLargeView:(id)sender;
@end
