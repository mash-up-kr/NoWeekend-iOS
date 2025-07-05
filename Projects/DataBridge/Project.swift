import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "DataBridge",
    targets: [
        .framework(
            name: "DataBridge",
            bundleId: "com.noweekend.databridge",
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "HomeData", path: .relativeToRoot("Projects/Home/HomeData")),
                .project(target: "ProfileData", path: .relativeToRoot("Projects/Profile/ProfileData")),
                .project(target: "CalendarData", path: .relativeToRoot("Projects/Calendar/CalendarData")),
                .project(target: "OnboardingData", path: .relativeToRoot("Projects/Onboarding/OnboardingData")),
                .project(target: "DIContainer", path: .relativeToRoot("Projects/Core"))
            ]
        )
    ]
)
