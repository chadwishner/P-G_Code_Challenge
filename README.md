# P&G Alchemy iOS Code Test

## What is implementated?

 - List of top 500 Hacker News stories in a scrollable view
 - Stories and comments display in order based on their parent's int array.
 - Tapping a story opens a view with more information on the story including comments
 - If the story has a link, a safari icon is shown that can be tapped to open Safari to the link. This works in both the TopStoriesContentView as well as the StoryView
 - Search bar for story titles
 - HTML markers have been removed from text for Stories and Comments are in plain HTML. Upon further inspection of comments, it may be a good idea to create a custom view that interprets the HTML in order to maintain HTML formatting.
 - Necessary text changes color dynamically based on system color (light:dark)
 - Sub-comments show.
 - SwiftUI was used so the application is compatible with iOS13+

## Areas for improvement

 - I am running into issues trying to figure out how to add animations to the app. I am attempting to add a .matchedGeometryEffect for the transition to/from a StoryRowView and a StoryView.
 - I attempted to add a "pull down to refresh" feature to the app, but all available libraries were either out of date or seem to be very laggy and hurt the usability of the app more then it helped.
 - When API calls fail, I have no process to retry for that information.

## Current Issues/Needs more testing
- When the a lot of stories are loaded into the TopStoriesContentView, the scroll becomes very laggy. With more time I would research effiency of UI elements or attempt to de-render stories at the top of the view.
- When opening a story, the comment processing can be very slow and due to the recursion required for sub somments sometimes the user needs to wait an extended period of time. If I am able to figure out the animations, I will add a loading animation.
- I am confident that the data for each story's comments are encapsulated in each view, but more automated testing should be done in order to ensure data is not corrupted.
- I am confident that data is sorted correctly, but more automated testing should be done to ensure this.
- There are some unnecessary function calls that I am trying to get rid of from the view side, but I am unable to solve at the moment. This should not effect usability or features.

## Files

This is a brief overview of the most important files and their usage

### Views/TopStoriesContentView.swift

This represents to landing/home page for the app. Cards are displayed in a ScrollView and a LazyVStack in order to keep formatting minimal. A LazyVStack was used to avoid unnecessary rendering; however, more research should be done on the performance between this option and a List. When the user reaches the bottom of the list, the view asks for 10 more stories to be added. A textView of "Loading..." shows at the bottom.

### Views/StoryRowView.swift

This represents cards to be viewed from TopStoriesContentView.swift. Cards are designed to show the title, type, score, and author of each post. When the post includes a link the icon will be a safari logo indicating that if the user selects the safari logo they will be brought to a WebView. Otherwise selecting cards opens the StoryView.

### Views/StoryView.swift

This represents stories to view their whole content. Cards are designed to show the title, score, author, text, and comments. When the post includes a link the icon will be a safari logo indicating that if the user selects the safari logo they will be brought to a WebView.

### Network/GetData.swift

This file contains all functions to get the 500 top stories from Hacker News as well as the details for those items. The functions serve to build an array of items. Currently the main issue is that items are not added to the array in the same order that they are sent out. This means that some items will appear lower/higher on the ContentView or the StoryView. **GetData()** is instantiated when StoryRowView, StoryView, and CommentView start.  If this class continues to get more complicated function wise, I would consider making a seperate class to handle HTTP network calls as well as an interface that is used to build different classes for the specific functions of different **Types**.

**init(bool: Bool)**
This boolean is used in order to automatically gather the top 500 hacker stories and the details on 20 stories. This is set to false when StoryView and CommentView are used to instantiate so there are no unnecessary API calls.

**refresh()**
This function is intended for use of a pull down refresh bar. Function is commented out as I have not found a suitable library for a pull down refresh.

**getTopStories() -> [Int]**

Current implementation uses a URLSession to call */topstories.json* and builds an array of the top stories. This function calls **getItemDetails()** for each of the first 20 *Int* ID in the array. A dictionary is built assigning that ID to an instance of *Item*.

**getItemData(id: String) -> Story**

Current implementation uses a URLSession to call */item/[ID].json* and uses a JSONDecoder to decode the response into the **Item** struct. This function also removes HTML from the text field, and adds a Date to the data.  An *Item* is returned.

**getNextStories(int: Int)**

This function is designed to load a specific number of stories into the **Story** array. This function is intended to ease the load by only makeing API calls when the user reaches the botom of the current viewable stories.

**getAllComments(item: Item)**
This function loops through all children in the kids array and calls **getItemDetails()** it then appends the returning **Item** to  an array. This function also double checks that we do not add duplicate comments, an issue that could occur if a user leaves a **StoryView** and returns.

### Network/Extensions.swift

This is just an extension file in order to format dates.

### Models/Item.swift

This is the struct used to model any item. Dead is  commented out as in the current implementation only alive items need to be processed
