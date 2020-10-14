//  TopStoriesContentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.

import SwiftUI

struct TopStoriesContentView: View {
    @ObservedObject  var getData = GetData()
	
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
					List(getData.stories){ story in
						NavigationLink(destination: HackerStory(story: story)){
							StoryRow(story: story)
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
