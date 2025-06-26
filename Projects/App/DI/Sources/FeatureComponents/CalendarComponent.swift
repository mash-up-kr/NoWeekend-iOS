import NeedleFoundation
import Calendar
import CalendarInterface

// MARK: - Calendar Component (Builder 구현)
final class CalendarComponent: Component<CalendarDependency>, CalendarBuilder {
    
    func makeCalendarView() -> AnyView {
        AnyView(CalendarView())
    }
}

 