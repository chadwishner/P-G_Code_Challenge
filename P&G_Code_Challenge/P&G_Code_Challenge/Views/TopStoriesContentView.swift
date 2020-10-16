//  TopStoriesContentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

//TODO FIX ANIMATION

import SwiftUI

/** Main view struct to handle home page to show card list of articles
*/
struct TopStoriesContentView: View {
	// Allow view to update on new data
	@ObservedObject  var getData = GetStoryData()
	
	// Namespace required for opening animation
	@Namespace private var matchedGeo
	
	// For loading animation
	let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
	@State var leftOffset: CGFloat = -100
	@State var rightOffset: CGFloat = 100
	
	@State private var searchText : String = ""
	
	var body: some View {
		// Use a NavigationView for path hierarchy
		NavigationView{
			// VStack used for layering loading animation
			VStack{
				// Loading animation
				if getData.loading {
					ZStack {
						Circle()
							.fill(Color.blue)
							.frame(width: 20, height: 20)
							.offset(x: leftOffset)
							.opacity(0.7)
							.animation(Animation.easeInOut(duration: 1))
						Circle()
							.fill(Color.blue)
							.frame(width: 20, height: 20)
							.offset(x: leftOffset)
							.opacity(0.7)
							.animation(Animation.easeInOut(duration: 1).delay(0.2))
						Circle()
							.fill(Color.blue)
							.frame(width: 20, height: 20)
							.offset(x: leftOffset)
							.opacity(0.7)
							.animation(Animation.easeInOut(duration: 1).delay(0.4))
					}.onReceive(timer) { (_) in
						swap(&self.leftOffset, &self.rightOffset)
					}
				} else {
					// ScrollView and LazyVStack used in order to avoid visual attributes of a List
					ScrollView{
						// SearchBar for searching titles
						SearchBar(text: $searchText)
						
						LazyVStack{
							ForEach(getData.stories.filter{
								// Filter checks if search bar is empty, then checks if the Story is not nil, then evaluates .contain
								self.searchText.isEmpty ? true : (($0 != nil) ? $0!.title.lowercased().contains(self.searchText) : true)
							}, id: \.self){ story in
								// if let used to make sure that the story exists in the stories array
								if let s = story {
									NavigationLink(destination: StoryView(story: s)/*.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)*/){
										StoryRowView(story: s)
									}//.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)
									.onAppear(){
										if s == getData.stories.last{
											//getData.getNextStories(int: 10)
										}
									}
								}
							}
//							.onAppear {
//								if (self.getData.stories.last != nil){
//									getData.getNextStories(int: 20)
//								}
//							}
						}
					}
				}
			}
			.navigationBarTitle(Text("Hacker News"))
		}
    }
}

/** Used for testing view in preview
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			TopStoriesContentView()
		}
    }
}
