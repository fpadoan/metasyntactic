// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "PocketFlicksCreditsViewController.h"

#import "Application.h"
#import "BoxOfficeStockImages.h"
#import "Model.h"

@interface PocketFlicksCreditsViewController()
@property (retain) NSArray* languages;
@property (retain) NSDictionary* localizers;
@end


@implementation PocketFlicksCreditsViewController

typedef enum {
  WrittenBySection,
  MyOtherApplicationsSection,
  GraphicsBySection,
  DVDDetailsSection,
  LocalizedBySection,
  LicenseSection,
  LastSection = LicenseSection
} CreditsSection;

@synthesize languages;
@synthesize localizers;

- (void) dealloc {
  self.languages = nil;
  self.localizers = nil;

  [super dealloc];
}


static NSComparisonResult compareLanguageCodes(id code1, id code2, void* context) {
  NSString* language1 = [LocaleUtilities displayLanguage:code1];
  NSString* language2 = [LocaleUtilities displayLanguage:code2];

  return [language1 compare:language2];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = [Application nameAndVersion];

    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"Michal Štoppl"       forKey:@"cs"];
    [dictionary setObject:@"Christian Frank"     forKey:@"da"];
    [dictionary setObject:@"Patrick Boch"        forKey:@"de"];
    [dictionary setObject:@"Jorge Herskovic"     forKey:@"es"];
    [dictionary setObject:@"J-P. Helisten"       forKey:@"fi"];
    [dictionary setObject:@"Jonathan Grenier"    forKey:@"fr"];
    [dictionary setObject:@"Dani Valevski"       forKey:@"he"];
    [dictionary setObject:@"Megha Joshi"         forKey:@"hi"];
    [dictionary setObject:@"Troy Gercek"         forKey:@"hr"];
    [dictionary setObject:@"Horányi Gergő"       forKey:@"hu"];
    [dictionary setObject:@"Riccardo Pellegrini" forKey:@"it"];
    [dictionary setObject:@"Leo Yamamoto"        forKey:@"ja"];
    [dictionary setObject:@"Koen Prange"         forKey:@"nl"];
    [dictionary setObject:@"Eivind Samseth"      forKey:@"no"];
    [dictionary setObject:@"Marek Wieczorek"     forKey:@"pl"];
    [dictionary setObject:@"João Sampaio"        forKey:@"pt"];
    [dictionary setObject:@"Marius Andrei"       forKey:@"ro"];
    [dictionary setObject:@"Aleksey Surkov"      forKey:@"ru"];
    [dictionary setObject:@"Ján Senko"           forKey:@"sk"];
    [dictionary setObject:@"Ola Lidén"           forKey:@"sv"];
    [dictionary setObject:@"Scott Bolin"         forKey:@"th"];
    [dictionary setObject:@"Oğuz Taş"            forKey:@"tr"];
    [dictionary setObject:@"Andriy Kasyan"       forKey:@"uk"];
    [dictionary setObject:@"Caton Tsai"          forKey:@"zh"];
    self.localizers = dictionary;

    self.languages = [localizers.allKeys sortedArrayUsingFunction:compareLanguageCodes context:NULL];
  }

  return self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return LastSection + 1;
}


- (NSInteger)       tableView:(UITableView*) table
        numberOfRowsInSection:(NSInteger) section {
  if (section == WrittenBySection) {
    return 3;
  } else if (section == MyOtherApplicationsSection) {
    return 4;
  } else if (section == GraphicsBySection) {
    return 1;
  } else if (section == DVDDetailsSection) {
    return 1;
  } else if (section == LocalizedBySection) {
    return localizers.count;
  } else if (section == LicenseSection) {
    return 1;
  }

  return 0;
}


- (UIImage*) getImage:(NSIndexPath*) indexPath {
  NSInteger section = indexPath.section;

  if (section == DVDDetailsSection) {
    return BoxOfficeStockImage(@"DeliveredByNetflix.png");
  }

  return nil;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  UIImage* image = [self getImage:indexPath];
  CGFloat height = tableView.rowHeight;
  if (image != nil) {
    CGFloat imageHeight = image.size.height + 10;
    if (imageHeight > height) {
      height = imageHeight;
    }
  } else if (indexPath.section == LocalizedBySection) {
    return tableView.rowHeight - 14;
  }

  return height;
}


