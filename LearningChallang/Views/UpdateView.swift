//
//  UpdateView.swift
//  Learning
//
//  Created by May Bader Alotaibi on 25/04/1446 AH.
//

////
////  UpdateView.swift
////  Learning
////
////  Created by May Bader Alotaibi on 25/04/1446 AH.
////
import SwiftUI

struct UpdateView: View {
    @StateObject var viewModel : UpdateViewModel

//    init() {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//    }

    var body: some View {
        NavigationStack {
            VStack {
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
                        .background(Color.clear)
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
                .padding(.top, 80)

                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("My Navigation Title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: Main(goal: viewModel.goal.text)) {
                        Text("Update")
                            .foregroundColor(.orang2)
                            .bold()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
