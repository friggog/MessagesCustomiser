#define GreenColour [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:255/255.0]
#define BlueColour [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:255/255.0]
#define LightGreyColour [UIColor colorWithRed:227/255.0 green:229/255.0 blue:233/255.0 alpha:255/255.0]
#define DarkGreyColour [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:255/255.0]
#define BlackColour [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:255/255.0]

#define DarkBlueColour [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f]
#define LightBlueColour [UIColor colorWithRed:25/255.0f green:213/255.0f blue:253/255.0f alpha:1.0f]
#define RedColour [UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:1.0f]
#define OrangeColour [UIColor colorWithRed:255/255.0f green:149/255.0f blue:0/255.0f alpha:1.0f]
#define YellowColour [UIColor colorWithRed:255/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f]
#define PinkColour [UIColor colorWithRed:255/255.0f green:45/255.0f blue:85/255.0f alpha:1.0f]
#define PurpleColour [UIColor colorWithRed:88/255.0f green:86/255.0f blue:214/255.0f alpha:1.0f]
#define TealColour [UIColor colorWithRed:52/255.0f green:170/255.0f blue:220/255.0f alpha:1.0f]
#define MaroonColour [UIColor colorWithRed:114/255.0f green:36/255.0f blue:61/255.0f alpha:1.0f]

#import "UIImage+ImageEffects.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "Headers.h"

#define PreferencesChangedNotification "me.chewitt.MCPrefs.settingschanged"
#define PreferencesFilePath @"/var/mobile/Library/Preferences/me.chewitt.MCPrefs.plist"

static NSDictionary* preferences;
static BOOL is_IOS_7_1 = [[[UIDevice currentDevice] systemVersion] compare:@"7.1" options:NSNumericSearch] != NSOrderedAscending;
static BOOL is_IOS_8_4 = [[[UIDevice currentDevice] systemVersion] compare:@"8.4" options:NSNumericSearch] != NSOrderedAscending;

BOOL darkMode = [[preferences objectForKey:@"DarkMode"] boolValue];
BOOL blackBars = [[preferences objectForKey:@"BlackBars"] boolValue];
BOOL couria = [[preferences objectForKey:@"Couria"] boolValue];
BOOL disableForEclipse = [[preferences objectForKey:@"Eclipse"] boolValue];
static BOOL iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;

static void PreferencesChangedCallback(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    preferences = [NSDictionary dictionaryWithContentsOfFile:PreferencesFilePath];
    couria = [[preferences objectForKey:@"Couria"] boolValue];
    blackBars = [[preferences objectForKey:@"BlackBars"] boolValue];
    darkMode = [[preferences objectForKey:@"DarkMode"] boolValue];
    disableForEclipse = [[preferences objectForKey:@"Eclipse"] boolValue];
}

static BOOL isMobileSMSActive() {
    return [[[NSBundle mainBundle] bundleIdentifier] isEqual:@"com.apple.MobileSMS"] || [[[NSBundle mainBundle] bundleIdentifier] isEqual:@"com.apple.mobilesms.compose"] || [[[NSBundle mainBundle] bundleIdentifier] isEqual:@"com.intelliborn.mpviewservice"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////			DARK MODE           /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UIColor* iMRecipCol;
UIColor* SMSRecipCol;

%hook PUPhotosGlobalFooterView

- (void)layoutSubviews {
    %orig;
    if (darkMode) {
        MSHookIvar<UILabel*>(self, "_titleLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        MSHookIvar<UILabel*>(self, "_subtitleLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
}

%end

%hook UITableViewIndex

- (void)setIndexBackgroundColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig(BlackColour);
    }
    else {
        %orig;
    }
}

%end

%hook UISearchBarBackground

- (void)layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        [(UIToolbar*)self setBarTintColor:BlackColour];
    }
}

-(void) setBarTintColor:(id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig(BlackColour);
    }
    else {
        %orig;
    }
}

%end

%hook _UISearchBarSearchFieldBackgroundView

- (id)_fillColor : (BOOL)arg1 {
    if (darkMode && isMobileSMSActive()) {
        return [UIColor colorWithWhite:1 alpha:0.2];
    }
    else {
        return %orig;
    }
}

%end

%hook UITableView

- (void)_setBackgroundColor : (id)arg1 animated : (BOOL)arg2 {
    if (darkMode && ! [self isKindOfClass:%c(CKRecipientTableView)] && isMobileSMSActive()) {
        %orig(BlackColour, NO);
    }
    else {
        %orig;
    }
}

-(void) setTableHeaderBackgroundColor:(id)arg1 {
    if (darkMode && ! [self isKindOfClass:%c(CKRecipientTableView)] && isMobileSMSActive()) {
        %orig(BlackColour);
    }
    else {
        %orig;
    }
}

-(void) layoutSubviews {
    if (darkMode && isMobileSMSActive()) {
        for (id v in self.subviews) {
            if (! [v isKindOfClass:%c(UITableViewWrapperView)] && ! [v isKindOfClass:%c(UISearchBar)] && ! [v isKindOfClass:%c(UIImageView)]) {
                UIView* view = v;
                view.backgroundColor = BlackColour;
            }
        }
    }
    %orig;
}

%end

%hook UITableViewCell

- (void)setBackgroundColor : (id)arg1 {
    if (darkMode && ! [self isKindOfClass:%c(CKMultipleRecipientTableViewCell)] && ! [self isKindOfClass:%c(CKMultipleRecipientCollapsedTableViewCell)] && isMobileSMSActive()) {
        %orig(BlackColour);
    }
    else {
        %orig;
    }
}

-(void) layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        MSHookIvar<UILabel*>(self, "_detailTextLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        MSHookIvar<UILabel*>(self, "_textLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
}

-(void) setTextColor:(id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([[UIColor whiteColor] colorWithAlphaComponent:0.7]);
    }
    else {
        %orig;
    }
}

%end

%hook CKTranscriptRecipientCell // 8

-(void)layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        MSHookIvar<UILabel*>(self, "_nameLabel").textColor = [UIColor whiteColor];
    }
}

%end

// BITESMS FIXES

%hook UITableViewCellContentView

-(void)layoutSubviews {
    %orig;
    if ([self.superview.superview isKindOfClass:%c(BSPreferenceCell)] && darkMode && isMobileSMSActive()) {
        for (id o in self.subviews) {
            if ([o isKindOfClass:%c(UILabel)]) {
                UILabel* l = (UILabel*)o;
                l.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            }
        }
    }
}

%end

%hook UITableViewCellScrollView

-(void)layoutSubviews {
    %orig;
    if ([self.superview isKindOfClass:%c(BSPreferenceCell)] && darkMode && isMobileSMSActive()) {
        for (id o in self.subviews) {
            if ([o isKindOfClass:%c(UILabel)]) {
                UILabel* l = (UILabel*)o;
                l.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            }
        }
    }
}

%end

//////////////////

%hook MFRecipientTableViewCellDetailView

- (void)setBackgroundColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([UIColor clearColor]);
    }
    else {
        %orig;
    }
}

