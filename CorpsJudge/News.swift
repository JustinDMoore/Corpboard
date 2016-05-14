//
//  News.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/7/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation
import MWFeedParser

protocol delegateNews: class {
    func newsDidLoad()
    func newsDidFail()
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class News: NSObject, MWFeedParserDelegate {
    
    static let sharedInstance = News()
    let formatter = NSDateFormatter()
    var arrayOfNewsItemsToDisplay = [MWFeedItem]()
    
    var parsedItems = [MWFeedItem]()
    var feedParser = MWFeedParser()
    var newsLoaded = false
    var arrayOfColors = [Int32]()
    weak var delegateNewsParser: delegateNews?
    
    func beginUpdatingNewsWithURL(URL: String) {
        for i  in 0..<17 {
            self.arrayOfColors.append(Int32(i))
        }
        self.shuffle()
        
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let feedURL = NSURL(string: URL)
        feedParser = MWFeedParser(feedURL: feedURL)
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        //TODO: playw ith synchronous stuff
        feedParser.connectionType = ConnectionTypeAsynchronously
        feedParser.parse()
    }
    
    func updateTableWithParsedItems() {
        self.arrayOfNewsItemsToDisplay = parsedItems.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
    }
    
    func feedParserDidStart(parser: MWFeedParser!) {
        //print("Starting parsing news @ \(parser.url())")
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        //print("Parsed feed info: \(info.title)")
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if item != nil {
            parsedItems.append(item)
        }
        //print("\(item.description)")
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.updateTableWithParsedItems()
        self.delegateNewsParser?.newsDidLoad()
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        self.updateTableWithParsedItems()
        print("Finished parsing with Error: \(error.description)")
        self.delegateNewsParser?.newsDidFail()
    }
    
    func shuffle() {
        self.arrayOfColors.shuffleInPlace()
    }
    
    func dateForNews(newsDate: NSDate) -> String {
        let diff = newsDate.minutesBeforeDate(NSDate())
        if diff < 5 {
            return "Just Now"
        } else if diff <= 50 {
            return "\(diff) minutes ago"
        } else if diff > 50 && diff < 65 {
            return "An hour ago"
        } else {
            if newsDate.isYesterday() {
                return "Yesterday"
            }
            let daysBefore = newsDate.daysBeforeDate(NSDate())
            if daysBefore == 2 {
                return "2 days ago"
            } else {
                if newsDate.isToday() {
                    let hours = newsDate.hoursBeforeDate(NSDate())
                    return "\(hours) hours ago"
                } else {
                    let format = NSDateFormatter()
                    format.dateFormat = "MMMM d"
                    return format.stringFromDate(newsDate)
                }
            }
        }
    }
}