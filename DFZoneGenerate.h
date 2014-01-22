//
//  DFZoneGenerate.h
//  Fibre
//
//  Created by Daniel Finneran on 16/01/2014.
//  Copyright (c) 2014 Daniel Finneran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFZoneGenerate : NSObject

@property NSArray *wwn;
@property NSArray *aliases;
@property NSArray *controller;

@property NSString *configName;
@property NSInteger vsanID;

@property BOOL cisco;
@property BOOL simt; //single intitiator multiple target

+(NSString *)zoningForCisco:(BOOL)cisco withMultiInitiator:(BOOL)multiInitiator ForConfig:(NSString *)config;
-(NSString *)createAliasesForBrocade;
-(NSString *)createAliasesForCisco;

-(NSString *)createZoneForBrocade;
-(NSString *)createZoneForCisco;

-(NSString *)createConfigForBrocade;
-(NSString *)createConfigForCisco;


-(NSString *)generate;


@end
