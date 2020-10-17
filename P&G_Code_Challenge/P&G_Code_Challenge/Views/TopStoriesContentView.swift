//  TopStoriesContentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

//TODO FIX ANIMATION

import SwiftUI
import SwiftUIRefresh

/** Main view struct to handle home page to show card list of articles
*/
struct TopStoriesContentView: View {
	// Allow view to update on new data
	@ObservedObject  var getData = GetData(forStories: true)
	
	// Namespace required for opening animation
	@Namespace private var matchedGeo
	
	// For loading animation
	let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
	@State var leftOffset: CGFloat = -100
	@State var rightOffset: CGFloat = 100
	
	// States for refresh and search
	@State private var isShowing = false
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
					List{
						// SearchBar for searching titles
						SearchBar(text: $searchText)
						
						ForEach(getData.items.filter{
							// Filter checks if items are not comments
							if($0.type != "comment"){
								// Filter checks if search bar is empty, then checks if the Story is not nil, then evaluates .contain
								if (self.searchText.isEmpty){
									return true
								} else if ($0.title != nil){
									return $0.title!.lowercased().contains(self.searchText)
								} else {
									return true
								}
							} else {
								return false
							}
						}, id: \.self){ story in
							// If let used to make sure that the story exists in the stories array
							if let s = story {
									NavigationLink(destination: StoryView(story: s)/*.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)*/){
										StoryRowView(story: s)
									}//.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)
							}
						}
						.listRowBackground(Color.clear)
						
						Text(self.getData.items.count == 500 ? "That's all 500 HN stories!" : (self.searchText.isEmpty) ? "Loading ... " : "")
							.padding(.bottom, 10)
							.frame(maxWidth: .infinity, alignment: .center)
						
							// Load the next stories in topStories when we reach end of list
							.onAppear {
								if (self.getData.items.last != nil){
									getData.getNextStories(int: 10)
								}
							}
					}
					.pullToRefresh(isShowing: $isShowing) {
						getData.refresh()
						DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
							self.isShowing = false
						}
					}
				}
			}
			.padding(-20.0)
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
