#import <UIKit/UIKit.h>

static UIView *button;
static UIView *panel;
static BOOL panelShown = NO;

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
    panelShown = !panelShown;
    panel.hidden = !panelShown;
}

static void createUI() {

    UIWindow *window = getWindow();
    if (!window) return;

    // زر عائم
    button = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 60, 60)];
    button.backgroundColor = UIColor.systemBlueColor;
    button.layer.cornerRadius = 30;

    UILabel *label = [[UILabel alloc] initWithFrame:button.bounds];
    label.text = @"M";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;

    [button addSubview:label];

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:nil action:@selector(togglePanel)];

    [button addGestureRecognizer:tap];

    [window addSubview:button];

    // لوحة تحكم
    panel = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 250, 200)];
    panel.backgroundColor = UIColor.blackColor;
    panel.layer.cornerRadius = 12;
    panel.hidden = YES;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    title.text = @"MOSTASH PANEL";
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
