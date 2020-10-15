//  GetData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

class GetData: ObservableObject {
	@Published var loading = false
	//@Published var comments = [String : [Comment]]()
	@Published var stories = [Story?](repeating: nil, count: 500) //initialize this to a value of 500
	
	init(){
		loading = true
		
		var array = [Int:Int]()
		getTopStories { (array) in
			//print(array)
		}
	}
	
	func getTopStories(completion:@escaping ([Int:Int]) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				var topStories = [Int:Int]()
				var index = 0
								
				if let jsonArray = json as? [Int] {
					for story in jsonArray {
						let storyID = story as Int
						topStories[storyID] = index
						index += 1
						//topStories.append(storyID)
						
						self.getStoryData(id: "\(storyID)") { (story) in
							print("Storyid", story.id)
							
							DispatchQueue.main.async {
								self.stories.insert(story, at: topStories[Int(story.id)!]!) //insert at a given ID
							}
						}
						index += 1
					}
				}
				
				completion(topStories)
				//print(topStories)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}

	//TODO fix the async stuff
	func getStoryData(id: String, completion:@escaping (Story) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + id + ".json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			guard let data = data else {return}
			
			do {
				let hackerStory = try JSONDecoder().decode(Story.self, from: data)

				completion(hackerStory)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}

	func getCommentHTTP(commentID: String, completion:@escaping (Comment) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + commentID + ".json?print=pretty")
		
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			guard let data = data else {return}
			
			do {
				let comment = try JSONDecoder().decode(Comment.self, from: data)

//				story.comments.append(comment)
				
				completion(comment)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}
	
//	func getComments(story : Story) -> [Comment]{
//
//
//
//		if comments[story.id] != nil {
//			return comments[story.id]!
//		} else if story.kids != nil{
//			for kid in story.kids! {
//				getCommentsHTTP(id: kid){ [self] (temp) in
//					if self.comments.capacity > 9 {
//						var firstKey = comments.first?.key
//						comments.removeValue(forKey: firstKey!)
//					}
//					comments[story.id]!.append(temp)
//				}
//			}
//		}
//
//
//	}
}
