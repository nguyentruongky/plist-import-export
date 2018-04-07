//
//  main.swift
//  generateText
//
//  Created by Ky Nguyen Coinhako on 3/30/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import Foundation

print("Your plist file name (without extension): ")
let name = readLine()!
let sourceName = name + ".plist"
let destName = name + ".txt"
let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let sourceFilePath = URL(fileURLWithPath: sourceName, relativeTo: currentDirectoryURL).path
//var dictionary = NSMutableDictionary()

if let data = FileManager.default.contents(atPath: sourceFilePath) {
    var contentString = String(data: data, encoding: .utf8)!
    contentString = contentString.replacingOccurrences(of: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>", with: "")
    contentString = contentString.replacingOccurrences(of: "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">", with: "")
    contentString = contentString.replacingOccurrences(of: "<plist version=\"1.0\">", with: "")
    contentString = contentString.replacingOccurrences(of: "<dict>", with: "")
    contentString = contentString.replacingOccurrences(of: "</dict>", with: "")
    contentString = contentString.replacingOccurrences(of: "</plist>", with: "")
    print(contentString)

    let lines = contentString.components(separatedBy: .newlines)
    
    var resultString = ""
    var key = ""
    var value = ""
    for l in lines {
        if l == "" { continue }
        var line = l.trimmingCharacters(in: .whitespacesAndNewlines)
        if l.contains("<key>") {
            if key != "" && value != "" {
                resultString += key + value
            }
            line = line.replacingOccurrences(of: "<key>", with: "\"")
            line = line.replacingOccurrences(of: "</key>", with: "\":")
            key = line
        }
        
        if l.contains("<string>") {
            line = line.replacingOccurrences(of: "<string>", with: "\"")
            line = line.replacingOccurrences(of: "</string>", with: "\"Ω\n")
            value = line
        }
        
        if l.contains("<key>") == false && l.contains("<string>") == false {
            value += "\\n" + line.replacingOccurrences(of: "<string>", with: "\"").replacingOccurrences(of: "</string>", with: "\"Ω\n")
        }
    }
    if key != "" && value != "" {
        resultString += key + value
    }
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    var fileURL = currentDirectoryURL
    fileURL.appendPathComponent(destName)
    print("FilePath: \(fileURL.path)")
    
    try? resultString.write(to: fileURL, atomically: true, encoding: .utf8)
//    dictionary.write(to: fileURL, atomically: true)
}













