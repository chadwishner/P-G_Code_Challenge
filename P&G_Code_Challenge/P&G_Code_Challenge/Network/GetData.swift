//  GetData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

class GetData: ObservableObject {
	@Published var loading = false
	@Published var stories = [Story]()
	
	init(){
		loading = true
		stories.append(Story(id: 1, type: "job", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: 1, title: "Test Title", descendants: 2))
		stories.append(Story(id: 2, type: "story", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: 1, title: "Test Title 2", descendants: 2))
	}
	
	func getTopStories(completion:@escaping ([Int]) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				var topStories = [Int]()
				for story in json as! [Int] {
					let storyID = story as Int
					topStories.append(storyID)
				}
				
				completion(topStories)
				print(topStories)
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
				//let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				
				//TODO convert to Story
				//let decoder = JSONDecoder()
				//let hackerStory = try decoder.decode(Story.self, from: json as! Data)
				
				let hackerStory = try JSONDecoder().decode(Story.self, from: data)

				
				completion(hackerStory)
				//print(json)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}


	//TODO figure out how to work with the completion stuff
	//func buildTopSotries() -> [Story]{
	//	var topStoryIDs = [Int]()
	//	getTopStories { (topStoryIDs) in
	//		var topStories = [Story]()
	//
	//		for Int in topStoryIDs{
	//			getStoryData(id: String(Int)) { (temp) in
	//				topStories.append(temp)
	//			}
	//		}
	//		self.loading = false
	//	}
	//
	//
	//
	//}
}
