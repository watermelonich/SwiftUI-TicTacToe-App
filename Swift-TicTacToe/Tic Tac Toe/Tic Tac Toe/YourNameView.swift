//
//  YourNameView.swift
//  Tic Tac Toe
//
//  Created by Nich on 9/11/23.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""

    var body: some View {
        VStack {
            Text("This is the name that will be associated with this device.")
            
            TextField("Your Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            
            Button("Set") {
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            
            Image("LaunchScreen")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Tic Tac Toe")
        .inNavigationStack()
    }
}

struct YourNameView_Previews: PreviewProvider {
    static var previews: some View {
        YourNameView()
    }
}
