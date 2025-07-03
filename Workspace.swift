import ProjectDescription

let workspace = Workspace(
    name: "NoWeekend",
    projects: [
        "Projects/App",
        "Projects/Core",
        "Projects/Shared",
        "Projects/Plugin",
        
        // 🏠 Home Module
        "Projects/Home/HomeFeature",
        "Projects/Home/HomeDomain",
        "Projects/Home/HomeData",
        
        // 🧑‍💼 Profile Module
        "Projects/Profile/ProfileFeature",
        "Projects/Profile/ProfileDomain",
        "Projects/Profile/ProfileData",
        
        // 📅 Calendar Module
        "Projects/Calendar/CalendarFeature",
        "Projects/Calendar/CalendarDomain",
        "Projects/Calendar/CalendarData",
        
        // 🚪 Onboarding Module
        "Projects/Onboarding/OnboardingFeature",
        "Projects/Onboarding/OnboardingDomain",
        "Projects/Onboarding/OnboardingData"
    ]
)
