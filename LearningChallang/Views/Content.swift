//
//  Content.swift
//  Learning
//
//  Created by May Bader Alotaibi on 25/04/1446 AH.
//


import SwiftUI
import Combine


struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()


    var body: some View {
        NavigationStack {
            VStack {
                // Circle with fire emoji
                ZStack {
                    Circle()
                        .fill(Color.gray2)
                        .frame(width: 150, height: 150)

                    Text("🔥")
                        .font(.system(size: 70))
           }
                .padding(.top, 50)

                // Welcome message
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hello learner!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("This app will help you learn every day")
                            .font(.title3)
                            .foregroundColor(.gray2)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 20)

                // Input and Timeframe Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("I want to learn")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    TextField("", text: $viewModel.goal.text)
                        .modifier(PlaceholderStyle(showPlaceholder: viewModel.goal.text.isEmpty, placeholder: "Swift"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .tint(.orange)
                        .overlay(
                            Rectangle()
                                .frame(width: 360, height: 2)
                                .foregroundColor(Color.gray2),
                            alignment: .bottom
                        )

                    Text("I want to learn it in a")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    // Timeframe buttons
                    HStack {
                        ForEach(["Week", "Month", "Year"], id: \.self) { timeframe in
                            Button(action: { viewModel.selectTimeframe(timeframe) }) {
                                Text(timeframe)
                                    .font(.title3)
                                    .foregroundColor(viewModel.goal.timeframe == timeframe ? .black : .orange)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(viewModel.goal.timeframe == timeframe ? Color.orange : Color.gray2)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 30)

                Spacer()

                // Start button
                NavigationLink(destination: Main(goal: viewModel.goal.text)) {
                    HStack {
                        Text("Start")
                            .font(.title3)
                            .bold()
                        Image(systemName: "arrow.right")
                            .font(.title3)
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 17)
                    .padding(.horizontal, 50)
                    .background(Color.orange)
                    .cornerRadius(8)
                }
                .padding(.bottom, 110)
            }
            .background(Color.black.ignoresSafeArea())
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
