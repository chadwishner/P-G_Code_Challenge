//  GetData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

class GetStoryData: ObservableObject {
	//@Published var loading = false
	@Published var stories = [Story?](repeating: nil, count: 500)
	
	init(){
		//loading = true
		
		getTopStories { (topStories) in
//			print(topStories)
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
						
						self.getStoryData(id: "\(storyID)") { (story) in
							
							DispatchQueue.main.async { [self] in
								self.stories.insert(story, at: topStories[story.id]!) //insert at a given ID
//								print("Storyid", story.id)
//								print("at", topStories[story.id]!)
//								print(self.stories.capacity)
							}
						}
					}
				}
				
				completion(topStories)
				//print(topStories)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}

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
}
