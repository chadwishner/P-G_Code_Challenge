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
	
	// Loading variabled to make sure we don't make unnecessary function calls with .onAppear()
	@Published var hasLoaded = false
	
	// Published sorted array of Items
	@Published var items = [Item]()
	
	// Dictionary containing all values, ID to Item, this allows quicker lookup of ID for checking duplicates
	// Unless there is some trick with arrays that allows you to find if an element exists based on Item.ID
	private var itemsDict = [Int: Item]()
	
	// Local variable for 500 Top Stories
	private var topStories = [Int]()
	
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
	private func getTopStories(completion:@escaping ([Int]) -> Void){
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
	private func getItemData(id: String, completion:@escaping (Item?) -> Void){
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
				
				// Check if the item is deleted, then lets not do unnecessary things
				if(item.deleted ?? false) {
					completion(nil)
					return
				}
				
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
		
		// Check if we got all stories already
		if (self.items.count < 500){
			// Get the next set of storyIDs that have not been loaded yet, check to make sure we don't have an index out of bounds
			let nextStoryIDs = self.topStories[self.items.count...((self.items.count + int < 500) ? self.items.count + int : 499)]
			
			// Create group to synchronize tasks for sorting
			let storiesGroup = DispatchGroup()
			
			// Create queue to manage tasks serially
			let dispatchQueue = DispatchQueue(label: "storiesDispatchQueue")
			
			// Create semaphore to control resource access
			let dispatchSemaphore = DispatchSemaphore(value: 0)
			
			// Create a temp array that will be the new sorted array of comments
			var tempItems = self.items
				
			// Start Queue
			dispatchQueue.async {
				
				// For each story ID we get the data for it
				for int in nextStoryIDs{
					
					// Enter group
					storiesGroup.enter()
					
					// Get story data and add to dictionary (needed for duplicates) and temp array (sorted array)
					self.getItemData(id: String(int)){ (story) in
						
						if story != nil {
							self.itemsDict[int] = (story!)
							tempItems.append(story!)
						}
						
						// Leave group and increment semaphore
						dispatchSemaphore.signal()
						storiesGroup.leave()
					}
					dispatchSemaphore.wait()
				}
			}
			// Notify that all group tasks are finished
			storiesGroup.notify(queue: dispatchQueue) {
				DispatchQueue.main.async {
					self.items = tempItems
				}
			}
		}
	}
	
	/** Function used for getting all the comments for a given item. Works for all types of comments
	@param item to retrieve all children
	*/
	func getAllComments(item: Item){
		
		// Set loading to that way we don't get race conditions
		self.loading = true
		
		// If children exist we want to loop through each kid and get the data
		if (item.kids != nil) {
			
			// Create group to synchronize tasks for sorting
			let commentsGroup = DispatchGroup()
			
			// Create queue to manage tasks serially
			let dispatchQueue = DispatchQueue(label: "commentsDispatchQueue")
			
			// Create semaphore to control resource access
			let dispatchSemaphore = DispatchSemaphore(value: 0)
			
			// Create a temp array that will be the new sorted array of comments
			var tempItems =  [Item]()
			
			// Start Queue
			dispatchQueue.async {
			
				// Get Comment for each kid of parent
				for kid in item.kids! {
					
					// Want to doublecheck that we are not getting duplicates, this could happen if a user leaves a view and returns hack to it
					if !self.itemsDict.keys.contains(kid){
						
						// Enter group
						commentsGroup.enter()
		
						// Get comment data and add to dictionary (needed for duplicates) and temp array (sorted array)
						self.getItemData(id: String(kid)) { (newComment) in
							
							if(newComment != nil) {
								self.itemsDict[kid] = (newComment!)
								tempItems.append(newComment!)
							}
							
							// Leave group and increment semaphore
							dispatchSemaphore.signal()
							commentsGroup.leave()
						}
						dispatchSemaphore.wait()
					}
				}
			}
			// Notify that all group tasks are finished
			commentsGroup.notify(queue: dispatchQueue) {
				DispatchQueue.main.async {
					
					// Add new items and set bools
					self.items.append(contentsOf: tempItems)
					self.loading = false
					self.hasLoaded = true
				}
			}
		}
		else {
			// If no kids exist we still want to set bool
			self.hasLoaded = true
			
		}
	}
}
