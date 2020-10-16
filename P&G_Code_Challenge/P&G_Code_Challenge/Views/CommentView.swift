//  CommentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/14/20.

import SwiftUI

/** Simple view struct to comment information including:
	- text
	- author
*/
struct CommentView: View {
	// This is to switch text color based on system color (light:dark)
	@Environment(\.colorScheme) var colorScheme
	@ObservedObject var getCommentData = GetCommentData()
	
	// Param to format a Comment
	var comment: Comment
	
	// Comment format
	var body: some View {
		VStack(alignment: .leading){
			Text(comment.text!)
				.font(.system(size: 10, design: .default))
				// Dynamic color changing based on system color
				.foregroundColor(colorScheme != .dark ? Color.black : Color.white)
				.padding(.horizontal, 13.0)
			Text(comment.by)
				.font(.system(size: 10, weight: .bold, design: .default))
				.foregroundColor(.gray)
				.padding(.horizontal, 10.0)
			if (comment.kids != nil) {
				List(Array(getCommentData.comments.values)){ comment in
					CommentView(comment: comment)
						.fixedSize(horizontal: false, vertical: true)
				}
			}
		}
		.onAppear{
			getCommentData.getAllSubComments(comment: self.comment)
		}
    }
}

/** Used for testing view in preview
*/
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment(id: 3, type: "comment", by: "Chad", time: 1245, text: "This is a comment", parent: 1))
    }
}
