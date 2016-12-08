//
//  JZComplicationDataManager.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZComplicationDataManager.h"
#import "JZHeader.h"
#import "JZCommitManager.h"
#import "JZCommitDataModel.h"

@implementation JZComplicationDataManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static JZComplicationDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init])
    {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


- (CLKComplicationTemplate *)getComplicationFrom:(CLKComplication *)complication
                                        isSample:(BOOL)sampleBool
{
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!weeks)
        {
            JZLog(@"NSUserDefaults DO NOT HAVE weeks DATA");
        }else
        {
            JZLog(@"NSUserDefaults DO HAVE weeks DATA");
        }
    }else
    {
        return nil;
    }
    NSMutableArray *week = [weeks objectAtIndex:0];
    JZCommitDataModel* today = [week lastObject];
    
    int todayNum = [today.dataCount intValue];
    
    int weekNum = 0;
    for (JZCommitDataModel* day in week)
    {
        weekNum += [day.dataCount intValue];
    }
    
    switch (complication.family)
    {
        case CLKComplicationFamilyCircularSmall:
        {
            CLKComplicationTemplateCircularSmallStackImage *circularSmallStackImage = [[CLKComplicationTemplateCircularSmallStackImage alloc] init];
            circularSmallStackImage.line1ImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            if (sampleBool)
            {
                circularSmallStackImage.line2TextProvider
                = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"12"]];
            }
            else
            {
                circularSmallStackImage.line2TextProvider
                = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d",todayNum]];
                circularSmallStackImage.line1ImageProvider.tintColor = today.color;
                circularSmallStackImage.line2TextProvider
                .tintColor = today.color;
            }
            
            return circularSmallStackImage;
        }
            break;
        case CLKComplicationFamilyModularSmall:
        {
            CLKComplicationTemplateModularSmallSimpleImage *modularSmallSimpleImage = [[CLKComplicationTemplateModularSmallSimpleImage alloc] init];
            modularSmallSimpleImage.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            if (sampleBool)
            {}
            else
            {
                modularSmallSimpleImage.imageProvider.tintColor = today.color;
            }
            return modularSmallSimpleImage;
        }
            break;
            
        case CLKComplicationFamilyUtilitarianSmall:
        {
            CLKComplicationTemplateUtilitarianSmallFlat *utilitarianSmallFlat = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            utilitarianSmallFlat.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            if (sampleBool)
            {
                utilitarianSmallFlat.textProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"12"]];
            }else
            {
                utilitarianSmallFlat.textProvider
                = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d",todayNum]];
                utilitarianSmallFlat.textProvider.tintColor = today.color;
                utilitarianSmallFlat.imageProvider.tintColor = today.color;
            }

            return utilitarianSmallFlat;
        }
            break;
        case CLKComplicationFamilyUtilitarianLarge:
        {
            CLKComplicationTemplateUtilitarianLargeFlat *utilitarianLargeFlat = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            utilitarianLargeFlat.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            utilitarianLargeFlat.imageProvider.tintColor = [UIColor whiteColor];
            if (sampleBool)
            {
                utilitarianLargeFlat.textProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"12 Commits"]];
            }else
            {
                utilitarianLargeFlat.textProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d Commits",todayNum]];
                utilitarianLargeFlat.textProvider.tintColor = today.color;
                utilitarianLargeFlat.imageProvider.tintColor = today.color;
            }
            return utilitarianLargeFlat;
            
        }
            break;
            
        case CLKComplicationFamilyModularLarge:
        {
            CLKComplicationTemplateModularLargeColumns *modularLargeColumns = [[CLKComplicationTemplateModularLargeColumns alloc] init];
            modularLargeColumns.row1ImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            modularLargeColumns.row1Column1TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"Commits"]];
            modularLargeColumns.row1Column2TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@""]];
            
            modularLargeColumns.row2Column1TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"Today"]];
            modularLargeColumns.row3Column1TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"Week"]];
            modularLargeColumns.column2Alignment = CLKComplicationColumnAlignmentTrailing;
            if (sampleBool)
            {
                modularLargeColumns.row2Column2TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"12"]];
                modularLargeColumns.row3Column2TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"60"]];
            }else
            {
                modularLargeColumns.row2Column2TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d",todayNum]];
                modularLargeColumns.row3Column2TextProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d",weekNum]];
                modularLargeColumns.row1ImageProvider.tintColor = today.color;
                modularLargeColumns.row1Column1TextProvider.tintColor = today.color;
            }
            return modularLargeColumns;
        }
            break;
            
        case CLKComplicationFamilyExtraLarge:
        {
            return nil;
        }
            break;
        case CLKComplicationFamilyUtilitarianSmallFlat:
        {
            CLKComplicationTemplateUtilitarianSmallFlat *utilitarianSmallFlat = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            utilitarianSmallFlat.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            if (sampleBool)
            {
                utilitarianSmallFlat.textProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"12 Commits"]];
            }else
            {
                utilitarianSmallFlat.textProvider = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d Commits",todayNum]];
                utilitarianSmallFlat.textProvider.tintColor = today.color;
                utilitarianSmallFlat.imageProvider.tintColor = today.color;
            }
            return utilitarianSmallFlat;
        }
            break;
        default:
            return nil;
            break;
    }
    
}


@end
