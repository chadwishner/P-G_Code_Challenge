//  StoryRow.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/13/20.

import SwiftUI

/** Story row view struct to layout of cards in the main view's list
*/
struct StoryRowView: View {
	// Param to format a Story
	var story : Item

	// This is to switch text color based on system color (light:dark)
	@Environment(\.colorScheme) var colorScheme
	
	// Card format
	var body: some View {
		HStack(alignment: .center) {

			// Dynamic Image to display based on type. If there is a url, then a safari icon is displayed
			Image((story.url != nil) ? "link" : story.type)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 50, height: 50)
				.padding(.all, 20)
					
			VStack(alignment: .leading) {
				Text(story.title!)
					.font(.system(size: 15, weight: .bold, design: .default))
					.foregroundColor(colorScheme != .dark ? Color.black : Color.white)
					.padding(.top, 10)
					.padding(.bottom, 0.5)
				
				// Dynamic Text based on url. If there is a url show "link" else show story type
				Text((story.url != nil) ? "link" : story.type)
					.font(.system(size: 8, weight: .bold, design: .default))
					.foregroundColor(.gray)
				HStack {
					Text(String(story.score!) + " points by " + story.by)
						.font(.system(size: 10, weight: .bold, design: .default))
						.foregroundColor(colorScheme != .dark ? Color.black : Color.white)
						.padding(.top, 2)
						.padding(.bottom, 10)
				}
			}.padding(.trailing, 20)
		}
	}
}

/** Used for testing view in preview
*/
struct StoryRow_Previews: PreviewProvider {
    static var previews: some View {
		StoryRowView(story: Item(id: 1, type: "job", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: 1, title: "Test Title", descendants: 2))
    }
}
