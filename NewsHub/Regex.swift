//
//  Regex.swift
//  Fresh Lead
//
//  Created by Yaxin Cheng on 2016-04-25.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct Regex: StringLiteralConvertible {
  private let pattern: String!
  private let internalExpression: NSRegularExpression!
  
  typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  typealias UnicodeScalarLiteralType = UnicodeScalar
  
  init(pattern: String, options: NSRegularExpressionOptions) {
    self.pattern = pattern
    do {
      internalExpression = try NSRegularExpression(pattern: pattern, options: options)
    } catch let error as NSError {
      internalExpression = nil
      print(error)
    }
  }
  
  init(stringLiteral value: StringLiteralType) {
    self.pattern = value
    do {
      internalExpression = try NSRegularExpression(pattern: pattern, options: .AllowCommentsAndWhitespace)
    } catch let error as NSError {
      internalExpression = nil
      print(error)
    }
  }
  
  init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.pattern = value
    do {
      internalExpression = try NSRegularExpression(pattern: pattern, options: .AllowCommentsAndWhitespace)
    } catch let error as NSError {
      internalExpression = nil
      print(error)
    }
  }
  
  init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.pattern = "\(value)"
    do {
      internalExpression = try NSRegularExpression(pattern: pattern, options: .AllowCommentsAndWhitespace)
    } catch let error as NSError {
      internalExpression = nil
      print(error)
    }
  }
  
  func matches(input: String) -> Bool {
    //        let result = internalExpression.matchesInString(input, options: .ReportCompletion, range: NSRange(location: 0, length: input.characters.count))
    let result = internalExpression.numberOfMatchesInString(input, options: .WithoutAnchoringBounds, range: NSMakeRange(0, input.characters.count))
    return result > 0
  }
}