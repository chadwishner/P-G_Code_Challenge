//  SearchBar.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import SwiftUI

/** Search Bar view
Search bar looks a little strange on the list version of the UI, more work should be done for coloring
*/
struct SearchBar: View {
	@Binding var text: String

	@State private var isEditing = false
	
	// This is to switch text color based on system color (light:dark)
	@Environment(\.colorScheme) var colorScheme
		
	var body: some View {
		HStack {
			// Default text
			TextField("Search", text: $text)
				.padding(7)
				.padding(.horizontal, 25)
				.background(Color(colorScheme == .dark ? .white : .systemGray6))
				.foregroundColor(colorScheme == .dark ? .black : .white)
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
