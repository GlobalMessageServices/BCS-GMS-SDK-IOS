//
// Utilities.swift
//  Hyber-SDK
//
//  Created by Taras on 10/27/16.
//  Incuube
//

internal extension String {
    /// The last path component of the receiver.
    var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }
    
    /// A new string made by deleting the extension from the receiver.
    var stringByDeletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }
    
    /**
     Returns a string colored with the specified color.
     
     - parameter color: The string representation of the color.
     
     - returns: A string colored with the specified color.
     */
    func withColor(_ color: String) -> String {
        return "\u{001b}[fg\(color);\(self)\u{001b}[;"
    }
}
