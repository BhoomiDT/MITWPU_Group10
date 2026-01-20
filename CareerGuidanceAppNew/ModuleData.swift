import Foundation

struct LearningModule {
    let title: String
    let description: String
}

struct LearningDomain {
    let title: String
    let modules: [LearningModule]
}

struct ModuleData {

    static func getDomains() -> [LearningDomain] {
        return [

            LearningDomain(
                title: "Web Development",
                modules: [
                    LearningModule(
                        title: "Document Structure & Tags",
                        description: "Understand the basic structure of web pages using essential HTML tags."
                    ),
                    LearningModule(
                        title: "HTML Forms",
                        description: "Learn how to collect and validate user input using HTML forms."
                    ),
                    LearningModule(
                        title: "Semantic HTML",
                        description: "Write clean, meaningful HTML to improve accessibility and SEO."
                    ),
                    LearningModule(
                        title: "CSS Basics",
                        description: "Style web pages using colors, fonts, spacing, and layouts."
                    ),
                    LearningModule(
                        title: "CSS Box Model",
                        description: "Learn how margin, padding, and borders control layout spacing."
                    ),
                    LearningModule(
                        title: "Flexbox",
                        description: "Build flexible layouts that adapt easily to different screen sizes."
                    ),
                    LearningModule(
                        title: "Grid Layout",
                        description: "Create complex and responsive page layouts using CSS Grid."
                    ),
                    LearningModule(
                        title: "Media Queries",
                        description: "Apply styles based on screen size for responsive design."
                    ),
                    LearningModule(
                        title: "Responsive Design",
                        description: "Design websites that work smoothly across all devices."
                    ),
                    LearningModule(
                        title: "Basic JavaScript",
                        description: "Add simple interactivity and logic to web pages."
                    )
                ]
            ),

            LearningDomain(
                title: "App Development",
                modules: [
                    LearningModule(
                        title: "Swift Basics",
                        description: "Learn core Swift syntax, variables, and data types."
                    ),
                    LearningModule(
                        title: "Control Flow",
                        description: "Use conditions and loops to control program execution."
                    ),
                    LearningModule(
                        title: "Functions in Swift",
                        description: "Write reusable functions to organize your code."
                    ),
                    LearningModule(
                        title: "UIKit Fundamentals",
                        description: "Build user interfaces using UIKit components."
                    ),
                    LearningModule(
                        title: "Auto Layout",
                        description: "Create adaptive layouts using constraints and anchors."
                    ),
                    LearningModule(
                        title: "Navigation Controller",
                        description: "Manage screen transitions and navigation stacks."
                    ),
                    LearningModule(
                        title: "Table Views",
                        description: "Display scrollable lists of structured data."
                    ),
                    LearningModule(
                        title: "Collection Views",
                        description: "Design flexible grid-based and custom layouts."
                    ),
                    LearningModule(
                        title: "Data Persistence",
                        description: "Save and retrieve data locally on the device."
                    ),
                    LearningModule(
                        title: "App Deployment",
                        description: "Prepare, test, and publish apps to the App Store."
                    )
                ]
            ),

            LearningDomain(
                title: "AI & Machine Learning",
                modules: [
                    LearningModule(
                        title: "Introduction to AI",
                        description: "Learn what AI is and how it is used in real life."
                    ),
                    LearningModule(
                        title: "Python for AI",
                        description: "Understand Python basics required for AI development."
                    ),
                    LearningModule(
                        title: "Data Preprocessing",
                        description: "Clean, normalize, and prepare data for training models."
                    ),
                    LearningModule(
                        title: "Supervised Learning",
                        description: "Learn models that train on labeled datasets."
                    ),
                    LearningModule(
                        title: "Unsupervised Learning",
                        description: "Discover patterns in data without labels."
                    ),
                    LearningModule(
                        title: "Neural Networks",
                        description: "Understand the fundamentals of neural network models."
                    ),
                    LearningModule(
                        title: "Deep Learning",
                        description: "Build advanced models using multiple neural layers."
                    ),
                    LearningModule(
                        title: "Model Evaluation",
                        description: "Measure model accuracy and performance effectively."
                    ),
                    LearningModule(
                        title: "Overfitting & Underfitting",
                        description: "Learn how to balance model complexity and accuracy."
                    ),
                    LearningModule(
                        title: "AI Applications",
                        description: "Explore real-world applications of AI systems."
                    )
                ]
            )
        ]
    }
}

