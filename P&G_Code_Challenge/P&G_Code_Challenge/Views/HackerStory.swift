//
//  HackerStory.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.
//

import SwiftUI

struct HackerStory: View {
	
	//todo, should have image with title next to it
	var story: Story
	var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HackerStory_Previews: PreviewProvider {
    static var previews: some View {
		HackerStory(story: Story(id: 1, type: "link", by: "Chad", time: 1175714200, text: "Test text", url: "www.apple.com", score: 1, title: "Test Title", descendants: 2))
    }
}
