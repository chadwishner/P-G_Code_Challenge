//
//  ContentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.
//

import SwiftUI

struct TopStoriesContentView: View {
    var body: some View {
		VStack{
		
			HStack(alignment: .center, spacing: 20, content: {
							
				Image("hackernewslogo").resizable().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.leading, 10.0)
				TextField("Search"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(""))
			
			}).background(Color.orange)
			
			List{
				VStack(alignment: .leading){
					Text("Title")
					HStack{
						Text("###")
						Text("points by ")
						Text("[author]")
						Text(" @ ")
						Text("[time]")
						
						
					}
				}
				
			}
			Spacer()
		}
		
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			TopStoriesContentView()
		}
    }
}
