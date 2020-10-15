//  Comment.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/14/20.

import Foundation

/** Struct to format a story as recieved by HackerNews API.
Based on my understandings, all comments will have these fields.
Struct is Decodable, Identifiable, and Hashable to allow JSON decoding and individualization.
*/
struct Comment: Decodable, Identifiable, Hashable {
	// Commented out bools as they are not allowed to be optional, and unnessary when app only displays top 500 active stories
	var id: Int
	//var deleted: Bool?
	var type: String
	var by: String
	var time: Int
	var text: String?
	//var dead: Bool?
	var parent: Int?
	var kids: [Int]?
}
