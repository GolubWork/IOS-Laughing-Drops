import SwiftUI

struct CalendarScreen: View {
    @EnvironmentObject var history: HistoryStore
    @State private var referenceDate = Date()
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekDays = Calendar.current.shortWeekdaySymbols

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Spacer()
                
                Text(monthTitle)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()

                LazyVGrid(columns: columns, spacing: 8) {
                    // Заголовки дней недели
                    ForEach(weekDays, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }

                    // Дни месяца
                    ForEach(generateMonthCells().compactMap { $0 }) { cell in
                        VStack(spacing: 4) {
                            Text("\(cell.day)")
                                .font(.callout)
                                .foregroundColor(Calendar.current.isDate(cell.date, equalTo: referenceDate, toGranularity: .month) ? .primary : .gray)
                            
                            ProgressView(value: history.dailyGoal > 0 ? min(Double(cell.amount) / Double(history.dailyGoal), 1.0) : 0)
                                .frame(height: 6)
                                .tint(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(4)
                        .background(Color(UIColor.secondarySystemBackground).opacity(0.6))
                        .cornerRadius(6)
                    }
                }
                .frame(maxWidth: 350)
                .padding()

                HStack {
                    Button(action: { changeMonth(-1) }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Button(action: { changeMonth(1) }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }

    private var monthTitle: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: referenceDate)
    }

    private func changeMonth(_ delta: Int) {
        if let new = Calendar.current.date(byAdding: .month, value: delta, to: referenceDate) {
            referenceDate = new
        }
    }

    struct DayCell: Identifiable {
        let id = UUID()
        let day: Int
        let date: Date
        let amount: Int
    }

    private func generateMonthCells() -> [DayCell?] {
        var cells: [DayCell?] = []
        let cal = Calendar.current
        
        guard let monthRange = cal.range(of: .day, in: .month, for: referenceDate),
              let firstOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: referenceDate)) else {
            return cells
        }

        let firstWeekday = cal.component(.weekday, from: firstOfMonth)
        let leadingEmpty = (firstWeekday - cal.firstWeekday + 7) % 7
        for _ in 0..<leadingEmpty { cells.append(nil) }

        for day in monthRange {
            if let date = cal.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                let amount = cal.isDateInToday(date) ? history.todayML : history.amount(for: date)
                cells.append(DayCell(day: day, date: date, amount: amount))
            }
        }

        while cells.count % 7 != 0 { cells.append(nil) }

        return cells
    }
}
