//  GetData.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import Foundation

/** This class handles all API calls and data processing.
With added complexity I would think about deperating the network functions into a seperate class.
*/
class GetData: ObservableObject {
	
	// Loading variable used for loading animation on TopStoriesContentView
	@Published var loading = false
	
	// Dictionary containing all values, ID to Item, this allows quicker lookup of ID
	@Published var items = [Int: Item]()
	
	@publiashed var sortedItems = [Int]()
	
	// Local variable for 500 Top Stories
	var topStories = [Int]()
	
	/** When app first starts, TopSotriesContentView will initialize this.
	Bool is so that this is custom initializer is only called by this view.
	This way unnecessary network calls don't occur when new StoryViews or CommentViews are initialized.
	*/
	init(forStories: Bool){
		if forStories {
			loading = true
			
			getTopStories { (topStories) in
			}
			loading = false
		}
	}
	
	/** Function for refreshing TopStoriesContentView
	*/
//	func refresh(){
//		stories = [Story?](repeating: nil, count: 500)
//		getTopStories { (topStories) in
////			print(topStories)
//		}
//	}
	
	/** This is a network function that calls for the top 500 Hacker News stories
	*/
	func getTopStories(completion:@escaping ([Int]) -> Void){
		// Build URL and make api call
		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// Process possible error message
			if error != nil {
				print(error as Any)
				return
			}
			
			do {
				// Convert data to a JSON object
				let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
				DispatchQueue.main.async{
					// For each element in JSON object, lets add to an Int array
					if let jsonArray = json as? [Int] {
						for story in jsonArray {
							self.topStories.append(story)
						}
					}
										
					// Get the first 20 stories for TopStoriesContentView
					self.getNextStories(int: 20)
				}
				
				// "Return" top sotries
				completion(self.topStories)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}

	/** Netowrk function to get the details of all item types
	*/
	func getItemData(id: String, completion:@escaping (Item) -> Void){
		// Build URL and make api call

		let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/" + id + ".json?print=pretty")
		URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
			
			// Process possible error message
			if error != nil {
				print(error as Any)
				return
			}
			
			// Create data for JSONDecoder
			guard let data = data else {return}
			
			do {
				// Decode JSON into an item instance
				var item = try JSONDecoder().decode(Item.self, from: data)
				
				// If the item contains text we need to remove the HTML characters
				if item.text != nil {
					let badText = Data(item.text!.utf8)
					if let newText = try? NSAttributedString(data: badText, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
						
						// Replace old text with new text
						item.text = newText.string
					}
				}
				
				// "Return" item
				completion(item)
			} catch let jsonError {
				print(jsonError)
			}
			
		}.resume()
	}
	
	/** Function used for getting next stories when user reaches the end of the list
	@param int for the amount of data you want to retrieve
	*/
	func getNextStories(int: Int){
		
		// Get the next set of storyIDs that have not been loaded yet
		let nextStoryIDs = self.topStories[self.items.count..<self.items.count + int]
		
		// For each story ID we get the data for it
		for int in nextStoryIDs{
			getItemData(id: String(int)){ (story) in
				DispatchQueue.main.async{
					// Add new stories to the dictionary
					self.items[int] = story
				}
			}
		}
	}
	
	/** Function used for getting all the comments for a given item. Works for all types of comments
	@param item to retrieve all children
	*/
	func getAllComments(item: Item){
		
		// If children exist we want to loop through each kid and get the data
		if (item.kids != nil) {
			for kid in item.kids! {
				
				// Want to doublecheck that we are not getting duplicates, this could happen if a user leaves a view and returns hack to it
				if !items.keys.contains(kid){
					getItemData(id: String(kid)) { (newComment) in
						DispatchQueue.main.async{
							
							// Add new comments to the dictionary
							self.items[kid] = (newComment)
						}
					}
				}
			}
		}
	}
}
