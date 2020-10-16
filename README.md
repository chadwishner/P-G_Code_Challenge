# P&G Alchemy iOS Code Test

## What is implementated?

 - List of top 500 Hacker News stories in a scrollable view
 - Tapping a story opens a view with more information on the story including comments
 - If the story has a link, a safari icon is shown that can be tapped to open a WebView of the link.
 - Search bar for story titles
 - HTML markers have been removed from text for Stories and Comments are in plain HTML.
 - SwiftUI was used so the application is compatible with iOS13+

## Current issues/areas for improvement

 - I am running into issues trying to figure out how to add animations to the app. I am attempting to add a .matchedGeometryEffect for the transition to/from a StoryRowView and a StoryView.
 - Currently the Network classes do not add Stories or Comments into their arrays in order they are sent, this causes out of order issues.
 - Occasionally the API calls will timeout this causes a delay in retrieving stories and comments.
 - The scrollview does not resize when search bar narrows list.

## Files

This is a brief overview of the most important files and their usage

### Views/TopStoriesContentView.swift

This represents to landing/home page for the app. Cards are displayed in a ScrollView and a LazyVStack in order to keep formatting minimal. A LazyVStack was used to avoid unnecessary rendering; however, more research should be done on the performance between this option and a List.

### Views/StoryRowView.swift

This represents cards to be viewed from TopStoriesContentView.swift. Cards are designed to show the title, type, score, and author of each post. When the post includes a link the icon will be a safari logo indicating that if the user selects the safari logo they will be brought to a WebView. Otherwise selecting cards opens the StoryView.

### Views/StoryView.swift

This represents stories to view their whole content. Cards are designed to show the title, score, author, text, and comments. When the post includes a link the icon will be a safari logo indicating that if the user selects the safari logo they will be brought to a WebView.

### Network/GetStoryData.swift

This file contains all functions to get the 500 top stories from Hacker News as well as the details for those stories. The functions serve to build an array of Stories. Currently the main issue is that stories are not added to the array in the same order that they are sent out. These means that some stories will appear lower/higher on the ContentView. **GetStoryData()** is instantiated when StoryRowView starts and upon initialization starts retrieving the data.

**getTopStories() -> [Int : Int]**

Current implementation uses a URLSession to call */topstories.json* and builds an array of the top stories. This function calls **getStoryDetails()** for each *Int* ID in the array. A dictionary is returned that assigns the Story ID *Int* to an Index *Int*

**getStoryDetails(id: String) -> Story**

Current implementation uses a URLSession to call */item/[ID].json* and uses a JSONDecoder to decode the response into the **Story** struct. A *Story* is returned.

### Network/GetCommentData.swift

Similar to GetStoryData.swift, this file is designed to retrieve data for the children of a Story, story it in an array of Comments. Currently the main issue is that comments are not added to the array in the same order that they are sent out. These means that some comments will appear lower/higher on the ContentView. **GetCommentData()** is instantiated with StoryView starts and .onAppear it begins to retreive the data. I decided to implement the comment retrieval as a separate class because I was running into barriers trying to update stories that were passed by reference with a closure. The original intent was to have an array of *comment* in the **Story** struct that would be updated when the story is selected. This would allow more efficient use of the API. I would still like to explore this issue but currently don't know the solution. Furthermore this implementation should make is a little easier to get sub-comments; however, I am unsure how to handle the view side of sub-comments.

**getAllComments(story: Story)**

This function loops through all children in the kids array and calls **getCommentHTTP()** it then appends the returning **Comment** to  an array.

**getCommentHTTP(kid: Int) -> Comment**

This function similar to **getStoryDetails()** but instead returns a *Comment*.

### Models/Story.swift

This is the struct used to model a story. Booleans are commented out as in the current implementation only existing and alive stories are requested through the API.

### Models/Comment.swift

This is the struct used to model a comment. Booleans are commented out as in the current implementation only existing and alive comments are requested through the API. The API documentation suggests that these are the only properties that a comment will have.
