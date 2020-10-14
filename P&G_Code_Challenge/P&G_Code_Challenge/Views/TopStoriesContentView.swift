//  TopStoriesContentView.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/12/20.
//

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
			.navigationBarTitle(Text("Test"))
		}
		
		//		VStack{
//
//			HStack(alignment: .center, spacing: 20, content: {
//
//				Image("hackernewslogo").resizable().frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding([.top, .leading, .bottom], 10.0)
//				TextField("Search"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(""))
//
//			}).background(Color.orange)
//
//			List{
////				VStack(alignment: .leading){
////					HStack(alignment: .bottom){
////						Text("[Title]").font(.system(size: 20))
////						Text("[type]").font(.system(size: 10)).padding(.bottom, 3.0)
////					}
////					HStack{
////						Text("[###]")
////						Text("points by")
////						Text("[author]")
////						Text("@")
////						Text("[time]")
////
////
////					}.font(.system(size: 10))
////				}
//
//			}
//			Spacer()
//		}
		
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			TopStoriesContentView()
		}
    }
}
