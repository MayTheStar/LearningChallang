

import SwiftUI

struct Main: View {
    @StateObject private var viewModel: MainViewModel

    init(goal: String) {
        _viewModel = StateObject(wrappedValue: MainViewModel(goal: goal))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    headerView()
                    VStack(spacing: 10) {
                        calendarView()
                        Divider().background(Color.gray)
                        HStack(spacing: 20) {
                            streakCounterView
                            Divider().background(Color.gray)
                            freezeCounterView
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    logButton
                    freezeButton
                    freezeUsageInfo
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
        }
        .onAppear {
            viewModel.updateDate()
        }
    }

    // MARK: - Log Button
    private var logButton: some View {
        Button(action: {
            viewModel.handleLogAction()
        }) {
            VStack {
                if viewModel.logStatus == .learnedToday || viewModel.logStatus == .freezedToday {
                    Text(viewModel.logStatus == .learnedToday ? "Learned" : "Freezed")
                        .font(.largeTitle)
                        .bold()
                    Text("Today")
                        .font(.largeTitle)
                        .bold()
                } else {
                    Text("Log today as Learned")
                        .font(.largeTitle)
                        .bold()
                }
            }
            .frame(width: 290, height: 290)
            .foregroundColor(viewModel.foregroundColorForStatus)
            .background(Circle().fill(viewModel.backgroundColorForStatus))
        }
        .padding()
    }
    

    // MARK: - Header View
    private func headerView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.formattedDate)
                    .foregroundColor(.gray)

                Text(viewModel.goal)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            .onAppear {
                viewModel.updateDate()
            }

            Spacer()
            
            NavigationLink(destination: UpdateView(viewModel: UpdateViewModel())) {
                ZStack {
                    Circle()
                        .fill(Color.gray2)
                        .frame(width: 50, height: 50)

                    Text("🔥")
                        .font(.system(size: 30))
                }
            }

            .navigationBarBackButtonHidden()
        }
        .background(Color.black)
    }

    // MARK: - Calendar View
    private func calendarView() -> some View {
        VStack {
            HStack {
                Text(viewModel.monthAndYearString())
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Button(action: viewModel.toggleView) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.orange)
                }

                Spacer()

                HStack(spacing: 20) {
                    Button(action: viewModel.previousPeriod) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }

                    Button(action: viewModel.nextPeriod) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.top, 0)
            .padding(.bottom, 10)

            if viewModel.isMonthlyView {
                monthlyCalendarView
            } else {
                weeklyCalendarView
            }
        }
    }

    private var weeklyCalendarView: some View {
        let weekDays = viewModel.currentWeekDates()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(weekDays, id: \.self) { date in
                dayView(for: date)
            }
        }
    }

    private var monthlyCalendarView: some View {
        let monthDays = viewModel.currentMonthDates()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(monthDays, id: \.self) { date in
                dayView(for: date)
            }
        }
    }

    // MARK: - Day View
    private func dayView(for date: Date) -> some View {
        let isLearningDay = viewModel.learningDays.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        let isFreezeDay = viewModel.freezeDays.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        let isToday = Calendar.current.isDate(viewModel.currentDate, inSameDayAs: date)

        return VStack {
            Text(viewModel.weekdayString(for: date))
                .font(.subheadline)
                .bold()
                .foregroundColor(isToday ? .white : .gray)

            Text(viewModel.dayNumber(for: date))
                .font(.title3)
                .bold()
                .frame(width: 40, height: 40)
                .background(
                    isToday && viewModel.isTodayLoggedAsLearned ? Color.orange :
                    isLearningDay ? Color.brown1 :
                    isFreezeDay ? Color.blue1 : Color.clear
                )
                .clipShape(Circle())
                .foregroundColor(
                    isToday && viewModel.isTodayLoggedAsLearned ? Color.white :
                    isLearningDay ? Color.orange :
                    isFreezeDay ? Color.blue.opacity(0.8) :
                    isToday ? Color.orange : .gray
                )
                .onTapGesture {
                    if isToday {
                        viewModel.handleLogAction()
                    } else {
                        viewModel.selectedDate = date
                    }
                }
        }
    }


    // MARK: - Freeze Button
    private var freezeButton: some View {
        Button(action: {
            viewModel.handleFreezeAction()
        }) {
            Text("Freeze day")
                .font(.callout)
                .bold()
                .foregroundColor(.blue)
                .padding()
                .frame(width: 150, height: 60)
                .background(Color(.colorB))
                .cornerRadius(8)
        }
        .padding(.bottom, 30)
    }

    // MARK: - Streak Counter View
    private var streakCounterView: some View {
        VStack {
            HStack {
                Text("\(viewModel.streakCount)")
                    .font(.title)
                    .foregroundColor(.white)
                Text("🔥")
                    .font(.title)
                    .foregroundColor(.white)
            }
            Text("Day streak")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Freeze Counter View
    private var freezeCounterView: some View {
        VStack {
            HStack {
                Text("\(viewModel.frozenCount)")
                    .font(.title)
                    .foregroundColor(.white)
                Text("🧊")
                    .font(.title)
                    .foregroundColor(.white)
            }
            Text("Day frozen")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private var freezeUsageInfo: some View {
        Text("\(viewModel.totalFreezesUsed) out of \(viewModel.freezeLimit) freezes used")
            .foregroundColor(.gray)
            .font(.footnote)
    }
}

#Preview {
    Main(goal: "Learning Swift")
}
