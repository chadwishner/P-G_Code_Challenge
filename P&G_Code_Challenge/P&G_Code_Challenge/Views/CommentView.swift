//
//  CommentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/14/20.
//

import SwiftUI

struct CommentView: View {
	@ObservedObject  var getData = GetData()
	var comment: Comment
	
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

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment(id: 3, type: "comment", by: "Chad", time: 1245, text: "This is a comment", parent: 1))
    }
}