-(void) layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        if (! [self.superview.superview.superview isKindOfClass:%c(CKRecipientTableViewCell)]) {
            MSHookIvar<UILabel*>(self, "_detailLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            MSHookIvar<UILabel*>(self, "_labelLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        }
    }
}

%end

%hook MFRecipientTableViewCellTitleView

- (void)setBackgroundColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([UIColor clearColor]);
    }
    else {
        %orig;
    }
}

-(void) layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        if (! [self.superview.superview.superview isKindOfClass:%c(CKRecipientTableViewCell)]) {
            MSHookIvar<UILabel*>(self, "_titleLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        }
    }
}

%end

%hook _UITableViewCellSeparatorView

- (void)_setBackgroundColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([[UIColor whiteColor] colorWithAlphaComponent:0.4]);
    }
    else {
        %orig;
    }
}

%end

%hook CKRecipientTableViewCell

+ (id)_defaultTintColor {
    if (darkMode) {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    else {
        return %orig;
    }
}

-(void) setTintColor:(id)arg1 animated:(BOOL)arg2 {
    if (darkMode) {
        if (arg1 != iMRecipCol && arg1 != SMSRecipCol) {
            %orig([[UIColor whiteColor] colorWithAlphaComponent:0.7], arg2);
        }
        else {
            %orig;
        }
    }
    else {
        %orig;
    }
}

-(void) setShouldDimIrrelevantInformation:(BOOL)arg1 {
    if (darkMode) {
        %orig(NO);
    }
    else {
        %orig;
    }
}

%end

%hook UITableViewCellSelectedBackground

- (void)setSelectionTintColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig(DarkGreyColour);
    }
    else {
        %orig;
    }
}

%end

%hook ABPropertyCell

- (id)valueLabel {
    if (darkMode && isMobileSMSActive()) {
        UILabel* o = %orig;
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        return o;
    }
    else {
        return %orig;
    }
}

%end

%hook ABPropertyAlertCell

-(void)layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        MSHookIvar<UILabel*>(self, "_valueLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
}

%end

%hook ABContactCell

- (void)setSeparatorColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([[UIColor whiteColor] colorWithAlphaComponent:0.4]);
    }
    else {
        %orig;
    }
}

%end

%hook ABLinkedCardsCell

- (id)nameLabel {
    if (darkMode && isMobileSMSActive()) {
        UILabel* o = %orig;
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        return o;
    }
    else {
        return %orig;
    }
}

%end

%hook ABFaceTimeCell

-(id)faceTimeLabel {
    if (darkMode && isMobileSMSActive()) {
        UILabel* o = %orig;
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        return o;
    }
    else {
        return %orig;
    }
}

-(void) setFaceTimeLabel:(id)arg1 {
    UILabel* o = arg1;
    if (darkMode && isMobileSMSActive()) {
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    %orig(o);
}

-(void) setLabelTextAttributes:(id)arg1 {
    %orig;
    if (darkMode  && isMobileSMSActive()) {
        MSHookIvar<UILabel*>(self, "_faceTimeLabel").textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
}

%end

%hook UITextField

- (void)setTextColor : (id)arg1 {
    if (darkMode && isMobileSMSActive() && ! [self isKindOfClass:%c(CKMessageEntryTextView)]) {
        if (arg1 != iMRecipCol && arg1 != SMSRecipCol) {
            %orig([[UIColor whiteColor] colorWithAlphaComponent:0.7]);
        }
        else {
            %orig;
        }
    }
    else {
        %orig;
    }
}

-(id) _placeholderColor {
    if (darkMode && isMobileSMSActive()) {
        return [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    else {
        return %orig;
    }
}

%end

%hook ABContactView

- (void)setBackgroundColor : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([UIColor clearColor]);
    }
    else {
        %orig;
    }
}

%end

%hook ABGroupHeaderFooterView

- (void)layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        MSHookIvar<UIView*>(self, "_backgroundView").backgroundColor = BlackColour;
    }
}

-(id) titleLabel {
    UILabel* o = %orig;
    if (darkMode && isMobileSMSActive()) {
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return o;
}

-(id) topSeparatorView {
    UIView* o = %orig;
    if (darkMode && isMobileSMSActive()) {
        o.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    }
    return o;
}

-(id) bottomSeparatorView {
    UIView* o = %orig;
    if (darkMode && isMobileSMSActive()) {
        o.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    }
    return o;
}

%end

%hook ABMemberNameView

- (id)meLabel {
    UILabel* o = %orig;
    if (darkMode && isMobileSMSActive()) {
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        o.backgroundColor = [UIColor clearColor];
    }
    return o;
}

-(id) nameLabel {
    UILabel* o = %orig;
    if (darkMode && isMobileSMSActive()) {
        o.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        o.backgroundColor = [UIColor clearColor];
    }
    return o;
}

-(void) layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        self.backgroundColor = BlackColour;
    }
}

%end

%hook UISearchBarTextField

- (id)backgroundColor {
    if (darkMode && isMobileSMSActive()) {
        return DarkGreyColour;
    }
    else {
        return %orig;
    }
}

-(id) textColor {
    if (darkMode && isMobileSMSActive()) {
        return [UIColor whiteColor];
    }
    else {
        return %orig;
    }
}

-(void) setTextColor:(id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        %orig([UIColor whiteColor]);
    }
    else {
        %orig;
    }
}

%end

%hook PUAlbumListCellContentView

- (void)_setSubtitleLabel : (id)arg1 {
    if (darkMode && isMobileSMSActive()) {
        UILabel* l = arg1;
        l.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        %orig(l);
    }
    else {
        %orig;
    }
}

%end

%hook PUCollectionView

-(void)layoutSubviews {
    %orig;
    if (darkMode && isMobileSMSActive()) {
        self.backgroundColor = BlackColour;
    }
}

%end

%hook CKUIBehavior

-(UIColor*)detailsBackgroundColor {
    if (darkMode && isMobileSMSActive()) {
        return BlackColour;
    }
    else {
        return %orig;
    }
}

%end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

%hook UIApplication

- (id)keyWindow {
    if (isMobileSMSActive()) {
        UIWindow* w = %orig;
        NSInteger tR = 0;
        NSInteger tG = 122;
        NSInteger tB = 255;

        if ([preferences objectForKey:@"TintRed"] != nil) {
            tR = [[preferences objectForKey:@"TintRed"] integerValue];
        }

        if ([preferences objectForKey:@"TintGreen"] != nil) {
            tG = [[preferences objectForKey:@"TintGreen"] integerValue];
        }

        if ([preferences objectForKey:@"TintBlue"] != nil) {
            tB = [[preferences objectForKey:@"TintBlue"] integerValue];
        }

        UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];

        w.tintColor = col;
        return w;
    }
    else {
        return %orig;
    }
}

%end

%hook CKBalloonView

- (BOOL)isFilled {
    BOOL outline = [[preferences objectForKey:@"BubbleOutlineOnly"] boolValue];
    if (outline) {
        return NO;
    }
    else {
        return %orig;
    }
}

-(BOOL) hasTail {
    NSInteger hideTails = [[preferences objectForKey:@"BubbleTails"] intValue];
    if (hideTails == 1) {
        return %orig;
    }
    else if (hideTails == 2) {
        return YES;
    }
    else if (hideTails == 3) {
        return NO;
    }
    else {
        return %orig;
    }
}