- (UITableViewCell*) localizationCellForRow:(NSInteger) row {
  static NSString* reuseIdentifier = @"reuseIdentifier";

  SettingCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[SettingCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  NSString* code = [languages objectAtIndex:row];
  NSString* person = [localizers objectForKey:code];
  NSString* language = [LocaleUtilities displayLanguage:code];

  cell.textLabel.text = language;

  [cell setCellValue:person];
  [cell setHidesSeparator:row > 0];

  return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;

  if (section == LocalizedBySection) {
    return [self localizationCellForRow:row];
  }

  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  UIImage* image = [self getImage:indexPath];

  if (image != nil) {
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];

    NSInteger x = (self.tableView.contentSize.width - image.size.width) / 2 - 20;
    NSInteger y = ([self tableView:tableView heightForRowAtIndexPath:indexPath] - image.size.height) / 2;

    imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);

    [cell.contentView addSubview:imageView];
  } else if (section == WrittenBySection) {
    if (row == 0) {
      cell.textLabel.text = LocalizedString(@"Send Feedback", nil);
    } else if (row == 1) {
      cell.textLabel.text = LocalizedString(@"Project Website", nil);
    } else {
      cell.textLabel.text = LocalizedString(@"Write Review", nil);
    }
  } else if (section == MyOtherApplicationsSection) {
    if (row == 0) {
      cell.textLabel.text = @"Now Playing";
    } else if (row == 1) {
      cell.textLabel.text = @"Your Rights";
    } else if (row == 2) {
      cell.textLabel.text = @"Comics";
    } else {
      cell.textLabel.text = @"ComiXology";
    }
  } else if (section == GraphicsBySection) {
    cell.textLabel.text = LocalizedString(@"Website", nil);
  } else if (section == LicenseSection) {
    cell.textLabel.text = LocalizedString(@"License", nil);
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  }

  if (indexPath.section < LocalizedBySection) {
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  } else if (indexPath.section == LocalizedBySection) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == WrittenBySection) {
    return LocalizedString(@"Written by Cyrus Najmabadi", nil);
  } else if (section == MyOtherApplicationsSection) {
    return LocalizedString(@"My other applications", nil);
  } else if (section == DVDDetailsSection) {
    return LocalizedString(@"DVD/Blu-ray details:", nil);
  } else if (section == GraphicsBySection) {
    return LocalizedString(@"Graphics by David Steinberger", nil);
  } else if (section == LocalizedBySection) {
    return LocalizedString(@"Localized by:", nil);
  }

  return nil;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
  if (section == WrittenBySection) {
    return [NSString stringWithFormat:LocalizedString(@"If you like %@, please consider writing a small review for the iTunes store. It will help new users discover this app, allow me to bring you great new features, keep things ad free, and will make me feel fuzzy inside. Thanks!", nil), [Application name]];
  } else if (section == MyOtherApplicationsSection) {
  } else if (section == GraphicsBySection) {
  } else if (section == LocalizedBySection) {
  }

  return nil;
}


- (void) licenseCellTapped {
  UIViewController* controller = [[[UIViewController alloc] init] autorelease];
  controller.title = LocalizedString(@"License", nil);

  UITextView* textView = [[[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
  textView.editable = NO;
  textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  NSString* licensePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"License.txt"];
  textView.text = [NSString stringWithContentsOfFile:licensePath encoding:NSUTF8StringEncoding error:NULL];
  textView.font = [UIFont boldSystemFontOfSize:12];
  textView.textColor = [UIColor grayColor];

  [controller.view addSubview:textView];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) sendFeedback {
  NSString* body = [NSString stringWithFormat:@"\n\nVersion: %@\nDevice: %@ v%@\nCountry: %@\nLanguage: %@",
                    [Application version],
                    [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion],
                    [LocaleUtilities englishCountry],
                    [LocaleUtilities englishLanguage]];

  NetflixAccount* account = [[NetflixAccountCache cache] currentAccount];
  if (account.userId.length > 0) {
    body = [body stringByAppendingFormat:@"\n\nNetflix:\nUser ID: %@\nKey: %@\nSecret: %@",
            [StringUtilities nonNilString:account.userId],
            [StringUtilities nonNilString:account.key],
            [StringUtilities nonNilString:account.secret]];
  }

  NSError* error = [[NetflixCache cache] lastError];
  if (error != nil) {
    body = [body stringByAppendingFormat:@"\n\nLast Error:\n%@\n%@",
            error,
            error.userInfo];
  }

  NSString* subject;
  if ([LocaleUtilities isJapanese]) {
    subject = @"PocketFlicksのフィードバック";
  } else {
    subject = @"PocketFlicks Feedback";
  }

  [self openMailTo:@"cyrus.najmabadi@gmail.com"
       withSubject:subject
              body:body
            isHTML:NO];
}


- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error {
  [self dismissModalViewControllerAnimated:YES];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;

  NSString* url = nil;
  if (section == WrittenBySection) {
    if (row == 0) {
      return [self sendFeedback];
    } else if (row == 1) {
      url = @"http://metasyntactic.googlecode.com";
    } else {
      url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301386724&mt=8";
    }
  } else if (section == MyOtherApplicationsSection) {
    if (row == 0) {
      url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=284939567&mt=8";
    } else if (row == 1) {
      url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301494200&mt=8";
    } else if (row == 2) {
      url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=303491945&mt=8";
    } else {
      url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=297414943&mt=8";
    }
  } else if (section == GraphicsBySection) {
    url = @"http://www.comixology.com";
  } else if (section == LocalizedBySection) {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return;
  } else if (section == LicenseSection) {
    [self licenseCellTapped];
    return;
  }

  [Application openBrowser:url];
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
  return [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
