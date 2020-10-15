//  HackerStory.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

//TODO CHANGE TO VIEW COMMENTS
	//fix getData
	//call getComments for each child

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
	
	// Allow view to update on new data (for comments)
	@ObservedObject  var getData = GetStoryData()
	@ObservedObject var getCommentData = GetCommentData()
	
	// Namespace required for opening animation
	@Namespace private var matchedGeo
	
	// Param to format a Story
	var story: Story
	
	// Card format
	var body: some View {
		VStack(alignment: .center) {
			HStack(alignment: .top) {
				
				// Image places in navigation link to allow users to click on image to open webView when available
				NavigationLink(destination: (story.url != nil) ? WebView(url: story.url!) : nil){ //can i put nil here?????
					
					// Dynamic Image to display based on type. If there is a url, then a safari icon is displayed
					Image((story.url != nil) ? "link" : story.type)
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
					HStack {
						Text(String(story.score!) + " points by " + story.by)
							.font(.system(size: 10, weight: .bold, design: .default))
							.foregroundColor(.white)
							.padding(.top, 0.5)
					}.padding(.bottom, 10)
				}
			//Spacer()
			}
			
			// if text is available, diplay, otherwise leave blank
			if ((story.text) != nil){
				Text(story.text ?? "")
					.font(.system(size: 12, design: .default))
					.foregroundColor(.white)
					.padding([.leading, .bottom, .trailing], 10.0)
			}

//			getCommentData.getAllComments(story: self.story)
			List(getCommentData.comments){ comment in
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
		.padding(.all, 10)
		//.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)
		.onAppear{
			getCommentData.getAllComments(story: self.story)
		}
    }
}


/** Used for testing view in preview
*/
struct HackerStory_Previews: PreviewProvider {
    static var previews: some View {
		StoryView(story: Story(id: 1, type: "story", by: "Chad", time: 1175714200, text: "Test text afdbwerfjberigerkjghnerighnerkjghergheroigheriogergiohoerihgeriohgerg", url: "www.apple.com", score: 1, title: "P&G iOS Test awdadaddad", descendants: 2))
    }
}
