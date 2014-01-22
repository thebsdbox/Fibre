//
//  DFTableView.h
//  Fibre
//
//  Created by Daniel Finneran on 15/01/2014.
//  Copyright (c) 2014 Daniel Finneran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFTableView : NSTableView <NSTableViewDataSource, NSTableViewDelegate>

@property NSMutableArray *deviceArray;

-(void)bindTableView;

@end
