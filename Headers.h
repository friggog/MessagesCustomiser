@interface _UIBackdropView : UIView {}
- (void)transitionToColor:(id)arg1;
- (void)transitionToSettings:(id)arg1;
@end

@interface _UIBackdropViewSettings : NSObject {}
+ (id)settingsForStyle:(NSInteger)arg1;
- (void)setColorTint:(id)arg1;
@end

@interface UIImage (chew)
+(id)imageWithContentsOfCPBitmapFile:(id)arg1 flags:(NSInteger)arg2 ;
@end

@interface _UISearchBarSearchFieldBackgroundView : UIView {}
- (void)setStrokeColor:(id)arg1;
- (void)setFillColor:(id)arg1;
@end

@interface UITableViewCellContentView : UIView {}
@end

@interface UITableViewCellScrollView : UIView {}
@end

@interface MFRecipientTableViewCellDetailView :UIView {}
@end

@interface MFRecipientTableViewCellTitleView : UIView {}
@end

@interface ABContactHeaderView : UIView {}
@end

@interface ABMemberNameView : UIView {}
@end

@interface PUCollectionView : UIView {}
@end

@interface CKTypingIndicatorLayer : CALayer {}
@end

@interface CKConversation : NSObject {}
@property(readonly) NSArray * messages;
@property(getter=isGroupConversation,readonly) BOOL groupConversation;
@property (nonatomic,readonly) NSString * name;
@property (nonatomic,readonly) unsigned long long recipientCount;
@property(readonly) NSArray * recipients;
- (void)loadMoreMessages;
- (void)setLimitToLoad:(NSInteger)arg1;
@end

@interface CKIMMessage : NSObject  {}
@property(readonly) BOOL isSMS;
@property(readonly) BOOL isFromMe;
@property(readonly) BOOL isOutgoing;
@property(readonly) BOOL isFromFilteredSender;
@property(readonly) BOOL isRead;
@property(readonly) BOOL isDelivered;
@property(readonly) BOOL isWaitingForDelivery;
@property(readonly) BOOL failedSend;
@property (retain) CKConversation * conversation;
@property(readonly) NSString * previewText;
@end

@interface CKTranscriptDataRow : NSObject {}
@property(retain) CKIMMessage * message;
@end

@interface CKTranscriptCollectionView : UICollectionView{}
@end

@interface UIStatusBar : NSObject {}
- (void)requestStyle:(NSInteger)arg1;
@end

@interface _UITextFieldRoundedRectBackgroundViewNeue : UIView{}
@property(retain) UIColor * fillColor;
@property(retain) UIColor * strokeColor;
@end

@interface CKMessageEntryView : UIView {}
@property(retain) UIButton * sendButton;
@property BOOL sendButtonColor;
@property(retain) _UITextFieldRoundedRectBackgroundViewNeue * coverView;
@property (nonatomic,copy) NSString * placeholderText;
@property (nonatomic,retain) _UIBackdropView * backdropView;
@end


@interface CKMessageEntryTextView : UITextView {}
@end


@interface CKMultipleRecipientCollapsedTableViewCell : UITableViewCell {}
@end


@interface UITextSelectionView : UIView {}
@end
@interface CKConversationListCell : UITableViewCell {}
@end

@interface CKConversationList : NSObject {}
+ (id)sharedConversationList;
- (id)conversations;
@end


@interface CKConversationListController : NSObject {}
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
@property (retain) CKConversationList * conversationList;
@end



@interface CKGradientReferenceView : UIView {}
@end

@interface CKTranscriptCollectionViewController :UIViewController {}
@property(retain) UIView * collectionView;
- (void)reloadData;
@end

@interface CKTranscriptController : UIViewController {}
@property(retain) CKTranscriptCollectionViewController * collectionViewController;
@property (nonatomic,retain) CKMessageEntryView * entryView;
- (id)conversation;
- (void)nextConvo;
- (void)prevConvo;
- (void)setConversation:(id)arg1;
- (void)_refreshViewForCurrentConversationIfNeeded;
- (void)_refreshViewForNewRecipientIfNeeded;
@end

@interface CKUIBehavior : NSObject {}
+(id)sharedBehaviors;
-(id)appTintColor;
- (id)blue_balloonColors;
- (id)green_balloonColors;
-(CGFloat) transcriptContactImageDiameter;
@end

@interface UIImage (custom) {}
+(id) defaultDesktopImage;
@end


@interface CKEditableCollectionViewCell : NSObject {}
@property(retain) UIImageView * checkmark;
@end



@interface CouriaMessageView : NSObject {}

@property(assign, nonatomic) BOOL outgoing;
@property(retain, nonatomic) NSString *message;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UILabel *textView;

@end

@interface UIView (CHEW)
@property(retain, nonatomic) UIImage *image;
@end

@interface CKTranscriptMessageCell:UIView
@property (assign, nonatomic) char orientation;
@property (nonatomic, retain) UIImage* contactImage;
-(void) setWantsContactImageLayout:(BOOL)a;
-(void) layoutSubviewsForContents;
@end

@interface CKAddressBook:NSObject
+(id) transcriptContactImageOfDiameter:(CGFloat)arg1 forRecordID:(NSInteger)arg2;
@end

@interface IMPerson:NSObject
@property (nonatomic, readonly) void* _recordRef;
@property (nonatomic, readonly) NSInteger _recordID;
@end

@interface IMHandle:NSObject
@property NSInteger addressBookIdentifier;
@property (nonatomic, retain, readonly) NSString* fullName;
@property IMPerson* person;
@end

@interface IMChatItem:NSObject
@property (nonatomic, retain, readonly) IMHandle* sender;
@property (nonatomic) BOOL isFromMe;
@end

@interface CKChatItem:NSObject
@property (nonatomic, retain, readonly) UIImage* contactImage;
@property (nonatomic, retain) IMChatItem* IMChatItem;
@property (nonatomic) BOOL hasTail;
@end
