//  Story.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

/** Struct to format a story as recieved by HackerNews API
*/
struct Item: Decodable, Identifiable, Hashable {
	// Commented out dead as they are not allowed to be optional, and unnessary when app only displays top 500 active stories
	var id: Int
	var deleted: Bool? = false
	var type: String
	var by: String?
	var time: Int
	var text: String?
	//var dead: Bool?
	var parent: Int?
	var poll: String?
	var kids: [Int]?
	var url: String?
	var score: Int?
	var title: String?
	var parts: [Int]?
	var descendants: Int?
	var date: Date!
}
