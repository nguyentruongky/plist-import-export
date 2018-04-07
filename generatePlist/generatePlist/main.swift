//
//  main.swift
//  generatePlist
//
//  Created by Ky Nguyen Coinhako on 3/30/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import Foundation

print("Your translated file name (without extension): ")
let name = readLine()!
let sourceName = name + ".txt"
let destName = name + ".plist"
let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let sourceFilePath = URL(fileURLWithPath: sourceName, relativeTo: currentDirectoryURL).path
if let data = FileManager.default.contents(atPath: sourceFilePath) {
    var contentString = String(data: data, encoding: .utf8)!
    contentString = contentString.replacingOccurrences(of: "{", with: "")
    contentString = contentString.replacingOccurrences(of: "}", with: "")
    let dictionary = NSMutableDictionary()
    let arrayOfStrings = contentString.components(separatedBy: "Ω")
    for string in arrayOfStrings {
        if string == "\n" { continue }
        let newString = string.replacingOccurrences(of: "\"", with: "")
        let keyValue = newString.components(separatedBy: ":")
        let key = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
        var value = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
        value = value.replacingOccurrences(of: "\\n", with: "\n")
        dictionary[key] = value
    }
    let destFilePath = URL(fileURLWithPath: destName, relativeTo: currentDirectoryURL).path
    if FileManager.default.fileExists(atPath: destFilePath) {
        var oldFileUrl = currentDirectoryURL
        oldFileUrl.appendPathComponent(destName)
        var newFileUrl = currentDirectoryURL
        newFileUrl.appendPathComponent("bak_" + destName)
        
        try? FileManager.default.moveItem(at: oldFileUrl, to: newFileUrl)
    }
    
    sleep(1)
    dictionary.write(toFile: destFilePath, atomically: false)
}

















