//
//  ContentView.swift
//  MOEUM
//
//  Created by 이시우 on 8/4/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Text("안녕하세요~ 우리는 모음 입니다")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding()
            
        }
        HStack {
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
