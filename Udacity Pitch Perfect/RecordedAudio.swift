//
//  RecordedAudio.swift
//  Udacity Pitch Perfect
//
//  Created by Dilip K Kothamasu on 5/26/15.
//  Copyright (c) 2015 AT&T. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl:NSURL!
    var title: NSString!
    
    init(filePathUrl: NSURL, title: NSString) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
    init(filePathString: NSString, title: NSString) {
        self.filePathUrl = NSURL.fileURLWithPath(filePathString as String);
        self.title = title
    }
}