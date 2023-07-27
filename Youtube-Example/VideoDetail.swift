//
//  VideoDetail.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/26.
//

import SwiftUI

struct VideoDetail: View {
    
    let width: CGFloat
    
    var body: some View {
        List {
            Group {
                Text("Official Evo Moment #37, Daigo vs Justin Evo 2004 in HD")
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .padding(.all, 10)
                Text("6.59M Views 7 years ago ...Unfold")
                    .fontWeight(.regular)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                HStack {
                    Image("demo")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                    Text("evo2kvids")
                        .fontWeight(.regular)
                        .font(.system(size: 10))
                        .foregroundColor(.black)
                    Text("74.4k")
                        .fontWeight(.regular)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Spacer()
                    
                    Button { } label: {
                        Text("Subscribe")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Rectangle().fill(.black).cornerRadius(17)
                            )
                    }
                }
                .padding(.all, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach (0..<10) { i in
                            Button { } label: {
                            Text("Action_\(i)")
                                .fontWeight(.regular)
                                .font(.system(size:12))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Rectangle().fill(.gray.opacity(0.15)).cornerRadius(17)
                                )
                            }
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.bottom, 20)
                
                ForEach(0..<10) { _ in
                    VStack(spacing:0) {
                        Rectangle().fill(.gray.opacity(0.15))
                            .frame(width: width, height: width * 0.5625)
                        HStack(spacing:0) {
                            Image("demo")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .cornerRadius(15)
                            Spacer(minLength: 0)
                            VStack(alignment: .leading) {
                                Text("EVO 2004: Daigo Umehara VS. Justin Wong - Alternate Viewpoint!")
                                    .fontWeight(.regular)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 13))
                                    .foregroundColor(.black)
                                Text("MarkMan23・1.02M Views 4 years ago")
                                    .fontWeight(.regular)
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .frame(width: 30)
                        }
                        .padding(.all, 10)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
            .listRowInsets(.init())
            .foregroundColor(.black)
        }
        .environment(\.defaultMinListRowHeight, 1)
        .listStyle(.plain)
        .background(.white)
        .scrollContentBackground(.hidden)
    }
}
