//  TopStoriesContentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

//TODO FIX ANIMATION

import SwiftUI

struct TopStoriesContentView: View {
    @ObservedObject  var getData = GetData()
	@Namespace private var matchedGeo
	
	let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
	@State var leftOffset: CGFloat = -100
	@State var rightOffset: CGFloat = 100
	
	var body: some View {
		NavigationView{
			VStack{
				if false {
					ZStack {
						Circle()
							.fill(Color.blue)
							.frame(width: 20, height: 20)
							.offset(x: leftOffset)
							.opacity(0.7)
							.animation(Animation.easeInOut(duration: 1))
						Circle()
							.fill(Color.blue)
							.frame(width: 20, height: 20)
							.offset(x: leftOffset)
							.opacity(0.7)
							.animation(Animation.easeInOut(duration: 1).delay(0.2))
						Circle()
							.fill(Color.blue)
							.frame(width: 20, height: 20)
							.offset(x: leftOffset)
							.opacity(0.7)
							.animation(Animation.easeInOut(duration: 1).delay(0.4))
					}.onReceive(timer) { (_) in
						swap(&self.leftOffset, &self.rightOffset)
					}
				} else {
					ScrollView{
						LazyVStack{
//might need to fix this because it changed to a dictionary
							ForEach(getData.stories, id: \.self){ story in
								if let s = story {
									NavigationLink(destination: HackerStory(story: s)
													.matchedGeometryEffect(id: "storyOpen", in: matchedGeo))
									{
										StoryRow(story: s)
										
									}//.matchedGeometryEffect(id: "storyOpen", in: matchedGeo)
								}
								
							}
						}
					}
				}
			}
			.navigationBarTitle(Text("Hacker News"))
			
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
