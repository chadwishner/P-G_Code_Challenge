//  GetCommentData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import Foundation

class GetCommentData: ObservableObject {
	@Published var comments = [Comment]()
	
//	init(story: Story){
//		getAllComments(story: story)
//	}
//
	func getAllComments(story: Story){
		if (story.kids != nil) {
			for kid in story.kids! {
				getCommentHTTP(kid: kid) { (newComment) in
					//print(newComment)
					self.comments.append(newComment)
					print(self.comments.capacity)
				}
			}
		}
	}
	
	func getCommentHTTP(kid: Int, completion:@escaping (Comment) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + String(kid) + ".json?print=pretty")
		print(url)
			URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
				//print(data)
				if error != nil {
					print("LOOOOOK FOR ME")
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
//					DispatchQueue.main.async {
//
//					}

					completion(comment)
				} catch let jsonError {
					print(jsonError)
				}
				
			}.resume()
//		}

	}
	
}
