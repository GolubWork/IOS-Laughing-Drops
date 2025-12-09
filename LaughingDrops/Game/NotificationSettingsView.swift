import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject private var manager = NotificationManager.shared
    @State private var newTime = Date()
    @State private var newMessage = "Time to drink!"
    
    private let maxNotifications = 7

    var body: some View {
        NavigationView {
            ZStack {
                // Фон на весь экран
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // MARK: - Create Reminder Section
                    ZStack {
                        Image("frame")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 350) // можно подкорректировать под дизайн
                        
                        VStack(alignment: .center, spacing: 12) {
                            Text("Create reminder")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            DatePicker("", selection: $newTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .padding(.horizontal)
                            
                            TextField("Message", text: $newMessage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            Button(action: addNotification) {
                                ZStack {
                                    Image("button")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 500, height: 70)
                                    
                                    Text("Add reminder")
                                        .foregroundColor(.white)
                                        .bold()
                                        .lineLimit(1) // не переносить на следующую строку
                                        .minimumScaleFactor(0.5) // уменьшаем текст если не помещается
                                        .padding(.horizontal, 8) // немного отступов
                                        .frame(maxWidth: 250) // ограничиваем ширину текста под кнопку
                                }
                            }
                            .disabled(manager.notifications.count >= maxNotifications)
                            .opacity(manager.notifications.count >= maxNotifications ? 0.5 : 1.0)

                        }
                        .padding(16)
                        .frame(maxWidth: 300)
                    }
                    .frame(height: 200) // подбираем высоту frame
                    
                    // MARK: - Your Reminders Section
                    // MARK: - Your Reminders Section
                    ZStack {
                        Image("frame")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 350)
                        
                        VStack(spacing: 8) {
                            Text("Your reminders")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if manager.notifications.isEmpty {
                                Text("No reminders yet")
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                VStack(spacing: 4) {
                                    ForEach(manager.notifications) { item in
                                        HStack {
                                            // Время слева
                                            Text(item.time, style: .time)
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .frame(minWidth: 60, alignment: .leading)
                                            
                                            // Текст уведомления по центру
                                            Text(item.message)
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            
                                            // Кнопка удаления справа
                                            Button(role: .destructive) {
                                                removeNotification(item)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                            .frame(width: 40, alignment: .trailing)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: 320)
                        .frame(maxHeight: .infinity, alignment: .center) // центрируем внутри frame
                    }
                    .frame(height: 220)


                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            .navigationTitle("Notifications")
        }
        .onAppear { manager.requestPermission() }
    }

    private func addNotification() {
        guard manager.notifications.count < maxNotifications else { return }

        let new = NotificationManager.NotificationItem(
            id: UUID(),
            time: newTime,
            message: newMessage
        )
        manager.notifications.append(new)
        manager.save()
        manager.schedule(new)
    }

    private func removeNotification(_ item: NotificationManager.NotificationItem) {
        manager.remove(item)
    }
}
