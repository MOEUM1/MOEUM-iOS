//
//  ContentView.swift
//  MOEUM
//
//  Created by 이시우 on 8/4/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("안녕하세요!")
                .font(Font.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            Text("우리는 모일")
                .font(Font.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            Text("만나서 반가워요!")
                .font(Font.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        HStack {
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
