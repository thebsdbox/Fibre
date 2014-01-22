//
//  DFZoneGenerate.m
//  Fibre
//
//  Created by Daniel Finneran on 16/01/2014.
//  Copyright (c) 2014 Daniel Finneran. All rights reserved.
//

#import "DFZoneGenerate.h"

@interface DFZoneGenerate () {
    NSMutableArray *arrayOfZones;
}

@end

@implementation DFZoneGenerate

+(NSString *)zoningForCisco:(BOOL)cisco withMultiInitiator:(BOOL)multiInitiator ForConfig:(NSString *)config
{
    return @"test";
}

-(NSString *)createAliasesForBrocade
{
    NSString *aliasString = [[NSString alloc] init];
    if (_wwn.count == _aliases.count) {
        // ensure that the aliases will match up with wwn
        for (int i = 0; i < _wwn.count; i ++) {
            NSString *alias = [NSString stringWithFormat:@"alicreate \"%@\" , \"%@\"\n", [_aliases objectAtIndex:i], [_wwn objectAtIndex:i]];
            aliasString = [aliasString stringByAppendingString:alias];
        }
    }
    return aliasString;
}

-(NSString *)createAliasesForCisco
{
    NSString *aliasString = [[NSString alloc] init];
    aliasString = [aliasString stringByAppendingString:@"; config t\n; device alias database\n"];
    if (_wwn.count == _aliases.count) {
        // ensure that the aliases will match up with wwn
        for (int i = 0; i < _wwn.count; i ++) {
            NSString *alias = [NSString stringWithFormat:@"device-alias name %@ pwwn %@\n", [_aliases objectAtIndex:i], [_wwn objectAtIndex:i]];
            aliasString = [aliasString stringByAppendingString:alias];
        }
    }
    aliasString = [aliasString stringByAppendingString:@"; exit \n; end \n; device alias commit\n"];

    return aliasString;
}

-(NSString *)createZoneForCisco
{
    NSString *zoneString = [[NSString alloc] init];
    
    if (_simt) {
        // Generate zone name
        NSString *controllerName = [NSString string];
        for (NSString *controller in _controller) {
            controllerName = [controllerName stringByAppendingString:[NSString stringWithFormat:@"_%@",controller]];
        }
        controllerName = [controllerName substringWithRange:NSMakeRange(1, controllerName.length -1)];
        for (NSString *alias in _aliases) {
            zoneString = [zoneString stringByAppendingString:[NSString stringWithFormat:@"zone name %@ vsan %ld\n", [self createZoneNameWithHBA:alias andController:controllerName], _vsanID]];
            zoneString = [zoneString stringByAppendingString:[NSString stringWithFormat:@"member device-alias %@\n",alias]];
            for (NSString *controller in _controller) {
                zoneString = [zoneString stringByAppendingString:[NSString stringWithFormat:@"member device-alias %@\n",controller]];
            }
        }
    } else {
        for (NSString *alias in _aliases) {
            for (NSString *controller in _controller) {
                zoneString = [zoneString stringByAppendingString:[NSString stringWithFormat:@"zone name %@ vsan %ld\n", [self createZoneNameWithHBA:alias andController:controller], _vsanID]];
                zoneString = [zoneString stringByAppendingString:[NSString stringWithFormat:@"member device-alias %@\n",alias]];
                zoneString = [zoneString stringByAppendingString:[NSString stringWithFormat:@"member device-alias %@\n",controller]];
            }
        }
    }
    return zoneString;
}

-(NSString *)createZoneForBrocade
{
    NSString *zoneString = [[NSString alloc] init];
    for (int i = 0; i < _wwn.count; i ++) {
        for (int x = 0; x < _controller.count; x ++) {
            NSString *zone = [NSString stringWithFormat:@"zonecreate \"%@\" , \"%@;%@\"\n",[self createZoneNameWithHBA:[_aliases objectAtIndex:i] andController:[_controller objectAtIndex:x]] ,[_aliases objectAtIndex:i], [_controller objectAtIndex:x]];
            zoneString = [zoneString stringByAppendingString:zone];
        }
    }
    return zoneString;
}

-(NSString *)createZoneNameWithHBA:(NSString *)hba andController:(NSString *)controller
{
    NSString *zoneName = [NSString stringWithFormat:@"Z_%@_%@", hba, controller];
    //arrayOfZones = nil;
    //arrayOfZones = [NSMutableArray array];
    if (!arrayOfZones) {
        arrayOfZones = [NSMutableArray array];
    }
    [arrayOfZones addObject:zoneName];
    return  zoneName;
}

-(NSString *)createConfigForBrocade
{
    NSString *configString = [NSString string];
    for (NSString *zone in arrayOfZones) {
        configString = [configString stringByAppendingString:[NSString stringWithFormat:@"cfgadd \"%@\" , \"%@\"\n",_configName,zone]];
    }
    return configString;
}

-(NSString *)createConfigForCisco
{
    NSString *configString = [NSString string];
    configString = [configString stringByAppendingString:[NSString stringWithFormat:@"zoneset name %@ vsan %ld\n",_configName, (long)_vsanID]];
    for (NSString *zone in arrayOfZones) {
        configString = [configString stringByAppendingString:[NSString stringWithFormat:@"member %@\n",zone]];
    }
    configString = [configString stringByAppendingString:[NSString stringWithFormat:@"; zoneset activate name %@ vsan %ld\n",_configName, (long)_vsanID]];
    return configString;
}


-(NSString *)generate
{
    if (_cisco) {
        return [NSString stringWithFormat:@"; READ ALL COMMENTS BEFORE COPYING AND PASTING\n%@\n%@\n%@",[self createAliasesForCisco], [self createZoneForCisco], [self createConfigForCisco] ];
    } else {
        return [NSString stringWithFormat:@"%@\n%@\n%@",[self createAliasesForBrocade], [self createZoneForBrocade], [self createConfigForBrocade]];
    }
}

@end
