//
//  AppDelegate.m
//  Fibre
//
//  Created by Daniel Finneran on 15/01/2014.
//  Copyright (c) 2014 Daniel Finneran. All rights reserved.
//

#import "AppDelegate.h"
#import "DFZoneGenerate.h"

@interface AppDelegate () {

}

@end

@implementation AppDelegate
-(void)sample:(id)sender
{
    /*
     Some test data
     
     
     
     */
    [_wwn setDeviceArray:[@[@"00:00:00:25:00:00:00:0E",
                            @"00:00:00:25:00:00:00:1F",
                            @"00:00:00:25:00:00:00:1C",
                            @"00:00:00:25:00:00:00:0C",
                            @"00:00:00:25:00:00:00:0D",
                            @"00:00:00:25:00:00:00:1E",
                            @"00:00:00:25:00:00:00:0A",
                            @"00:00:00:25:00:00:00:1B",
                            @"00:00:00:25:00:00:00:1E",
                            @"00:00:00:25:00:00:00:0E",
                            @"00:00:00:25:00:00:00:1D",
                            @"00:00:00:25:00:00:00:0D",
                            @"00:00:00:25:00:00:00:1C",
                            @"00:00:00:25:00:00:00:0C",
                            @"00:00:00:25:00:00:00:0A",
                            @"00:00:00:25:00:00:00:1B"] mutableCopy]];
    [_wwnAlias setDeviceArray:[@[ @"server01_a",
                                  @"server01_b",
                                  @"server02_a",
                                  @"server02_b",
                                  @"server03_a",
                                  @"server03_b",
                                  @"server04_a",
                                  @"server04_b",
                                  @"serverweb01_a",
                                  @"serverweb01_b",
                                  @"serverweb02_a",
                                  @"serverweb02_b",
                                  @"serverweb03_a",
                                  @"serverweb03_b",
                                  @"serverweb04_a",
                                  @"serverweb04_b"] mutableCopy]];
    [_wwnController setDeviceArray:[@[@"controller_P0",
                                      @"controller_P2",
                                      @"controller_P4"] mutableCopy]];
    [_vsanID setStringValue:@"7"];
    [_configName setStringValue:@"CONFIG_2014"];
    [_wwn reloadData];
    [_wwnAlias reloadData];
    [_wwnController reloadData];

}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    [_wwn bindTableView];
    [_wwnAlias bindTableView];
    [_wwnController bindTableView];
    
    
}

-(IBAction) generate:(id)sender
{
    DFZoneGenerate *zoneGenerate = [[DFZoneGenerate alloc] init ];

    if (_initiatorType.state  == NSOnState)
    {
        [zoneGenerate setSimt:true];

    } else {
        [zoneGenerate setSimt:false];
    }
    if (_zoneType.selectedTag == 1)
    {
        [zoneGenerate setCisco:true];
        [zoneGenerate setVsanID:[[_vsanID stringValue] integerValue]];

    }else {
        [zoneGenerate setCisco:false];
    }
    [zoneGenerate setConfigName:_configName.stringValue];
    [zoneGenerate setWwn:[_wwn.deviceArray copy]];
    [zoneGenerate setAliases:[_wwnAlias.deviceArray copy]];
    [zoneGenerate setController:[_wwnController.deviceArray copy]];
 
    [_zoneText setString:[zoneGenerate generate]];
    [[_zoneText textStorage] setFont:[NSFont fontWithName:@"Courier New" size:12]];
    [_zoneWindow makeKeyAndOrderFront:self];
}

-(IBAction) matrixSelect:(id)sender
{
    if (_zoneType.selectedTag == 0)
    {
        [_vsanID setEnabled:NO];
        
    }else {
        [_vsanID setEnabled:YES];
    }
}

@end
