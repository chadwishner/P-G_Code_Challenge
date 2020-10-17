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
	
	// Published sorted array of Items
	@Published var items = [Item]()
	
	// Dictionary containing all values, ID to Item, this allows quicker lookup of ID for checking duplicates
	// Unless there is some trick with arrays that allows you to find if an element exists based on Item.ID
	var itemsDict = [Int: Item]()
	
	// Local variable for 500 Top Stories
	var topStories = [Int]()
	
	/** When app first starts, TopSotriesContentView will initialize this.
	Bool is so that this is custom initializer is only called by this view.
	This way unnecessary network calls don't occur when new StoryViews or CommentViews are initialized.
	*/
	init(forStories: Bool){
		if forStories {
			getTopStories { (topStories) in
			}
		}
	}
	
	/** Function for refreshing TopStoriesContentView
	*/
	func refresh(completion:@escaping () -> Void){
		// Erase all data
		items = [Item]()
		itemsDict = [Int: Item]()
		topStories = [Int]()
		
		// Call getTopStories
		getTopStories { (topStories) in
			completion()
		}
	}
	
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
				
				// Add date to Item
				item.date = Date(timeIntervalSince1970: Double(item.time))
				
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
		
		// Get the next set of storyIDs that have not been loaded yet, check to make sure we don't have an index out of bounds
		if (self.items.count < 500){
			let nextStoryIDs = self.topStories[self.items.count...((self.items.count + int < 500) ? self.items.count + int : 499)]
				
				// For each story ID we get the data for it
				for int in nextStoryIDs{
					getItemData(id: String(int)){ (story) in
						DispatchQueue.main.async{
							// Add new stories to the dictionary
							self.itemsDict[int] = story
							
							// Sort items array, unfortunetly this has to be done each time an item is added...
							self.sortItemArray(parentArray: self.topStories)
						}
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
				if !itemsDict.keys.contains(kid){
					getItemData(id: String(kid)) { (newComment) in
						DispatchQueue.main.async{
							
							// Add new comments to the dictionary
							self.itemsDict[kid] = (newComment)
							
							// Sort items array, unfortunetly this has to be done each time an item is added...
							self.sortItemArray(parentArray: item.kids!)
						}
					}
				}
			}
		}
	}
	
	/** Sorting function to provide a sorted array of Items based on a parent array
	The parent array is whatever array stores the sorted IDs of the non-sorted set. For stories this is the topStories array, for comments it is the Story.kids array
	*/
	func sortItemArray(parentArray: [Int]){
		
		// Set loading to true so we can display loading animation
		loading = true
		
		// Sort and add to array
		self.items = Array(self.itemsDict.values).sorted{
			
			// Compare the index that the item's ID exists in the parent array
			return parentArray.firstIndex(of: $0.id)! < parentArray.firstIndex(of: $1.id)!
		}
		
		// Set loading to false so we can hide loading animation
		loading = false
	}
}
