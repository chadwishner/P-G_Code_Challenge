//  SearchBar.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import SwiftUI

/** Search bar created use
https://medium.com/@axelhodler/creating-a-search-bar-for-swiftui-e216fe8c8c7f
*/
struct SearchBar: UIViewRepresentable {

	@Binding var text: String

	class Coordinator: NSObject, UISearchBarDelegate {

		@Binding var text: String

		init(text: Binding<String>) {
			_text = text
		}

		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			text = searchText
		}
	}

	func makeCoordinator() -> SearchBar.Coordinator {
		return Coordinator(text: $text)
	}

	func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
		let searchBar = UISearchBar(frame: .zero)
		searchBar.delegate = context.coordinator
		searchBar.searchBarStyle = .minimal
		searchBar.autocapitalizationType = .none
		searchBar.placeholder = "Search"
		return searchBar
	}

	func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
		uiView.text = text
	}
}
