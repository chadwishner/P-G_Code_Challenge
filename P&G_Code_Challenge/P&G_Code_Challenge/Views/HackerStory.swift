//  HackerStory.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

//TODO CHANGE TO VIEW COMMENTS

import SwiftUI

struct HackerStory: View {
	@ObservedObject  var getData = GetData()
	@Namespace private var matchedGeo
	
	var story: Story
	var body: some View {
		VStack(alignment: .center) {
			HStack(alignment: .top) {
				Image(story.type)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 50, height: 50)
					.padding(.all, 20)
						
				VStack(alignment: .leading) {
					Text(story.title!)
						.font(.system(size: 26, weight: .bold, design: .default))
						.foregroundColor(.white)
						.padding(.top, 5)
					HStack {
						Text(String(story.score!) + " points by " + story.by)
							.font(.system(size: 13, weight: .bold, design: .default))
							.foregroundColor(.white)
							.padding(.top, 0.5)
					}.padding(.bottom, 10)
				}
			Spacer()
			}
			Text(story.text ?? "")
				.font(.system(size: 16, design: .default))
				.foregroundColor(.white)
				.padding(.horizontal, 10.0)
			
			for commendID in story.comments {
				getData.getCommentHTTP(commentID: commendID) { (newComment) in
					self.story.comments.append(newComment)
				}
				
			}
			
//change this to a list of comments
			List(getData.stories){ story in //prob needs to be getData.comments, but need to figure out how to get it specific to indiv posts
				//StoryRow(story: story)
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
    }
}

struct HackerStory_Previews: PreviewProvider {
    static var previews: some View {
		HackerStory(story: Story(id: "1", type: "story", by: "Chad", time: 1175714200, text: "Test text afdbwerfjberigerkjghnerighnerkjghergheroigheriogergiohoerihgeriohgerg", url: "www.apple.com", score: "1", title: "P&G iOS Test awdadaddad", descendants: "2"))
    }
}
