//  GetCommentData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import Foundation

class GetCommentData: ObservableObject {
	@Published var comments = [Int : Comment]()
	
	func getAllComments(story: Item){
		if (story.kids != nil) {
			for kid in story.kids! {
				if !comments.keys.contains(kid){
					getCommentHTTP(kid: kid) { (newComment) in
						DispatchQueue.main.async{
							self.comments[kid] = (newComment)
							print(self.comments.capacity)
						}
					}
				}
			}
		}
	}
	
	func getAllSubComments(comment: Comment){
		if (comment.kids != nil) {
			for kid in comment.kids! {
				if !comments.keys.contains(kid){
					getCommentHTTP(kid: kid) { (newComment) in
						DispatchQueue.main.async{
							self.comments[kid] = (newComment)
							print(self.comments.capacity)
						}
					}
				}
			}
		}
	}
	
	func getCommentHTTP(kid: Int, completion:@escaping (Comment) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + String(kid) + ".json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			guard let data = data else {return}
			
			do {
				var comment = try JSONDecoder().decode(Comment.self, from: data)

				if comment.text != nil {
					let badText = Data(comment.text!.utf8)
					if let newText = try? NSAttributedString(data: badText, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
						comment.text = newText.string
					}
				}

				completion(comment)
			} catch let jsonError {
				print(jsonError)
			}
		}.resume()
	}
}
