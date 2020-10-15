//  Story.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

struct Story: Decodable, Identifiable, Hashable {
	var id: String
	//var deleted: Bool?
	var type: String
	var by: String
	var time: Int
	var text: String?
	//var dead: Bool?
	var parent: String?
	var poll: String?
	var kids: [String]?
	var url: String?
	var score: String?
	var title: String?
	//var parts: [Int]?
	var descendants: String?
	
	var comments = [Comment]()
	
//	mutating func getCommentsHTTP(completion:@escaping ([Comment]) -> Void){
//		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + self.id + ".json?print=pretty")
//		
//		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
//			if error != nil {
//				print(error as Any)
//				return
//			}
//			
//			guard let data = data else {return}
//			
//			do {
//				let comment = try JSONDecoder().decode(Comment.self, from: data)
//
//				self.comments.append(comment)
//				
//				completion(story)
//			} catch let jsonError {
//				print(jsonError)
//			}
//			
//		}.resume()
//	}
}
