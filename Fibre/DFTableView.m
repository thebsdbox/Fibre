//
//  DFTableView.m
//  Fibre
//
//  Created by Daniel Finneran on 15/01/2014.
//  Copyright (c) 2014 Daniel Finneran. All rights reserved.
//

#import "DFTableView.h"

@implementation DFTableView


-(void)bindTableView
{
    _deviceArray = [NSMutableArray array];
//    [_deviceArray addObject:@"ho"];
    [self setDataSource:self];
    [self setDelegate:self];
    [self setDoubleAction:@selector(pasteIntoDeviceArray)];
    [self display];

}

-(NSView *)tableView:(DFTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    //result.textField.textColor = [NSColor redColor];
    result.textField.stringValue = [_deviceArray objectAtIndex:row];
    return result;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _deviceArray.count;
}

-(void)pasteIntoDeviceArray
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classArray = [NSArray arrayWithObject:[NSString class]];
    NSDictionary *options = [NSDictionary dictionary];
    
    BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
    if (ok) {
        NSString *fullString = [[NSString stringWithString:[[pasteboard readObjectsForClasses:classArray options:options] objectAtIndex:0]] copy];
        NSArray *stringObjects = [fullString componentsSeparatedByString:@"\n"];
        if (!_deviceArray) {
            _deviceArray = [NSMutableArray arrayWithArray:stringObjects];
        } else {
            
            
            if ([[stringObjects lastObject] isEqualTo:@""]) {
                [_deviceArray addObjectsFromArray:[stringObjects subarrayWithRange:NSMakeRange(0, (stringObjects.count - 1))]];
            } else {
                [_deviceArray addObjectsFromArray:stringObjects ];
            }
        }
        [self reloadData];
    }
}

-(void)keyDown:(NSEvent *)theEvent {
    if ([[theEvent charactersIgnoringModifiers] characterAtIndex:0] == NSDeleteCharacter) {
        if ([self selectedRow] <= _deviceArray.count) {
            [_deviceArray removeObjectAtIndex: [self selectedRow]];
        }
    }
    if ([theEvent modifierFlags] & NSCommandKeyMask) {
        NSString *character = [theEvent charactersIgnoringModifiers];
        if ([character isEqualToString:@"v"]) {
            [self pasteIntoDeviceArray];
        }
    }
    [super keyDown:theEvent];
    [self reloadData];
}

@end
