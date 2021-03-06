//  SearchBar.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import SwiftUI

/** Search Bar view
*/
struct SearchBar: View {
	@Binding var text: String

	@State private var isEditing = false
		
	var body: some View {
		HStack {
			// Default text
			TextField("Search", text: $text)
				.padding(7)
				.padding(.horizontal, 25)
				.background(Color(.systemGray6))
				.cornerRadius(8)
				.autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
				.overlay(
					HStack {
						Image(systemName: "magnifyingglass")
							.foregroundColor(.gray)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
							.padding(.leading, 8)
						
						// Show exit icon when finished to dismiss keyboard
						if isEditing {
							Button(action: {
								self.text = ""
								
							}) {
								Image(systemName: "multiply.circle.fill")
									.foregroundColor(.gray)
									.padding(.trailing, 8)
									.onTapGesture(count: 1, perform: {
										// Dismiss the keyboard
										UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
										self.isEditing = false
										self.text = ""
									})
							}
						}
					}
				)
				.padding(.horizontal, 10)
				.onTapGesture {
					self.isEditing = true
				}
			
		}
	}
}

/** Used for testing view in preview
*/
struct SearchBar_Previews: PreviewProvider {
	static var previews: some View {
		SearchBar(text: .constant(""))
	}
}