-(BOOL) canUseOpaqueMask {
    BOOL outline = [[preferences objectForKey:@"BubbleOutlineOnly"] boolValue];
    NSInteger preset = [[preferences objectForKey:@"BackgroundPreset"] integerValue];
    if (outline || preset == 25 || preset == 50) {
        return NO;
    }
    else {
        return %orig;
    }
}

%end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// check if group convo
static BOOL isGroup;

%hook CKConversation

- (BOOL)isGroupConversation {
    BOOL g = %orig;
    isGroup = g;
    return g;
}

%end

%hook CKUIBehavior

- (id)appTintColor {
    NSInteger tR = 0;
    NSInteger tG = 122;
    NSInteger tB = 255;

    if ([preferences objectForKey:@"TintRed"] != nil) {
        tR = [[preferences objectForKey:@"TintRed"] integerValue];
    }

    if ([preferences objectForKey:@"TintGreen"] != nil) {
        tG = [[preferences objectForKey:@"TintGreen"] integerValue];
    }

    if ([preferences objectForKey:@"TintBlue"] != nil) {
        tB = [[preferences objectForKey:@"TintBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id) green_balloonColors {
    UIColor* cTop;
    UIColor* cBot;

    NSInteger preset =  [[preferences objectForKey:@"SMSBubbleColour"] integerValue];

    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 9;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        BOOL alpEmpty = [preferences objectForKey:@"SMSBubbleTopAlpha"] == nil;
        NSInteger alp = [[preferences objectForKey:@"SMSBubbleTopAlpha"] integerValue];
        if (alpEmpty) {
            alp = 100;
        }
        col = [col colorWithAlphaComponent:alp/100.0];
        NSArray* a = [NSArray arrayWithObjects:col, col, nil];
        return a;
    }
    else {
        CGFloat tR, bR;
        tR = bR = 76;
        if ([preferences objectForKey:@"SMSBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"SMSBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 217;
        if ([preferences objectForKey:@"SMSBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"SMSBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 100;
        if ([preferences objectForKey:@"SMSBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"SMSBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"SMSBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"SMSBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"SMSBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"SMSBubbleGradient"] boolValue];

        if (grad) {
            cTop = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
            cBot = [UIColor colorWithRed:bR/255.0 green:bG/255.0 blue:bB/255.0 alpha:1];
        }
        else {
            cTop = cBot = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
        }

        BOOL alpEmpty = [preferences objectForKey:@"SMSBubbleTopAlpha"] == nil;
        NSInteger alp = [[preferences objectForKey:@"SMSBubbleTopAlpha"] integerValue];
        if (alpEmpty) {
            alp = 100;
        }

        cTop = [cTop colorWithAlphaComponent:alp/100.0];
        cBot = [cBot colorWithAlphaComponent:alp/100.0];
        NSArray* a = [NSArray arrayWithObjects:cTop, cBot, nil];
        return a;
    }
}

-(id) green_balloonTextColor {
    CGFloat tR, tG, tB;
    tR = tG = tB = 255;
    if ([preferences objectForKey:@"SMSTextRed"] != nil) {
        tR = [[preferences objectForKey:@"SMSTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"SMSTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"SMSTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"SMSTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"SMSTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

-(id) green_balloonTextLinkColor {
    CGFloat tR, tG, tB;
    tR = tG = tB = 255;
    if ([preferences objectForKey:@"SMSTextRed"] != nil) {
        tR = [[preferences objectForKey:@"SMSTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"SMSTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"SMSTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"SMSTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"SMSTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

-(id) green_sendButtonColor {
    NSInteger preset =  [[preferences objectForKey:@"SMSBubbleColour"] integerValue];
    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 9;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        return col;
    }
    else {
        CGFloat cR, cG, cB = 0;

        CGFloat tR, bR;
        tR = bR = 76;
        if ([preferences objectForKey:@"SMSBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"SMSBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 217;
        if ([preferences objectForKey:@"SMSBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"SMSBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 100;
        if ([preferences objectForKey:@"SMSBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"SMSBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"SMSBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"SMSBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"SMSBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"SMSBubbleGradient"] boolValue];
        if (grad) {
            cR = bR;
            cG = bG;
            cB = bB;
        }
        else {
            cR = tR;
            cG = tG;
            cB = tB;
        }

        if (blackBars) {
            if (cR+cG+cB < 75) {
                cR += 75;
                cG += 75;
                cB += 75;
            }
        }
        else {
            if (cR+cG+cB > 680) {
                cR -= 75;
                cG -= 75;
                cB -= 75;
            }
        }

        UIColor* col = [UIColor colorWithRed:cR/255.0 green:cG/255.0 blue:cB/255.0 alpha:1];
        return col;
    }
}

-(id) green_recipientTextColor {
    NSInteger preset =  [[preferences objectForKey:@"SMSBubbleColour"] integerValue];
    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 8;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        return col;
    }
    else {
        CGFloat cR, cG, cB = 0;

        CGFloat tR, bR;
        tR = bR = 76;
        if ([preferences objectForKey:@"SMSBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"SMSBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 217;
        if ([preferences objectForKey:@"SMSBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"SMSBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 100;
        if ([preferences objectForKey:@"SMSBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"SMSBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"SMSBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"SMSBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"SMSBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"SMSBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"SMSBubbleGradient"] boolValue];
        if (grad) {
            cR = bR;
            cG = bG;
            cB = bB;
        }
        else {
            cR = tR;
            cG = tG;
            cB = tB;
        }

        if (blackBars) {
            if (cR+cG+cB < 75) {
                cR += 75;
                cG += 75;
                cB += 75;
            }
        }
        else {
            if (cR+cG+cB > 680) {
                cR -= 75;
                cG -= 75;
                cB -= 75;
            }
        }

        UIColor* col = [UIColor colorWithRed:cR/255.0 green:cG/255.0 blue:cB/255.0 alpha:1];
        return col;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id) blue_balloonColors {
    UIColor* cTop;
    UIColor* cBot;

    NSInteger preset =  [[preferences objectForKey:@"IMBubbleColour"] integerValue];

    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 9;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        BOOL alpEmpty = [preferences objectForKey:@"IMBubbleTopAlpha"] == nil;
        NSInteger alp = [[preferences objectForKey:@"IMBubbleTopAlpha"] integerValue];
        if (alpEmpty) {
            alp = 100;
        }
        col = [col colorWithAlphaComponent:alp/100.0];
        NSArray* a = [NSArray arrayWithObjects:col, col, nil];
        return a;
    }
    else {
        CGFloat tR, bR;
        tR = bR = 0;
        if ([preferences objectForKey:@"IMBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"IMBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 122;
        if ([preferences objectForKey:@"IMBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"IMBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 255;
        if ([preferences objectForKey:@"IMBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"IMBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"IMBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"IMBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"IMBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"IMBubbleGradient"] boolValue];

        if (grad) {
            cTop = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
            cBot = [UIColor colorWithRed:bR/255.0 green:bG/255.0 blue:bB/255.0 alpha:1];
        }
        else {
            cTop = cBot = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
        }

        BOOL alpEmpty = [preferences objectForKey:@"IMBubbleTopAlpha"] == nil;
        NSInteger alp = [[preferences objectForKey:@"IMBubbleTopAlpha"] integerValue];
        if (alpEmpty) {
            alp = 100;
        }

        cTop = [cTop colorWithAlphaComponent:alp/100.0];
        cBot = [cBot colorWithAlphaComponent:alp/100.0];
        NSArray* a = [NSArray arrayWithObjects:cTop, cBot, nil];
        return a;
    }
}

-(id) blue_balloonTextColor {
    CGFloat tR, tG, tB;
    tR = tG = tB = 255;
    if ([preferences objectForKey:@"IMTextRed"] != nil) {
        tR = [[preferences objectForKey:@"IMTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"IMTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"IMTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"IMTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"IMTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

-(id) blue_balloonTextLinkColor {
    CGFloat tR, tG, tB;
    tR = tG = tB = 255;
    if ([preferences objectForKey:@"IMTextRed"] != nil) {
        tR = [[preferences objectForKey:@"IMTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"IMTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"IMTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"IMTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"IMTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

-(id) blue_sendButtonColor {
    NSInteger preset =  [[preferences objectForKey:@"IMBubbleColour"] integerValue];
    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 9;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        return col;
    }
    else {
        CGFloat cR, cG, cB = 0;

        CGFloat tR, bR;
        tR = bR = 0;
        if ([preferences objectForKey:@"IMBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"IMBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 122;
        if ([preferences objectForKey:@"IMBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"IMBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 255;
        if ([preferences objectForKey:@"IMBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"IMBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"IMBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"IMBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"IMBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"IMBubbleGradient"] boolValue];
        if (grad) {
            cR = bR;
            cG = bG;
            cB = bB;
        }
        else {
            cR = tR;
            cG = tG;
            cB = tB;
        }

        if (blackBars) {
            if (cR+cG+cB < 75) {
                cR += 75;
                cG += 75;
                cB += 75;
            }
        }
        else {
            if (cR+cG+cB > 680) {
                cR -= 75;
                cG -= 75;
                cB -= 75;
            }
        }

        UIColor* col = [UIColor colorWithRed:cR/255.0 green:cG/255.0 blue:cB/255.0 alpha:1];
        return col;
    }
}

-(id) blue_recipientTextColor {
    NSInteger preset =  [[preferences objectForKey:@"IMBubbleColour"] integerValue];
    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 8;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        return col;
    }
    else {
        CGFloat cR, cG, cB = 0;

        CGFloat tR, bR;
        tR = bR = 0;
        if ([preferences objectForKey:@"IMBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"IMBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 122;
        if ([preferences objectForKey:@"IMBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"IMBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 255;
        if ([preferences objectForKey:@"IMBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"IMBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"IMBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"IMBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"IMBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"IMBubbleGradient"] boolValue];
        if (grad) {
            cR = bR;
            cG = bG;
            cB = bB;
        }
        else {
            cR = tR;
            cG = tG;
            cB = tB;
        }

        if (blackBars) {
            if (cR+cG+cB < 75) {
                cR += 75;
                cG += 75;
                cB += 75;
            }
        }
        else {
            if (cR+cG+cB > 680) {
                cR -= 75;
                cG -= 75;
                cB -= 75;
            }
        }

        UIColor* col = [UIColor colorWithRed:cR/255.0 green:cG/255.0 blue:cB/255.0 alpha:1];
        return col;
    }
}

/////////////////////////////////////// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id) gray_balloonColors {
    UIColor* cTop;
    UIColor* cBot;

    NSInteger preset =  [[preferences objectForKey:@"OtherBubbleColour"] integerValue];

    if (preset == 42) {
        UIColor* col = nil;
        NSInteger rand = arc4random() % 9;
        switch (rand) {
            case 0:
                col = DarkBlueColour;
                break;

            case 1:
                col = LightBlueColour;
                break;

            case 2:
                col = RedColour;
                break;

            case 3:
                col = OrangeColour;
                break;

            case 4:
                col = YellowColour;
                break;

            case 5:
                col = PinkColour;
                break;

            case 6:
                col = PurpleColour;
                break;

            case 7:
                col = TealColour;
                break;

            case 8:
                col = MaroonColour;
                break;

            default:
                col = DarkBlueColour;
                break;
        }
        BOOL alpEmpty = [preferences objectForKey:@"OtherBubbleTopAlpha"] == nil;
        NSInteger alp = [[preferences objectForKey:@"OtherBubbleTopAlpha"] integerValue];
        if (alpEmpty) {
            alp = 100;
        }
        col = [col colorWithAlphaComponent:alp/100.0];
        NSArray* a = [NSArray arrayWithObjects:col, col, nil];
        return a;
    }
    else {
        CGFloat tR, bR;
        tR = bR = 227;
        if ([preferences objectForKey:@"OtherBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"OtherBubbleTopRed"] integerValue];
        }

        CGFloat tG, bG;
        tG = bG = 229;
        if ([preferences objectForKey:@"OtherBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"OtherBubbleTopGreen"] integerValue];
        }

        CGFloat tB, bB;
        tB = bB = 233;
        if ([preferences objectForKey:@"OtherBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"OtherBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"OtherBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"OtherBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"OtherBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"OtherBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"OtherBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"OtherBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"OtherBubbleGradient"] boolValue];

        if (grad) {
            cTop = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
            cBot = [UIColor colorWithRed:bR/255.0 green:bG/255.0 blue:bB/255.0 alpha:1];
        }
        else {
            cTop = cBot = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
        }

        BOOL alpEmpty = [preferences objectForKey:@"OtherBubbleTopAlpha"] == nil;
        NSInteger alp = [[preferences objectForKey:@"OtherBubbleTopAlpha"] integerValue];
        if (alpEmpty) {
            alp = 100;
        }

        cTop = [cTop colorWithAlphaComponent:alp/100.0];
        cBot = [cBot colorWithAlphaComponent:alp/100.0];
        NSArray* a = [NSArray arrayWithObjects:cTop, cBot, nil];
        return a;
    }
}

-(id) gray_balloonTextColor {
    CGFloat tR, tG, tB;
    tR = tG = tB = 0;
    if ([preferences objectForKey:@"OtherTextRed"] != nil) {
        tR = [[preferences objectForKey:@"OtherTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"OtherTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"OtherTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"OtherTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"OtherTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

-(id) gray_balloonTextLinkColor {
    CGFloat tR, tG, tB;
    tR = tG = tB = 0;
    if ([preferences objectForKey:@"OtherTextRed"] != nil) {
        tR = [[preferences objectForKey:@"OtherTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"OtherTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"OtherTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"OtherTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"OtherTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

/////////////////////////////////////// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Contact image diameters

-(CGFloat) transcriptContactImageDiameter {
    CGFloat rad = [[preferences objectForKey:@"CPicRadius"] floatValue];
    if (rad == 0) {
        rad = %orig;
    }
    return rad;
}

-(CGFloat) conversationListMultipleContactsImageDiameter {
    CGFloat rad = [[preferences objectForKey:@"CPicRadiusList"] floatValue];
    rad /= 1.67;
    if (rad == 0) {
        rad = %orig;
    }
    return rad;
}

-(CGFloat) conversationListContactImageDiameter {
    CGFloat rad = [[preferences objectForKey:@"CPicRadiusList"] floatValue];
    if (rad == 0) {
        rad = %orig;
    }
    return rad;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// FLAT EDGES

-(CGFloat) balloonMaskTailWidth {
    BOOL b = [[preferences objectForKey:@"FlatEdges"] floatValue];
    if (b) {
        return 50.0;
    }
    else {
        return %orig;
    }
}

// CONTACT PICS IN LIST VIEW

-(BOOL) useContactPhotosInConversationList {
    BOOL pics = [[preferences objectForKey:@"ListContactPics"] boolValue];
    return pics;
}

-(BOOL) shouldShowContactPhotosInConversationList { //8
    BOOL pics = [[preferences objectForKey:@"ListContactPics"] boolValue];
    return pics;
}

-(BOOL) shouldShowContactPhotosInTranscript { // groups on 8
    if (isGroup) {
        return ! [[preferences objectForKey:@"GroupContactPics"] boolValue] && ! [[preferences objectForKey:@"FlatEdges"] boolValue];
    }
    else {
        return %orig;
    }
}

-(id) transcriptTextColor {
    NSInteger tR = 100;
    NSInteger tG = 100;
    NSInteger tB = 100;

    if ([preferences objectForKey:@"InfoTextRed"] != nil) {
        tR = [[preferences objectForKey:@"InfoTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"InfoTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"InfoTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"InfoTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"InfoTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];

    return col;
}

-(id) transcriptBackgroundColor {
    NSInteger preset = [[preferences objectForKey:@"BackgroundPreset"] integerValue];

    if (preset == 25 || preset == 50) {
        return [UIColor clearColor];
    }

    NSInteger tR = 255;
    NSInteger tG = 255;
    NSInteger tB = 255;

    if ([preferences objectForKey:@"BackgroundRed"] != nil) {
        tR = [[preferences objectForKey:@"BackgroundRed"] integerValue];
    }

    if ([preferences objectForKey:@"BackgroundGreen"] != nil) {
        tG = [[preferences objectForKey:@"BackgroundGreen"] integerValue];
    }

    if ([preferences objectForKey:@"BackgroundBlue"] != nil) {
        tB = [[preferences objectForKey:@"BackgroundBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    return col;
}

%end

// COLOUR FOR TYPING INDICATOR DOTS + fix for flat edges

%hook CKTypingIndicatorLayer

- (id)thinkingDot {
    NSInteger tR, tG, tB;
    tR = tG = tB = 0;
    if ([preferences objectForKey:@"OtherTextRed"] != nil) {
        tR = [[preferences objectForKey:@"OtherTextRed"] integerValue];
    }

    if ([preferences objectForKey:@"OtherTextGreen"] != nil) {
        tG = [[preferences objectForKey:@"OtherTextGreen"] integerValue];
    }

    if ([preferences objectForKey:@"OtherTextBlue"] != nil) {
        tB = [[preferences objectForKey:@"OtherTextBlue"] integerValue];
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];

    CALayer* dot = %orig;
    dot.backgroundColor = col.CGColor;
    BOOL b = [[preferences objectForKey:@"FlatEdges"] boolValue];
    if (b) {
        CGRect frame = dot.frame;
        frame.origin.x += 6;
        dot.frame = frame;
    }
    return dot;
}

// fix for flat bubble edges
-(id) largeBubble {
    BOOL b = [[preferences objectForKey:@"FlatEdges"] boolValue];
    if (b) {
        CALayer* b = %orig;
        CGRect frame = b.frame;
        frame.size.width = 80;
        b.frame = frame;
        return b;
    }
    else {
        return %orig;
    }
}

%end

%hook CKTranscriptDataRow

- (BOOL)wantsContactImageLayout {
    CKIMMessage* mes = self.message;
    BOOL showOwn =  [[preferences objectForKey:@"MyContactPics"] boolValue];
    if (showOwn) {
        if (isGroup) {
            BOOL pics = [[preferences objectForKey:@"GroupContactPics"] boolValue];
            return ! pics;
        }
        else {
            BOOL pics = [[preferences objectForKey:@"SingleContactPics"] boolValue];
            return pics;
        }
    }
    else if (! mes.isFromMe) {
        if (isGroup) {
            BOOL pics = [[preferences objectForKey:@"GroupContactPics"] boolValue];
            return ! pics;
        }
        else {
            BOOL pics = [[preferences objectForKey:@"SingleContactPics"] boolValue];
            return pics;
        }
    }
    else {
        return NO;
    }
}

%end

%hook CKTranscriptMessageCell  //8

static NSObject * cPicObj = [NSObject new];

-(void) configureForChatItem:(CKChatItem*)arg1 {
    BOOL wantsContactPic = NO;
    if (! [[preferences objectForKey:@"FlatEdges"] boolValue]) {
        BOOL fromMe = arg1.IMChatItem.isFromMe;
        wantsContactPic = (fromMe && [[preferences objectForKey:@"MyContactPics"] boolValue]) || (! fromMe && ! isGroup && [[preferences objectForKey:@"SingleContactPics"] boolValue]);
        if (wantsContactPic && arg1.hasTail) {
            CGFloat d = [[%c(CKUIBehavior) sharedBehaviors] transcriptContactImageDiameter];
            self.contactImage = [CKAddressBook transcriptContactImageOfDiameter:d forRecordID:arg1.IMChatItem.sender.person._recordID];
        }
        else {
            CGFloat d = [[%c(CKUIBehavior) sharedBehaviors] transcriptContactImageDiameter];
            UIGraphicsBeginImageContext(CGSizeMake(d, d));
            self.contactImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    objc_setAssociatedObject(cPicObj, (__bridge void*)self, [NSNumber numberWithInt:wantsContactPic], OBJC_ASSOCIATION_RETAIN);
    %orig;
}

-(void) setContactImage:(id)a {
    BOOL wantsContactPic = [objc_getAssociatedObject(cPicObj, (__bridge void*)self) boolValue];
    if ((wantsContactPic && a != nil) || ! wantsContactPic) {
        %orig;
    }
}

%end

// FIX BACKGROUND OF VIEWS FOR CUSTOM BG AND PAGED SCROLLING

%hook CKTranscriptCollectionViewController

-(id)contentScrollView {
    UIScrollView* sv = %orig;
    BOOL paging = [[preferences objectForKey:@"PagedScrolling"] boolValue];
    if (paging) {
        sv.pagingEnabled = YES;
    }
    return sv;
}

-(id) collectionView {
    CKTranscriptCollectionView* cv = %orig;
    cv.backgroundColor = [UIColor clearColor];
    return cv;
}

%end

/// fix for hiding multi recip header

%hook CKTranscriptCollectionView

-(void)setContentInset : (UIEdgeInsets)arg1 {
    UIEdgeInsets o = arg1;
    BOOL h = [[preferences objectForKey:@"HideMultiRecipHeader"] boolValue];
    if (h) {
        %orig(UIEdgeInsetsMake(65.5, o.left, o.bottom, o.right));
    }
    else {
        %orig;
    }
}

-(void) setContentOffset:(CGPoint)arg1 {
    BOOL h = [[preferences objectForKey:@"HideMultiRecipHeader"] boolValue];
    if (h && arg1.y == -109.5 && isGroup) {
        %orig(CGPointMake(0, -65.5));
    }
    else {
        %orig;
    }
}

%end

////////////////////////////////////////////////////////////////////////////////////////////////////////

// FIX BACKGROUND OF MESSAGE TYPING VIEW + CUSTOM TOOLBAR BACKGROUNDS + FIX STATUS BAR FOR BLACK + CUSTOM KEYBOARD COLOUR

// STATUSBAR

%hook UIStatusBar

- (void)layoutSubviews {
    %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb && isMobileSMSActive()) {
        [self requestStyle:UIStatusBarStyleLightContent];
    }
}

%end

// text color in new convo typing view
%hook CKComposeRecipientView

- (id)textField {
    UITextField* o = %orig;

    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb && isMobileSMSActive()) {
        o.textColor = [UIColor whiteColor];
    }

    return o;
}

%end

//KEYBOARD
%hook UITextInputTraits

- (NSInteger)keyboardAppearance {
    BOOL bk = [[preferences objectForKey:@"BlackKeyboard"] boolValue];
    if (bk && isMobileSMSActive()) {
        return 1;
    }
    else {
        return %orig;
    }
}

%end
// NAV BARS

%hook UINavigationBar

- (void)_setBarStyle : (NSInteger)arg1 {
    BOOL needsFix = NO;
    NSString* reqSysVer = @"7.1";
    NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
        needsFix = YES;
    }

    if ([self.superview.superview.superview isKindOfClass:%c(_UIPopoverView)] && needsFix) {
        %orig;
    }
    else {
        BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
        if (bb && isMobileSMSActive()) {
            %orig(1);
        }
        else {
            %orig;
        }
    }
}

%end

// TOOL BARS
%hook UIToolbar

- (void)layoutSubviews {
    %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb && isMobileSMSActive()) {
        [self setBarStyle:1];
    }
}

%end

// MESSAGE ENTRY VIEW BG AND INPUT FIELD FIX

%hook CKMessageEntryView

-(void)layoutSubviews {
    %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb) {
        [self.backdropView transitionToSettings:[_UIBackdropViewSettings settingsForStyle:1]];
    }
}

-(void) setKnocksOutTextField:(BOOL)arg1 {
    %orig(NO);
}

%end

%hook CKMessageEntryTextView

-(void)updateTextView {
    %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb && ! [self.superview isKindOfClass:%c(BSQuickReplyTextField)]) {
        [self setTextColor:[UIColor whiteColor]];
    }
}

%end

%hook _UITextFieldRoundedRectBackgroundViewNeue

- (void)layoutSubviews {
    %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb  && isMobileSMSActive()) {
        [self setFillColor:nil];
        [self setStrokeColor:nil];
    }
}

-(void) setFillColor:(id)arg1 {
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb && [self.superview isKindOfClass:%c(CKMessageEntryView)] && isMobileSMSActive()) {
        %orig([UIColor colorWithWhite:1 alpha:0.2]);
    }
    else {
        %orig;
    }
}

-(void) setStrokeColor:(id)arg1 {
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb && [self.superview isKindOfClass:%c(CKMessageEntryView)]  && isMobileSMSActive()) {
        %orig([UIColor clearColor]);
    }
    else {
        %orig;
    }
}

%end

// TEXT COLOUR FIX FOR RECIPIENT CELLS
%hook CKMultipleRecipientTableViewCell

- (id)nameLabel {
    UILabel* l = %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb) {
        l.textColor = [UIColor whiteColor];
    }
    return l;
}

%end

%hook CKMultipleRecipientCollapsedTableViewCell

- (void)layoutSubviews {
    %orig;
    BOOL bb = [[preferences objectForKey:@"BlackBars"] boolValue];
    if (bb) {
        self.selectedBackgroundView.alpha = 0.2;
    }
}

%end

// hide recipient header in group
%hook CKMultipleRecipientHeaderController

- (BOOL)hiddenWhenCollapsedForOrientation : (NSInteger)arg1 {
    BOOL h = [[preferences objectForKey:@"HideMultiRecipHeader"] boolValue];
    if (h) {
        return YES;
    }
    else {
        return %orig;
    }
}

%end

// TYPING BAR COLOUR

%hook UITextSelectionView

- (id)caretView {
    UIView* c = %orig;
    if ([self.superview.superview isKindOfClass:%c(CKMessageEntryRichTextView)]) {
        NSInteger tR = 0;
        NSInteger tG = 122;
        NSInteger tB = 255;

        if ([preferences objectForKey:@"TintRed"] != nil) {
            tR = [[preferences objectForKey:@"TintRed"] integerValue];
        }

        if ([preferences objectForKey:@"TintGreen"] != nil) {
            tG = [[preferences objectForKey:@"TintGreen"] integerValue];
        }

        if ([preferences objectForKey:@"TintBlue"] != nil) {
            tB = [[preferences objectForKey:@"TintBlue"] integerValue];
        }

        if (tR+tG+tB > 680 && ! blackBars) {               // TOO LIGHT
            tR *= 0.75;
            tG *= 0.75;
            tB *= 0.75;
        }
        UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];

        c.backgroundColor = col;
    }
    return c;
}

%end

/// FIX CONVO LIST FOR PICTURES

%hook CKConversationListCell

+ (CGFloat)cellHeight {
    CGFloat rad = [[preferences objectForKey:@"CPicRadiusList"] floatValue];
    if (rad == 0) {
        return %orig;
    }
    else if (rad + 10 > %orig) {
        return rad + 10;
    }
    else {
        return %orig;
    }
}

-(void) layoutSubviews {
    %orig;

    UILabel* date = MSHookIvar<UILabel*>(self, "_dateLabel");

    if (darkMode) {
        UILabel* title = MSHookIvar<UILabel*>(self, "_fromLabel");
        UILabel* detail = MSHookIvar<UILabel*>(self, "_summaryLabel");

        UIColor* pCol = [UIColor whiteColor];
        UIColor* sCol = [[UIColor whiteColor] colorWithAlphaComponent:0.7];

        title.textColor = pCol;
        date.textColor = sCol;
        detail.textColor = sCol;
    }

    BOOL pics = [[preferences objectForKey:@"ListContactPics"] boolValue];
    if (pics) {
        CGRect frame = self.contentView.frame;
        frame.origin.x -= 10;
        frame.size.width += 10;
        [self.contentView setFrame:frame];

        CGRect dateFrame = date.frame;
        dateFrame.origin.x += 10;
        date.frame = dateFrame;

        UIView* chevron = MSHookIvar<UIView*>(self, "_chevronImageView");
        CGRect chevFrame = chevron.frame;
        chevFrame.origin.x += 10;
        chevron.frame = chevFrame;

        UIImageView* gv = MSHookIvar<UIImageView*>(self, "_recipientPhotoView");
        if (gv) {
            UITableView* table = (UITableView*)self.superview.superview;
            NSIndexPath* pathOfTheCell = [table indexPathForCell:self];
            CKConversation* c = [[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:pathOfTheCell.row];
            if (c.isGroupConversation) {
                CGRect picFrame = gv.frame;
                picFrame.origin.y += 4;
                gv.frame = picFrame;
            }
        }
    }

    BOOL hideDate = [[preferences objectForKey:@"HideDates"] boolValue];
    if (hideDate) {
        date.hidden = YES;
    }

    BOOL hidePrev = [[preferences objectForKey:@"HidePreviews"] boolValue];
    if (hidePrev) {
        UILabel* preview = MSHookIvar<UILabel*>(self, "_summaryLabel");
        preview.hidden = YES;
    }

    UIImageView* unread = MSHookIvar<UIImageView*>(self, "_unreadIndicatorImageView");

    NSInteger tR = 0;
    NSInteger tG = 122;
    NSInteger tB = 255;

    if ([preferences objectForKey:@"TintRed"] != nil) {
        tR = [[preferences objectForKey:@"TintRed"] integerValue];
    }

    if ([preferences objectForKey:@"TintGreen"] != nil) {
        tG = [[preferences objectForKey:@"TintGreen"] integerValue];
    }

    if ([preferences objectForKey:@"TintBlue"] != nil) {
        tB = [[preferences objectForKey:@"TintBlue"] integerValue];
    }

    if (blackBars) {
        if (tR+tG+tB < 75) {
            tR += 75;
            tG += 75;
            tB += 75;
        }
    }
    else {
        if (tR+tG+tB > 680) {
            tR -= 75;
            tG -= 75;
            tB -= 75;
        }
    }

    UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];
    unread.tintColor = col;
    unread.image = [unread.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%end

// CORRECT COLOURS FOR RECIPIENTS IN CREATE CONVO VIEW

%hook MFModernAtomView

+ (id)_SMSTintColor {
    NSInteger cR, cG, cB = 0;

    NSInteger tR, bR;
    tR = bR = 76;
    if ([preferences objectForKey:@"SMSBubbleTopRed"] != nil) {
        tR = [[preferences objectForKey:@"SMSBubbleTopRed"] integerValue];
    }

    NSInteger tG, bG;
    tG = bG = 217;
    if ([preferences objectForKey:@"SMSBubbleTopGreen"] != nil) {
        tG = [[preferences objectForKey:@"SMSBubbleTopGreen"] integerValue];
    }

    NSInteger tB, bB;
    tB = bB = 100;
    if ([preferences objectForKey:@"SMSBubbleTopBlue"] != nil) {
        tB = [[preferences objectForKey:@"SMSBubbleTopBlue"] integerValue];
    }

    if ([preferences objectForKey:@"SMSBubbleBotRed"] != nil) {
        bR = [[preferences objectForKey:@"SMSBubbleBotRed"] integerValue];
    }

    if ([preferences objectForKey:@"SMSBubbleBotGreen"] != nil) {
        bG = [[preferences objectForKey:@"SMSBubbleBotGreen"] integerValue];
    }

    if ([preferences objectForKey:@"SMSBubbleBotBlue"] != nil) {
        bB = [[preferences objectForKey:@"SMSBubbleBotBlue"] integerValue];
    }

    BOOL grad = [[preferences objectForKey:@"SMSBubbleGradient"] boolValue];
    if (grad) {
        cR = bR;
        cG = bG;
        cB = bB;
    }
    else {
        cR = tR;
        cG = tG;
        cB = tB;
    }
    if (darkMode) {
        if (cR+cG+cB < 75) {
            cR += 75;
            cG += 75;
            cB += 75;
        }
    }
    else {
        if (cR+cG+cB > 680) {
            cR -= 75;
            cG -= 75;
            cB -= 75;
        }
    }
    UIColor* col = [UIColor colorWithRed:cR/255.0 green:cG/255.0 blue:cB/255.0 alpha:1];
    return col;
}

+(id) _defaultTintColor {
    if (isMobileSMSActive()) {
        NSInteger cR, cG, cB = 0;

        NSInteger tR, bR;
        tR = bR = 76;
        if ([preferences objectForKey:@"IMBubbleTopRed"] != nil) {
            tR = [[preferences objectForKey:@"IMBubbleTopRed"] integerValue];
        }

        NSInteger tG, bG;
        tG = bG = 217;
        if ([preferences objectForKey:@"IMBubbleTopGreen"] != nil) {
            tG = [[preferences objectForKey:@"IMBubbleTopGreen"] integerValue];
        }

        NSInteger tB, bB;
        tB = bB = 100;
        if ([preferences objectForKey:@"IMBubbleTopBlue"] != nil) {
            tB = [[preferences objectForKey:@"IMBubbleTopBlue"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotRed"] != nil) {
            bR = [[preferences objectForKey:@"IMBubbleBotRed"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotGreen"] != nil) {
            bG = [[preferences objectForKey:@"IMBubbleBotGreen"] integerValue];
        }

        if ([preferences objectForKey:@"IMBubbleBotBlue"] != nil) {
            bB = [[preferences objectForKey:@"IMBubbleBotBlue"] integerValue];
        }

        BOOL grad = [[preferences objectForKey:@"IMBubbleGradient"] boolValue];
        if (grad) {
            cR = bR;
            cG = bG;
            cB = bB;
        }
        else {
            cR = tR;
            cG = tG;
            cB = tB;
        }
        if (darkMode) {
            if (cR+cG+cB < 75) {
                cR += 75;
                cG += 75;
                cB += 75;
            }
        }
        else {
            if (cR+cG+cB > 680) {
                cR -= 75;
                cG -= 75;
                cB -= 75;
            }
        }
        UIColor* col = [UIColor colorWithRed:cR/255.0 green:cG/255.0 blue:cB/255.0 alpha:1];
        return col;
    }
    else {
        return %orig;
    }
}

%end

// CUSTOM BACKGROUND VIEW

CKGradientReferenceView * referenceView;
NSInteger windowWidth;
NSInteger windowHeight;

NSObject* objP = [NSObject new];
NSObject* objL = [NSObject new];

%hook CKTranscriptController

- (void)loadView {
    %orig;

    referenceView = MSHookIvar<CKGradientReferenceView*>(self, "_backPlacard");

    NSInteger preset = [[preferences objectForKey:@"BackgroundPreset"] integerValue];

    if (preset == 25) {
        NSString* wallPath = @"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap";
        if (! [[NSFileManager defaultManager] fileExistsAtPath:wallPath]) {
            wallPath = @"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap";
        }
        UIImage* image = [UIImage imageWithContentsOfCPBitmapFile:wallPath flags:nil];

        CGFloat scale = 1.0;
        if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
            CGFloat tmp = [[UIScreen mainScreen]scale];
            if (tmp > 1.5) {
                scale = 2.0;
            }
        }

        BOOL blurred = [[preferences objectForKey:@"Blurred"] boolValue];
        NSInteger imageBlurRad = [[preferences objectForKey:@"BlurRadius"] intValue];
        if (imageBlurRad == 0) {
            imageBlurRad = 20;
        }

        UIView* view = referenceView;
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
        [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
        NSInteger overlayNum = [[preferences objectForKey:@"BGOverlay"] intValue];
        UIColor* overlayColor = [UIColor clearColor];
        if (overlayNum == 2) {
            overlayColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        }
        else if (overlayNum == 3) {
            overlayColor = [UIColor colorWithWhite:0.11 alpha:0.5];
        }
        if (blurred) {
            image = [image applyEffectWithRadius:imageBlurRad andTintColour:overlayColor];
        }
        UIGraphicsEndImageContext();

        referenceView.backgroundColor = [UIColor blackColor];

        windowWidth = referenceView.frame.size.width;
        windowHeight = referenceView.frame.size.height;

        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [referenceView addSubview:imageView];
        objc_setAssociatedObject(objP, (__bridge void*)referenceView, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else if (preset == 50) {
        referenceView.backgroundColor = [UIColor blackColor];

        windowWidth = referenceView.frame.size.width;
        windowHeight = referenceView.frame.size.height;

        UIImageView* imageView = [[UIImageView alloc] initWithImage:nil];
        [imageView setFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [referenceView addSubview:imageView];
        objc_setAssociatedObject(objP, (__bridge void*)referenceView, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        NSURL* url = [NSURL URLWithString:[preferences objectForKey:@"BackgroundImagePath"]];
        BOOL blurred = [[preferences objectForKey:@"Blurred"] boolValue];
        NSInteger imageBlurRad = [[preferences objectForKey:@"BlurRadius"] intValue];
        if (imageBlurRad == 0) {
            imageBlurRad = 20;
        }
        NSInteger overlayNum = [[preferences objectForKey:@"BGOverlay"] intValue];
        UIColor* overlayColor = [UIColor clearColor];
        if (overlayNum == 2) {
            overlayColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        }
        else if (overlayNum == 3) {
            overlayColor = [UIColor colorWithWhite:0.11 alpha:0.5];
        }

        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:url resultBlock:^(ALAsset* asset) {
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            if (representation.size <= 2500000) {
                CGImageRef imageRef = [representation fullScreenImage];
                if (imageRef) {
                    UIImage* img = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:representation.orientation];
                    if (blurred) {
                        CGFloat scale = 1.0;
                        if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
                            CGFloat tmp = [[UIScreen mainScreen]scale];
                            if (tmp > 1.5) {
                                scale = 2.0;
                            }
                        }
                        UIView* view = referenceView;
                        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
                        [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
                        img = [img applyEffectWithRadius:imageBlurRad andTintColour:overlayColor];
                        UIGraphicsEndImageContext();
                    }

                    [UIView transitionWithView:imageView
                     duration:0.2f
                     options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                        imageView.image = img;                                                //imageP;
                    } completion:NULL];
                }
                else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was an error loading the background image!" delegate:self cancelButtonTitle:@"Oh No!" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Background image is too large." delegate:self cancelButtonTitle:@"Oh No!" otherButtonTitles:nil];
                [alert show];
            }
        } failureBlock:^(NSError* error) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was an error loading the background image!" delegate:self cancelButtonTitle:@"Oh No!" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

%end

// FIX CHECKMARK COLOUR

%hook CKEditableCollectionViewCell

- (void)setSelected : (BOOL)arg1 {
    %orig;
    if (arg1) {
        NSInteger tR = 0;
        NSInteger tG = 122;
        NSInteger tB = 255;

        if ([preferences objectForKey:@"TintRed"] != nil) {
            tR = [[preferences objectForKey:@"TintRed"] integerValue];
        }

        if ([preferences objectForKey:@"TintGreen"] != nil) {
            tG = [[preferences objectForKey:@"TintGreen"] integerValue];
        }

        if ([preferences objectForKey:@"TintBlue"] != nil) {
            tB = [[preferences objectForKey:@"TintBlue"] integerValue];
        }

        UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];

        UIImageView* view = self.checkmark;
        view.tintColor = col;
        view.image = [view.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        /*
           CGRect frame = CGRectMake(15,0,22,22);
           CALayer* maskLayer = [CALayer layer];
           maskLayer.frame = frame;
           maskLayer.contents = (id)view.image.CGImage;
           view.image = nil;
           view.backgroundColor = col;
           view.layer.mask = maskLayer;*/
    }
    else {
        //self.checkmark.backgroundColor = [UIColor clearColor];
    }
}

-(void) setHighlighted:(BOOL)arg1 {
    %orig;
    if (arg1) {
        NSInteger tR = 0;
        NSInteger tG = 122;
        NSInteger tB = 255;

        if ([preferences objectForKey:@"TintRed"] != nil) {
            tR = [[preferences objectForKey:@"TintRed"] integerValue];
        }

        if ([preferences objectForKey:@"TintGreen"] != nil) {
            tG = [[preferences objectForKey:@"TintGreen"] integerValue];
        }

        if ([preferences objectForKey:@"TintBlue"] != nil) {
            tB = [[preferences objectForKey:@"TintBlue"] integerValue];
        }

        UIColor* col = [UIColor colorWithRed:tR/255.0 green:tG/255.0 blue:tB/255.0 alpha:1];

        UIImageView* view = self.checkmark;
        view.tintColor = col;
        view.image = [view.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        /*
           CGRect frame = CGRectMake(15,0,22,22);
           CALayer* maskLayer = [CALayer layer];
           maskLayer.frame = frame;
           maskLayer.contents = (id)view.image.CGImage;
           view.image = nil;
           view.backgroundColor = col;
           view.layer.mask = maskLayer;*/
    }
    else {
        //self.checkmark.backgroundColor = [UIColor clearColor];
    }
}

%end

// SEARCH BAR HIDING

%hook CKConversationListController

- (void)viewDidAppear : (BOOL)arg1 {
    %orig;
    if ([[preferences objectForKey:@"HideSearchBar"] boolValue]) {
        UITableView* tv = MSHookIvar<UITableView*>(self, "_table");
        if (is_IOS_8_4) {
            CGRect frame = tv.tableHeaderView.frame;
            frame.size.height = 0;
            tv.tableHeaderView.frame = frame;
            tv.tableHeaderView = tv.tableHeaderView;
        }
        else {
            tv.tableHeaderView.hidden = YES;
        }
        if (tv.contentOffset.y == -20 || tv.contentOffset.y == -36) {
            tv.contentOffset = CGPointMake(0, -64);
        }
    }
}

-(CGFloat) heightForHeaderInTableView:(id)arg1 {
    if ([[preferences objectForKey:@"HideSearchBar"] boolValue]) {
        return 0;
    }
    else {
        return %orig;
    }
}

%end

// FIX FOR TEXT POSITIONING ISSUES
%hook CKTextBalloonView

-(void)prepareForDisplay {
    %orig;
    [(UIView*)self layoutSubviews];
}

%end

%hook CKContactBalloonView

-(void)prepareForDisplay {
    %orig;
    [(UIView*)self layoutSubviews];
}

%end

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

%ctor {
    preferences = [NSDictionary dictionaryWithContentsOfFile:PreferencesFilePath];
    if (! [preferences[@"mcEnabled"] boolValue]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR(PreferencesChangedNotification), NULL, CFNotificationSuspensionBehaviorCoalesce);
        %init;
    }
}
