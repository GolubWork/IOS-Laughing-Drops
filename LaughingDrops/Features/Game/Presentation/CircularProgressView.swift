import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var title: String
    var subtitle: String?

    var body: some View {
        VStack(spacing: 12) {
            // 🔹 Текст над кругом
            VStack(spacing: 4) {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)

                if let s = subtitle {
                    Text(s)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }

            // 🔹 Круговая диаграмма
            ZStack {
                Circle()
                    .stroke(lineWidth: 18)
                    .opacity(0.15)
                    .foregroundColor(.accentColor)

                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.accentColor)
                    .animation(.easeInOut(duration: 0.4), value: progress)

                Image("glass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
        }
    }
}
