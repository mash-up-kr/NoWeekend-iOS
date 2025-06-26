import SwiftUI
import CalendarInterface
import Entity
import UseCase
import DesignSystem

// MARK: - Calendar View Implementation
public struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    
    public init(eventUseCase: EventUseCase) {
        self._viewModel = StateObject(wrappedValue: CalendarViewModel(eventUseCase: eventUseCase))
    }
    
    public var body: some View {
        VStack {
            // Calendar Header
            HStack {
                Text(viewModel.currentMonth)
                    .font(Font.heading2)
                    .foregroundColor(DS.Colors.Text.gray900)
                
                Spacer()
                
                Button(action: {
                    Task { await viewModel.addEvent() }
                }) {
                    DS.Images.icnPlus
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            
            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(viewModel.calendarDays, id: \.self) { day in
                    CalendarDayView(
                        day: day,
                        events: viewModel.getEvents(for: day),
                        isSelected: viewModel.selectedDate == day
                    )
                    .onTapGesture {
                        viewModel.selectDate(day)
                    }
                }
            }
            .padding()
            
            // Event List
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.selectedDateEvents, id: \.id) { event in
                            CalendarEventRow(event: event)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .task {
            await viewModel.loadEvents()
        }
    }
}

// MARK: - Calendar Day View
private struct CalendarDayView: View {
    let day: Date
    let events: [CalendarEvent]
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text("\(Calendar.current.component(.day, from: day))")
                .font(Font.body2)
                .foregroundColor(isSelected ? DS.Colors.Background.white : DS.Colors.Text.gray900)
            
            if !events.isEmpty {
                Circle()
                    .fill(DS.Colors.TaskItem.orange)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 40)
        .background(
            isSelected ? DS.Colors.TaskItem.orange : Color.clear
        )
        .cornerRadius(8)
    }
}

// MARK: - Calendar Event Row
private struct CalendarEventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(event.event.category.color))
                .frame(width: 4)
            
            VStack(alignment: .leading) {
                Text(event.event.title)
                    .font(Font.body1)
                    .foregroundColor(DS.Colors.Text.gray900)
                
                if let description = event.event.description {
                    Text(description)
                        .font(Font.caption)
                        .foregroundColor(DS.Colors.Text.gray700)
                }
            }
            
            Spacer()
            
            VStack {
                Text(event.startTime, style: .time)
                    .font(Font.caption)
                    .foregroundColor(DS.Colors.Text.gray700)
            }
        }
        .padding()
        .background(DS.Colors.Background.gray100)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - ViewModel Implementation
@MainActor
class CalendarViewModel: ObservableObject {
    @Published var events: [CalendarEvent] = []
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    @Published var currentMonth: String = ""
    @Published var calendarDays: [Date] = []
    @Published var selectedDateEvents: [CalendarEvent] = []
    
    private let eventUseCase: EventUseCase
    private let calendar = Calendar.current
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
        updateCalendarDays()
    }
    
    func loadEvents() async {
        isLoading = true
        do {
            let basicEvents = try await eventUseCase.getEvents()
            // Convert Event to CalendarEvent
            events = basicEvents.map { event in
                CalendarEvent(
                    id: UUID().uuidString,
                    event: event,
                    startTime: event.date,
                    endTime: calendar.date(byAdding: .hour, value: 1, to: event.date) ?? event.date
                )
            }
            updateSelectedDateEvents()
        } catch {
            print("Error loading events: \(error)")
        }
        isLoading = false
    }
    
    func addEvent() async {
        // TODO: Add event functionality
        print("Add event tapped")
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        updateSelectedDateEvents()
    }
    
    func getEvents(for date: Date) -> [CalendarEvent] {
        return events.filter { calendar.isDate($0.startTime, inSameDayAs: date) }
    }
    
    private func updateCalendarDays() {
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        currentMonth = dateFormatter.string(from: selectedDate)
        
        // Generate calendar days for the month
        var days: [Date] = []
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        calendarDays = days
    }
    
    private func updateSelectedDateEvents() {
        selectedDateEvents = getEvents(for: selectedDate)
    }
}
