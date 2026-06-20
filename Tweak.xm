#import <UIKit/UIKit.h>

static UIView *floatingButton;
static UIView *panel;
static BOOL panelVisible = NO;

static UIWindow *getWindow() {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        if (scene.activationState != UISceneActivationStateForegroundActive) continue;

        UIWindowScene *ws = (UIWindowScene *)scene;
        for (UIWindow *w in ws.windows) {
            if (w.isKeyWindow) return w;
        }
    }
    return nil;
}

static void togglePanel() {
    panelVisible = !panelVisible;
    panel.hidden = !panelVisible;
}

static void createUI() {

    UIWindow *window = getWindow();
    if (!window) return;

    // 🔵 زر عائم
    floatingButton = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 60, 60)];
    floatingButton.backgroundColor = UIColor.systemBlueColor;
    floatingButton.layer.cornerRadius = 30;

    UILabel *l = [[UILabel alloc] initWithFrame:floatingButton.bounds];
    l.text = @"M";
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = UIColor.whiteColor;

    [floatingButton addSubview:l];

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:nil action:@selector(togglePanel)];

    [floatingButton addGestureRecognizer:tap];

    [window addSubview:floatingButton];

    // 🟢 لوحة التحكم
    panel = [[UIView alloc] initWithFrame:CGRectMake(60, 280, 240, 180)];
    panel.backgroundColor = UIColor.blackColor;
    panel.layer.cornerRadius = 12;
    panel.hidden = YES;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    title.text = @"MOSTASH MENU";
    title.textColor = UIColor.whiteColor;

    [panel addSubview:title];

    [window addSubview:panel];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        createUI();
    });
}

%end
