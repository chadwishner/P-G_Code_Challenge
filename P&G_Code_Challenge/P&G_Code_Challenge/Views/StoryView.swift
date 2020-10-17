//  HackerStory.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.
import SwiftUI

/** Story view struct to handle detailed story information including:
	- image
	- title
	- points
	- author
	- text
	- list of direct children (comments)
*/
struct StoryView: View {
	
	// Allow view to update on new data
	@ObservedObject  var getData = GetData(forStories: false)
	
	// Namespace required for opening animation
	@Namespace private var matchedGeo
	
	// Param to format a Story
	var story: Item
	
	// Card format
	var body: some View {
		VStack(alignment: .center) {
			HStack(alignment: .top) {
				// If a url exists allow users to click on image to open webView when available
				if (story.url != nil){
					Link(destination: URL(string: story.url!)!){
						Image("link")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 50, height: 50)
							.padding(.all, 20)
					}
				} else {
					// Dynamic Image to display based on type. If there is a url, then a safari icon is displayed
					Image(story.type)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50, height: 50)
						.padding(.all, 20)
				}
				VStack(alignment: .leading) {
					Text(story.title!)
						.font(.system(size: 15, weight: .bold, design: .default))
						.foregroundColor(.white)
						.padding([.top, .trailing], 10)
						.fixedSize(horizontal: false, vertical: true)
					
					// Show details about story including how long ago it was posted
					HStack {
						Text(String(story.score!) + " points by " + story.by!)
							.font(.system(size: 10, weight: .bold, design: .default))
							.foregroundColor(.white)
							.padding(.top, 0.5)
						Text("- " + story.date.dateAsString())
							.font(.system(size: 10, weight: .bold, design: .default))
							.foregroundColor(.white)
							.padding(.top, 0.5)
					}.padding(.bottom, 10)
				}
			Spacer()
			}
			
			// If text is available, diplay, otherwise leave blank
			if ((story.text) != nil){
				ScrollView {
					Text(story.text ?? "")
						.font(.system(size: 12, design: .default))
						.foregroundColor(.white)
						.padding([.leading, .bottom, .trailing], 10.0)
				}
			}

			// Create list of comments
			List(getData.items.filter{
				// Filter to make sure we are only displaying comments
				$0.type == "comment" ? true : false
			}){ comment in
				// Build comment view
				CommentView(comment: comment)
			}
			.onAppear{
				UITableView.appearance().separatorStyle = .none
			}
			.listRowBackground(Color.clear)
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.background(Color(red: 32/255, green: 36/255, blue: 38/255))
		.cornerRadius(20)
		.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
		.padding([.horizontal, .bottom], 10)
		.padding(.top, -50)
//		.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)
		
		// Load comment data when the view appears
		.onAppear{
			// Check to see if we have already done the loading (although this doesn't seem to be working as intended)
			if(!getData.hasLoaded && !getData.loading) {
				getData.getAllComments(item: self.story)
			}
		}
	}
}


/** Used for testing view in preview
*/
struct HackerStory_Previews: PreviewProvider {
	static var previews: some View {
		StoryView(story: Item(id: 1, type: "story", by: "Chad", time: 1175714200, text: "Test text afdbwerfjberigerkjghnerighnerkjghergheroigheriogergiohoerihgeriohgerg", url: "www.apple.com", score: 1, title: "P&G iOS Test awdadaddad", descendants: 2))
	}
}
