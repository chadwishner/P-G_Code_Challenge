//  StoryRow.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/13/20.

import SwiftUI

struct StoryRow: View {
	var story : Story
	
	var body: some View {
		VStack(alignment: .leading){
			HStack(alignment: .bottom){
				Text(story.title!).font(.system(size: 20))
				Text(story.type).font(.system(size: 10)).padding(.bottom, 3.0)
			}
			HStack{
				Text(String(story.score!))
				Text("points by")
				Text(story.by)
				Text("@")
				Text(String(story.time)) //have to convert this
				
				
			}.font(.system(size: 10))
		}
	}
}

struct StoryRow_Previews: PreviewProvider {
    static var previews: some View {
		StoryRow(story: Story(id: 1, type: "link", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: 1, title: "Test Title", descendants: 2))
    }
}
