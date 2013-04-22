//
//  REMapViewController.m
//  renewably
//
//  Created by Anup Doshi on 4/21/13.
//  Copyright (c) 2013 Anup Doshi. All rights reserved.
//

#import "REMapViewController.h"

NSString const* htmlString = @"<html>\n\t<body>\n\t\t<div id=\"scroller\" style=\"height: 400px; width: 100%; overflow: auto;\">\n\t\t<iframe width=\"100%\" height=\"100%\" scrolling=\"no\" frameborder=\"no\" src=\"https://www.google.com/fusiontables/embedviz?viz=MAP&amp;q=select+col3%3E%3E1+from+1VRfZgPUC38abdNT4243X0ZXgXXlQrtJ1CRN-oRk&amp;h=false&amp;lat=38.102595554415515&amp;lng=-92.41031437499993&amp;z=3&amp;t=1&amp;l=col3%3E%3E1&amp;y=2&amp;tmplt=2\"></iframe>\n\t</div>\n\t</body>\n</html>";

@interface REMapViewController ()

@end

@implementation REMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mWebView loadHTMLString:htmlString baseURL:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
