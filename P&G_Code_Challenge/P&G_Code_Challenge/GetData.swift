//  GetData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.
//

import Foundation

var topStories = [Int]()

func getTopStories() -> [Int] {
	let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
	URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
		if error != nil {
			print(error as Any)
			return
		}
		
		do {
			let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
			
			//var topStories = [Int]()
			for story in json as! [Int] {
				let storyID = story as Int
				topStories.append(storyID)
			}
			
			print(topStories)
		} catch let jsonError {
			print(jsonError)
		}
		
	}.resume()
}

func getStoryData(id: String){
	let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + id + ".json?print=pretty")
	URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
		if error != nil {
			print(error as Any)
			return
		}
		
		do {
			let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
			
			print(json)
		} catch let jsonError {
			print(jsonError)
		}
		
	}.resume()
}
