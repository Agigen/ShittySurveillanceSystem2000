#import "ApplicationDelegate.h"
#import "Toilet.h"

@implementation ApplicationDelegate

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;



#pragma mark -

- (void)dealloc
{
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
}

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel) {
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSApplicationDelegate

- (void)getToiletsFromServer {
    
    [self.panelController.toilets removeAllObjects];
    
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/toatest.php"];
//    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
//    NSURLResponse* response = nil;
//    NSError* error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *resultData = [[NSData alloc] initWithContentsOfURL: url];
    
    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];

    NSLog(@"%@", result);
    
    if (NSClassFromString(@"NSJSONSerialization")) {
        
        NSError *jsonError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&jsonError];
        
        if (jsonError) {
            // Handle errors :)
            NSLog(@"Failed parsing json with error:");
            NSLog(@"%@", jsonError);
            return;
        }
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Hurra!");
            NSDictionary *toiletData = object;
            
            for (id key in [toiletData objectForKey:@"toilets"]) {
//                NSLog(@"key=%@ value=%@", key, [toiletData objectForKey:key]);
                
                NSLog(@"name=%@ occupied=%@", [key objectForKey:@"title"], [key objectForKey:@"occupied"] );
                NSLog(@"boolvalue %@", ([[key objectForKey:@"occupied"] boolValue]) ? @"YES" : @"NO");
                
//                BOOL isOccupied = [[key objectForKey:@"occupied"] boolValue];
//                NSString *title = [key objectForKey:@"title"];
                
//                Toilet *toa = [[Toilet alloc] initWithTitle:title occupied:TRUE];
                [self.panelController.toilets addObject:[
                 [Toilet alloc] initWithTitle:[key objectForKey:@"title"] occupied:[[key objectForKey:@"occupied"] boolValue]
                 ]];
                
                NSLog(@"En toa tillagd");
                
                

            }
            
            
            
        } else {
            NSLog(@"Failed parsing json");
        }
        
    }
    
   // [self.panelController.tableView reloadData];
    [self.panelController.tableView reloadData];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Install icon into the menu bar
    self.menubarController = [[MenubarController alloc] init];
    
    // Add the toilets
//    Toilet *toilet1 = [[Toilet alloc] initWithTitle:@"Toilet 1" occupied:FALSE];
//    Toilet *toilet2 = [[Toilet alloc] initWithTitle:@"Toilet 3" occupied:FALSE];
//    Toilet *toilet3 = [[Toilet alloc] initWithTitle:@"Toilet 3" occupied:TRUE];
    NSMutableArray *toilets = [NSMutableArray arrayWithObjects: nil];
    self.panelController.toilets = toilets;
    
    [self getToiletsFromServer];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    return NSTerminateNow;
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender
{
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
    
    [self getToiletsFromServer];
}

#pragma mark - Public accessors

- (PanelController *)panelController
{
    if (_panelController == nil) {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
    }
    return _panelController;
}

#pragma mark - PanelControllerDelegate

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
    return self.menubarController.statusItemView;
}

@end
