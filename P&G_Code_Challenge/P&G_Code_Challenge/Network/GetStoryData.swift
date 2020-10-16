//  GetData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

class GetStoryData: ObservableObject {
	@Published var loading = false
	//@Published var stories = [Story?](repeating: nil, count: 500)
	
	@Published var stories = [Item?]()
	var topStories = [Int]()
	
	init(){
		loading = true
		
		getTopStories { (topStories) in
//			print(topStories)
		}
		loading = false
	}
	
//	func refresh(){
//		stories = [Story?](repeating: nil, count: 500)
//		getTopStories { (topStories) in
////			print(topStories)
//		}
//	}
	
//	func getTopStories(completion:@escaping ([Int:Int]) -> Void){
//		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
//		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
//			if error != nil {
//				print(error as Any)
//				return
//			}
//
//			do {
//				let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//
//				var topStories = [Int:Int]()
//				var index = 0
//
//				if let jsonArray = json as? [Int] {
//					for story in jsonArray {
//						let storyID = story as Int
//						topStories[storyID] = index
//						index += 1
//
//						self.getStoryData(id: "\(storyID)") { (story) in
//
//							DispatchQueue.main.async { [self] in
//
//								self.stories.insert(story, at: topStories[story.id]!) //insert at a given ID
////								print("Storyid", story.id)
////								print("at", topStories[story.id]!)
////								print(self.stories.capacity)
//							}
//						}
//					}
//				}
//
//				completion(topStories)
//				//print(topStories)
//			} catch let jsonError {
//				print(jsonError)
//			}
//
//		}.resume()
//	}

	func getItemData(id: String, completion:@escaping (Item) -> Void){
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + id + ".json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			guard let data = data else {return}
			
			do {
				var hackerStory = try JSONDecoder().decode(Item.self, from: data)
				if hackerStory.text != nil {
					let badText = Data(hackerStory.text!.utf8)
					if let newText = try? NSAttributedString(data: badText, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
						hackerStory.text = newText.string
					}
				}
				

				completion(hackerStory)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
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
				DispatchQueue.main.async{
					if let jsonArray = json as? [Int] {
						for story in jsonArray {
							self.topStories.append(story)
						}
					}
					
					print(self.topStories.count)
					self.getNextStories(int: 20)
				}
				
				completion(self.topStories)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}
	
	func getNextStories(int: Int){
		print("get next", topStories.count)
		let nextStoryIDs = self.topStories[self.stories.count..<self.stories.count + int]
		for int in nextStoryIDs{
			print(topStories[stories.count])
			getItemData(id: String(int)){ (story) in
				DispatchQueue.main.async{
					self.stories.append(story)
					print(self.stories.count)
				}
			}
		}
	}
}
