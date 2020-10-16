//  StoryRow.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/13/20.

import SwiftUI

/** Story row view struct to layout of cards in the main view's list
*/
struct StoryRowView: View {
	// Param to format a Story
	var story : Story

	// Card format
	var body: some View {
		HStack(alignment: .center) {
			// If a url exists allow users to click on image to open webView when available
			if (story.url != nil){
				NavigationLink(destination: WebView(url: story.url!)){
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
				Text(story.title)
					.font(.system(size: 15, weight: .bold, design: .default))
					.foregroundColor(.white)
					.padding(.top, 10)
					.padding(.bottom, 0.5)
				
				// Dynamic Text based on url. If there is a url show "link" else show story type
				Text((story.url != nil) ? "link" : story.type)
					.font(.system(size: 8, weight: .bold, design: .default))
					.foregroundColor(.gray)
				HStack {
					Text(String(story.score!) + " points by " + story.by)
						.font(.system(size: 10, weight: .bold, design: .default))
						.foregroundColor(.white)
						.padding(.top, 2)
						.padding(.bottom, 10)
				}
			}.padding(.trailing, 20)
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.background(Color(red: 32/255, green: 36/255, blue: 38/255))
		.cornerRadius(20)
		.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
		.padding(.all, 10)
	}
}

/** Used for testing view in preview
*/
struct StoryRow_Previews: PreviewProvider {
    static var previews: some View {
		StoryRowView(story: Story(id: 1, type: "job", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: 1, title: "Test Title", descendants: 2))
    }
}
