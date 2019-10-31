//
//  ContentView.swift
//  ComponentExample
//
//  Created by 张广路 on 2019/10/23.
//  Copyright © 2019 symbool. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello World")
            Spacer(minLength: 1).frame(width: nil, height: 100, alignment: .center)
            Text("I am Symbool").overlay(Circle().path(in: CGRect(x: 0, y: 0, width: 100, height: 100)))
            Circle().stroke(lineWidth: 5).foregroundColor(.orange)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
