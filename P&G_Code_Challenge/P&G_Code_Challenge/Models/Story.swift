//  Story.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

struct Story: Decodable, Identifiable, Hashable {
	var id: Int
	//var deleted: Bool?
	var type: String
	var by: String
	var time: Int
	var text: String?
	//var dead: Bool?
	var parent: Int?
	var poll: Int?
	var kids: [Int]?
	var url: String?
	var score: Int?
	var title: String?
	var parts: [Int]?
	var descendants: Int?
}
