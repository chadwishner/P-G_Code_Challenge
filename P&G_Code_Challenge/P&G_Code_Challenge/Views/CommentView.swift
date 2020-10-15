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
	
	// Param to format a Comment
	var comment: Comment
	
	// Comment format
	var body: some View {
		VStack(alignment: .leading){
			Text(comment.text!)
				.font(.system(size: 16, design: .default))
				.foregroundColor(.black)
				.padding(.horizontal, 13.0)
			Text(comment.by)
				.font(.system(size: 16, weight: .bold, design: .default))
				.foregroundColor(.gray)
				.padding(.horizontal, 10.0)
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
