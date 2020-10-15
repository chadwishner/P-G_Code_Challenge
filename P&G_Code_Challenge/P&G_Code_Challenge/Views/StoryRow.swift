//  StoryRow.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/13/20.

import SwiftUI

struct StoryRow: View {
	var story : Story

	var body: some View {
		HStack(alignment: .center) {
			Image(story.type)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 50, height: 50)
				.padding(.all, 20)
					
			VStack(alignment: .leading) {
				Text(story.title!)
					.font(.system(size: 26, weight: .bold, design: .default))
					.foregroundColor(.white)
				Text(story.type)
					.font(.system(size: 16, weight: .bold, design: .default))
					.foregroundColor(.gray)
				HStack {
					Text(story.score! + " points by " + story.by)
						.font(.system(size: 13, weight: .bold, design: .default))
						.foregroundColor(.white)
						.padding(.top, 8)
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

struct StoryRow_Previews: PreviewProvider {
    static var previews: some View {
		StoryRow(story: Story(id: "1", type: "job", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: "1", title: "Test Title", descendants: "2"))
    }
}
