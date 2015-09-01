#import "ViewController.h"

@interface ViewController ()

- (void) handleBackButtonVisibility;
- (void) showSearchButton;
@end



@implementation ViewController

- (id) init
{
    history = [[NSMutableArray alloc] initWithObjects:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (history == nil) {
        history = [[NSMutableArray alloc] init];
    }
    
    //NSString *fullURL = @"http://auburn.edu/~atkinbp/index.html";
     NSString *fullURL = @"http://www.sachalayatan.com/";
    homeUrl = fullURL;
    
    [self loadUrl:fullURL recordUrl:YES];
    
    
    if (backButton == nil) {
        backButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                      target:self action:@selector(backClicked:)];
        
    }
    
    
    [self handleBackButtonVisibility];

    [self showSearchButton];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        
        UIImage *image = [UIImage imageNamed:@"exlogo.png"];
        
        
        
        
        CGSize newsize = self.navigationController.navigationBar.frame.size;
        UIGraphicsBeginImageContext(newsize);
        [image drawInRect:CGRectMake(0,0,newsize.width,newsize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    }
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {

        [self loadUrl:request.URL.absoluteString recordUrl:YES];
        return NO;
    }
    
    return YES;
}

- (void)backClicked:(id)sender
{
    NSLog(@"in back");
    if (history.count <= 1) {
        return;
    }
    
    [history removeObjectAtIndex:history.count - 1];
    NSURL *lastUrl = [history objectAtIndex:history.count - 1];

    [self loadUrl:[lastUrl absoluteString] recordUrl:NO];
    
    [self handleBackButtonVisibility];
}

- (void)loadUrl:(NSString *)urlLink recordUrl:(BOOL)newVisit
{
    NSURL *url = [NSURL URLWithString:urlLink];
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSString *html = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    /*NSString *style = @"<style> .banner { display: block } " \
    @" .wrapper {box-shadow: none; -moz-box-shadow: none; -webkit-box-shadow: none } " \
    @" body { margin: 2px; background: none} .searchbox { display: none} .breadcrumb { display: block } " \
    @" hr { display: none} .menubar { margin-top: 5px } " \
    @"</style>";
    */
    
    NSString *style = @"<style> #banner-credit { display: none } " \
    @" #sidebar-left {display: none } " \
    @" #sidebar-right { display: none} #footer { display: none} .breadcrumb { display: block } " \
    @" #content, #node-full, #node-preview { width: 100%} #node-full { margin-top: 0px; float: none } " \
    @"</style>";
    
    
    if (![urlLink isEqualToString:homeUrl]) {
        style = [NSString stringWithFormat:@"%@%@", style, @"<style>.banner {display: none}</style>"];
    }
    
    int position = [html rangeOfString:@"<body"].location;
    
    NSString *head = [html substringToIndex:position];
    NSString *body = [html substringFromIndex:position];
    NSString *finalHtml = [NSString stringWithFormat:@"%@%@%@", head, style, body];
    
    if (newVisit)
        [history addObject:url];
    
    [_webView loadHTMLString:finalHtml baseURL:url];
    
    [_webView setScalesPageToFit:YES];
    [self handleBackButtonVisibility];
    
}

- (void) handleBackButtonVisibility
{
    
    if (history.count == 1 || [[[history lastObject] absoluteString] isEqualToString:homeUrl]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    else {
        self.navigationItem.leftBarButtonItem = backButton;
    }
        
    
}

- (void) showSearchButton
{
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                     target:self action:@selector(searchClicked:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)searchClicked:(id)sender
{
    NSLog(@"in search");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
