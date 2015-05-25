platform :ios, '7.0'

pod 'KVNProgress', '2.2.1'
pod 'PulsingHalo', '0.0.1'
pod 'JSBadgeView', '1.3.2'
pod 'IQKeyboardManager', '3.2.3'
pod 'JSQSystemSoundPlayer', '2.0.1'
pod 'JSQMessagesViewController', '7.0.1'
pod 'AFNetworking', '2.5.0'
pod 'DTCoreText', '1.6.15'
pod 'DTFoundation', '1.7.5'









pod 'MWFeedParser', '1.0.1'
=begin
 MWFeedItem.m
 
 - (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
 identifier = [decoder decodeObjectForKey:@"identifier"];
 title = [decoder decodeObjectForKey:@"title"];
 link = [decoder decodeObjectForKey:@"link"];
 date = [decoder decodeObjectForKey:@"news_date"];   ****** updated to reflect DCI field
 updated = [decoder decodeObjectForKey:@"updated"];
 summary = [decoder decodeObjectForKey:@"summary"];
 content = [decoder decodeObjectForKey:@"content"];
 author = [decoder decodeObjectForKey:@"author"];
 enclosures = [decoder decodeObjectForKey:@"enclosures"];
	}
	return self;
 }
 
 
 MWFeedParser.h
 
 // Item
 if (!processed) {
 if ([currentPath isEqualToString:@"/rss/channel/item/title"]) { if (processedText.length > 0) item.title = processedText; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/link"]) { if (processedText.length > 0) item.link = processedText; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/author"]) { if (processedText.length > 0) item.author = processedText; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/dc:creator"]) { if (processedText.length > 0) item.author = processedText; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/guid"]) { if (processedText.length > 0) item.identifier = processedText; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/news_date"]) { if (processedText.length > 0) item.date = [NSDate dateFromInternetDateTimeString:processedText formatHint:DateFormatHintRFC822]; processed = YES; } //this one
 else if ([currentPath isEqualToString:@"/rss/channel/item/description"]) { if (processedText.length > 0) item.summary = processedText; processed = YES; } //this one
 else if ([currentPath isEqualToString:@"/rss/channel/item/content:encoded"]) { if (processedText.length > 0) item.content = processedText; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/pubDate"]) { if (processedText.length > 0) item.date = [NSDate dateFromInternetDateTimeString:processedText formatHint:DateFormatHintRFC822]; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/enclosure"]) { [self createEnclosureFromAttributes:currentElementAttributes andAddToItem:item]; processed = YES; }
 else if ([currentPath isEqualToString:@"/rss/channel/item/dc:date"]) { if (processedText.length > 0) item.date = [NSDate dateFromInternetDateTimeString:processedText formatHint:DateFormatHintRFC3339]; processed = YES; }
 }
 
 // Info
 if (!processed && feedParseType != ParseTypeItemsOnly) {
 if ([currentPath isEqualToString:@"/rss/channel/title"]) { if (processedText.length > 0) info.title = processedText; processed = YES; }
 
 else if ([currentPath isEqualToString:@"/rss/channel/description"]) { if (processedText.length > 0) info.summary = processedText; processed = YES; } //this one
 else if ([currentPath isEqualToString:@"/rss/channel/item/news_date"]) { if (processedText.length > 0) item.date = [NSDate dateFromInternetDateTimeString:processedText formatHint:DateFormatHintRFC822]; processed = YES; } //this one
 else if ([currentPath isEqualToString:@"/rss/channel/link"]) { if (processedText.length > 0) info.link = processedText; processed = YES; }
 }
 
 break;
 }
 
 =end