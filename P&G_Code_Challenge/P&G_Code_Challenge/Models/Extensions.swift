//  Extensions.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/17/20.

import Foundation

extension Date {
	
	/* Function for showing how long ago a post was made
	
	*/
	func timeAgoDisplay() -> String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full
		return formatter.localizedString(for: self, relativeTo: Date())
	}
	
	/* Function for showing exact time a post was made
	
	*/
	func dateAsString() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, yyyy @ H:mm a"
		return formatter.string(from: self)
	}
	
}
