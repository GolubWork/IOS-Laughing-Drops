import SwiftUI
import Charts

struct WaterChartScreen: View {
    @EnvironmentObject var history: HistoryStore

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.container, edges: .all)

                VStack(spacing: 20) {
                    Spacer(minLength: 0)

                    Chart {
                        ForEach(history.lastNDatesCache, id: \.0.timeIntervalSince1970) { (date, amount) in
                            BarMark(
                                x: .value("Date", date),
                                y: .value("mL", amount)
                            )
                            .foregroundStyle(.blue)
                        }
                    }
                    .chartYScale(domain: 0...dynamicMax)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 5)) { value in
                            AxisValueLabel(format: .dateTime.day().month())
                        }
                    }
                    .frame(height: 300)
                    .padding()

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            .navigationTitle("Water Chart")
        }
    }

    private var dynamicMax: Double {
        let values = history.lastNDatesCache.map { Double($0.1) }
        return max(Double(history.dailyGoal), values.max() ?? 0)
    }
}
