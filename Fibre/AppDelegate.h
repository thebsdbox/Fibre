//
//  AppDelegate.h
//  Fibre
//
//  Created by Daniel Finneran on 15/01/2014.
//  Copyright (c) 2014 Daniel Finneran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DFTableView.h" 

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *zoneWindow;


@property IBOutlet DFTableView *wwnAlias; // pointer to aliases table
@property IBOutlet DFTableView *wwn; // pointer to wwn table
@property IBOutlet DFTableView *wwnController; // pointer to controller table

@property IBOutlet NSMatrix *zoneType;

@property IBOutlet NSButton *initiatorType; 

@property IBOutlet NSTextField *configName;

@property IBOutlet NSTextView *zoneText; //

@property IBOutlet NSTextField *vsanID;


// Generate zoning
-(IBAction) generate:(id)sender;
//
-(IBAction) matrixSelect:(id)sender;
-(IBAction) sample:(id)sender;


@end
