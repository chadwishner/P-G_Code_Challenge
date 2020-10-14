//
//  Comment.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/14/20.
//

import Foundation

struct Comment: Decodable, Identifiable, Hashable {
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
