//
//  ContentView.swift
//  Dogs-IOS
//
//  Created by Carlos Molina Sáenz on 20/11/23.
//

import SwiftUI
import CoreData

struct ContentView: View {


    var body: some View {
        NavigationView {
            List {

            }
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
}
