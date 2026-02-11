//
//  Quiz.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import Foundation
import UIKit

enum LessonStatus: String {
    case startTest = "Start Test"
    case seeResults = "See Results"
}

struct Lesson {
    let id: String
    let name: String
    let subtitle: String
    let dueDate: String
    let status: LessonStatus
    var videos: [VideoResource]?
    var documents: [DocResource]?
}

struct VideoResource {
    let lessonId: String?
    let title: String
    let duration: String
    let thumbnailName: String
    let videoURL: String
}

struct DocResource {
    let lessonId: String?
    let title: String
    let readTime: String
    let docURL: String
}


struct ModuleNew {
    let title: String
    let lessons: [Lesson]
}

struct Roadmap {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let percentage: Int
    let milestones: [Milestone]
    var isStarted: Bool
}

struct Milestone {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: UIColor?
    let iconBackgroundColor: UIColor?
    let lessons: [Lesson]
}

struct Quiz: Codable {
    let lessonId: String
    let lessonName: String
    let durationMinutes: Int
    let passingPercent: Int
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct QuizSession {
    let domainTitle: String
    let moduleTitle: String
    let lessonId: String
    let quiz: Quiz

    var selectedOptionIndices: [Int?]
}

struct TestFactory {

    static func makeQuiz(
        lessonId: String,
        lessonName: String
    ) -> Quiz {

        switch lessonId {

        // =====================================================
        // MARK: - DATA SCIENCE
        // =====================================================

        case "data_types":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which data type best fits customer names?",
                        options: ["Integer", "Float", "String", "Boolean"],
                        correctIndex: 2
                    ),
                    QuizQuestion(
                        question: "Temperature recorded continuously is:",
                        options: ["Discrete", "Continuous", "Categorical", "Binary"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "High, Medium, Low represents:",
                        options: ["Ordinal", "Nominal", "Ratio", "Interval"],
                        correctIndex: 0
                    )
                ]
            )

        case "data_collection":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which is a primary data collection method?",
                        options: ["Books", "Surveys", "Blogs", "Research papers"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "Web scraping is used to:",
                        options: ["Clean data", "Extract website data", "Train models", "Deploy APIs"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "Most APIs communicate using:",
                        options: ["FTP", "SMTP", "HTTP/HTTPS", "SSH"],
                        correctIndex: 2
                    )
                ]
            )

        case "sql_queries":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which SQL keyword removes duplicate rows?",
                        options: ["ONLY", "UNIQUE", "DISTINCT", "FILTER"],
                        correctIndex: 2
                    ),
                    QuizQuestion(
                        question: "LEFT JOIN returns:",
                        options: [
                            "Only matching rows",
                            "All rows from right table",
                            "All rows from left table",
                            "No rows"
                        ],
                        correctIndex: 2
                    ),
                    QuizQuestion(
                        question: "Correct SQL clause order:",
                        options: [
                            "SELECT WHERE FROM",
                            "SELECT FROM WHERE",
                            "FROM SELECT WHERE",
                            "WHERE FROM SELECT"
                        ],
                        correctIndex: 1
                    )
                ]
            )

        case "pandas_mastery":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Load CSV in Pandas using:",
                        options: ["pd.load()", "pd.open()", "pd.read_csv()", "pd.import()"],
                        correctIndex: 2
                    ),
                    QuizQuestion(
                        question: "A Pandas Series is:",
                        options: ["2D table", "1D labeled array", "Matrix", "Dictionary"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "df.head() returns:",
                        options: ["Last rows", "Column names", "First rows", "Statistics"],
                        correctIndex: 2
                    )
                ]
            )

        // =====================================================
        // MARK: - MACHINE LEARNING AI
        // =====================================================

        case "ml_intro":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Supervised learning requires:",
                        options: ["Unlabeled data", "Labeled data", "No data", "Random data"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "Spam detection is an example of:",
                        options: ["Regression", "Classification", "Clustering", "Reinforcement"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "Inference in ML means:",
                        options: ["Training", "Predicting on new data", "Cleaning data", "Tuning model"],
                        correctIndex: 1
                    )
                ]
            )

        case "ml_math":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 15, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "A tensor is:",
                        options: ["Scalar", "Vector", "Matrix", "Multi-dimensional array"],
                        correctIndex: 3
                    ),
                    QuizQuestion(
                        question: "Gradient Descent minimizes:",
                        options: ["Accuracy", "Loss function", "Epoch count", "Variance"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "Correlation measures:",
                        options: ["Causation", "Relationship strength", "Bias", "Distance"],
                        correctIndex: 1
                    )
                ]
            )

        case "regression_basics":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Regression models predict:",
                        options: ["Categories", "Text", "Continuous values", "Clusters"],
                        correctIndex: 2
                    ),
                    QuizQuestion(
                        question: "Overfitting occurs when:",
                        options: [
                            "Model is too simple",
                            "Model learns noise",
                            "No training data",
                            "High bias exists"
                        ],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "R² score represents:",
                        options: [
                            "Speed of training",
                            "Variance explained",
                            "Error rate",
                            "Loss value"
                        ],
                        correctIndex: 1
                    )
                ]
            )

        case "classification_models":
            return Quiz(
                lessonId: lessonId, lessonName: lessonName,
                durationMinutes: 10, passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Logistic Regression is used for:",
                        options: ["Regression", "Classification", "Clustering", "Ranking"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "Confusion matrix is used to:",
                        options: ["Store data", "Evaluate classification", "Train model", "Optimize loss"],
                        correctIndex: 1
                    ),
                    QuizQuestion(
                        question: "SVM aims to maximize:",
                        options: ["Error", "Margin", "Depth", "Variance"],
                        correctIndex: 1
                    )
                ]
            )
            
            // =====================================================
            // MARK: - DATA ENGINEERING
            // =====================================================

            case "de_data_models":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "OLAP systems are optimized for:",
                            options: ["Transactions", "Analytics queries", "Low latency writes", "Security"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Which schema is commonly used in data warehouses?",
                            options: ["Tree schema", "Star schema", "Flat schema", "Heap schema"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Fact tables primarily store:",
                            options: ["Dimensions", "Metrics and measures", "Indexes", "Metadata"],
                            correctIndex: 1
                        )
                    ]
                )

            case "data_pipelines":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "ETL stands for:",
                            options: [
                                "Extract Transform Load",
                                "Encrypt Transfer Load",
                                "Execute Track Log",
                                "Enter Transform Loop"
                            ],
                            correctIndex: 0
                        ),
                        QuizQuestion(
                            question: "Apache Airflow is mainly used for:",
                            options: [
                                "Data visualization",
                                "Pipeline orchestration",
                                "Data storage",
                                "Model training"
                            ],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Streaming pipelines process data:",
                            options: ["In batches", "In real-time", "Once per day", "Manually"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - DEVOPS CLOUD
            // =====================================================

            case "devops_ci_cd":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "CI/CD pipelines automate:",
                            options: ["Design", "Build, test, and deployment", "UI creation", "Database tuning"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "CI stands for:",
                            options: [
                                "Cloud Infrastructure",
                                "Continuous Integration",
                                "Code Installation",
                                "Compute Instance"
                            ],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "CD focuses on:",
                            options: ["Testing only", "Continuous delivery/deployment", "Code writing", "Monitoring"],
                            correctIndex: 1
                        )
                    ]
                )

            case "devops_docker":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Docker containers package:",
                            options: ["Only source code", "App and its dependencies", "Only OS kernel", "Hardware drivers"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Containers are best described as:",
                            options: ["Heavy virtual machines", "Lightweight and isolated", "Stateful systems", "Hardware based"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Docker improves:",
                            options: ["UI design", "Environment consistency", "Network speed", "Code readability"],
                            correctIndex: 1
                        )
                    ]
                )

            case "cloud_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "IaaS provides:",
                            options: ["Applications", "Platforms", "Virtualized infrastructure", "Managed databases"],
                            correctIndex: 2
                        ),
                        QuizQuestion(
                            question: "AWS EC2 is an example of:",
                            options: ["SaaS", "PaaS", "IaaS", "FaaS"],
                            correctIndex: 2
                        ),
                        QuizQuestion(
                            question: "Cloud scalability means:",
                            options: [
                                "Fixed resources",
                                "Elastic scaling based on demand",
                                "Offline systems",
                                "Manual upgrades"
                            ],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - WEB DEVELOPMENT
            // =====================================================

            case "html_css":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "HTML is used for:",
                            options: ["Styling", "Structure", "Logic", "Deployment"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "CSS controls:",
                            options: ["Backend logic", "Database schema", "Presentation and layout", "Routing"],
                            correctIndex: 2
                        ),
                        QuizQuestion(
                            question: "Which unit is responsive?",
                            options: ["px", "em", "vh/vw", "pt"],
                            correctIndex: 2
                        )
                    ]
                )

            case "javascript_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "JavaScript primarily runs:",
                            options: ["Only on servers", "Only in browsers", "In browsers and servers", "Only on mobile"],
                            correctIndex: 2
                        ),
                        QuizQuestion(
                            question: "Which keyword declares a constant?",
                            options: ["var", "let", "const", "static"],
                            correctIndex: 2
                        ),
                        QuizQuestion(
                            question: "Which type is NOT native to JavaScript?",
                            options: ["Number", "Boolean", "String", "Character"],
                            correctIndex: 3
                        )
                    ]
                )

            case "express_js":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Express.js is a:",
                            options: [
                                "Frontend framework",
                                "Node.js web framework",
                                "Database engine",
                                "Mobile SDK"
                            ],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "POST requests are used to:",
                            options: ["Fetch data", "Create data", "Delete data", "Cache data"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Middleware in Express:",
                            options: [
                                "Handles HTTP requests before routes",
                                "Stores data permanently",
                                "Compiles JavaScript",
                                "Manages UI state"
                            ],
                            correctIndex: 0
                        )
                    ]
                )

            // =====================================================
            // MARK: - SOFTWARE DEVELOPMENT
            // =====================================================

            case "sd_programming_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "A variable is used to:",
                            options: ["Store values", "Run loops", "Define classes", "Compile code"],
                            correctIndex: 0
                        ),
                        QuizQuestion(
                            question: "Loops are used to:",
                            options: ["Store data", "Repeat execution", "Create UI", "Test hardware"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Which is a conditional statement?",
                            options: ["for", "while", "if", "break"],
                            correctIndex: 2
                        )
                    ]
                )

            case "sd_oops":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "OOP stands for:",
                            options: [
                                "Object Oriented Programming",
                                "Open Operational Process",
                                "Optimized Object Path",
                                "Only Object Programming"
                            ],
                            correctIndex: 0
                        ),
                        QuizQuestion(
                            question: "Inheritance allows:",
                            options: [
                                "Multiple main functions",
                                "Reusing existing code",
                                "Deleting parent classes",
                                "Hiding methods"
                            ],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Encapsulation means:",
                            options: [
                                "Hiding internal details",
                                "Exposing all variables",
                                "Avoiding classes",
                                "Using only functions"
                            ],
                            correctIndex: 0
                        )
                    ]
                )
            // =====================================================
            // MARK: - MOBILE APP DEVELOPMENT
            // =====================================================

            case "mobile_app_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "What defines the lifecycle of a mobile app?",
                            options: ["UI only", "App launch, background, foreground states", "Database schema", "Network speed"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Which platform is used for Android development?",
                            options: ["Xcode", "Android Studio", "VS Code", "IntelliJ only"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Mobile apps should primarily focus on:",
                            options: ["Heavy animations", "User experience and performance", "Large file sizes", "Complex navigation"],
                            correctIndex: 1
                        )
                    ]
                )

            case "mobile_ui_design":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Responsive design ensures:",
                            options: ["Fixed layouts", "Apps work across screen sizes", "Only tablets work", "No scrolling"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Touch targets should be:",
                            options: ["Very small", "Large enough for fingers", "Text-only", "Hidden"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Consistency in UI helps:",
                            options: ["Increase confusion", "Improve usability", "Slow apps", "Reduce performance"],
                            correctIndex: 1
                        )
                    ]
                )

            case "mobile_state_mgmt":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "State management handles:",
                            options: ["Hardware", "UI and data flow", "App icons", "APK size"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Unidirectional data flow means:",
                            options: ["Random updates", "Data flows in one direction", "Two-way binding only", "No state"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "State changes should trigger:",
                            options: ["Crashes", "UI updates", "Reinstall", "Network calls only"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - UI UX ENGINEERING
            // =====================================================

            case "ux_principles":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "UX primarily focuses on:",
                            options: ["Visual colors", "User experience", "Backend logic", "Databases"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "User-centered design means:",
                            options: ["Design for developers", "Design for end users", "Design for managers", "Design randomly"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Usability refers to:",
                            options: ["Speed only", "Ease of use", "Code quality", "Aesthetics only"],
                            correctIndex: 1
                        )
                    ]
                )

            case "ui_design":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Visual hierarchy helps users:",
                            options: ["Get confused", "Understand importance of elements", "Ignore content", "Slow down"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "White space is used to:",
                            options: ["Waste space", "Improve readability", "Hide content", "Reduce UX"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Consistency in UI improves:",
                            options: ["Cognitive load", "Learnability", "Errors", "Complexity"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - CYBER SECURITY
            // =====================================================

            case "networking_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Which OSI layer handles IP addressing?",
                            options: ["Transport", "Network", "Session", "Presentation"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "TCP is:",
                            options: ["Connectionless", "Reliable", "Faster than UDP", "Stateless"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "DNS is used to:",
                            options: ["Encrypt data", "Resolve domain names", "Store passwords", "Send emails"],
                            correctIndex: 1
                        )
                    ]
                )

            case "cia_triad":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Confidentiality ensures:",
                            options: ["Data availability", "Authorized access only", "Data integrity", "Fast access"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Integrity ensures:",
                            options: ["Data is unchanged", "Data is hidden", "Data is accessible", "Data is backed up"],
                            correctIndex: 0
                        ),
                        QuizQuestion(
                            question: "DoS attacks target:",
                            options: ["Integrity", "Availability", "Confidentiality", "Authentication"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - BLOCKCHAIN DEVELOPMENT
            // =====================================================

            case "intro_blockchain":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Blockchain is a:",
                            options: ["Central database", "Distributed ledger", "File system", "Cache"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Each block contains:",
                            options: ["Only transactions", "Previous hash + data", "Passwords", "Keys only"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Immutability comes from:",
                            options: ["Admins", "Cryptographic hashing", "Cloud hosting", "Speed"],
                            correctIndex: 1
                        )
                    ]
                )

            case "solidity_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Solidity is used for:",
                            options: ["Mining", "Smart contracts", "Wallets", "Consensus"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Ethereum address type is:",
                            options: ["string", "uint", "address", "bool"],
                            correctIndex: 2
                        ),
                        QuizQuestion(
                            question: "Mappings store:",
                            options: ["Arrays", "Key-value pairs", "Trees", "Graphs"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - GAME DEVELOPMENT
            // =====================================================

            case "game_dev_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Game loop controls:",
                            options: ["UI only", "Game state updates", "Network", "Storage"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Popular game engines include:",
                            options: ["Unity, Unreal", "Docker, Kubernetes", "React, Angular", "TensorFlow"],
                            correctIndex: 0
                        ),
                        QuizQuestion(
                            question: "Physics engines handle:",
                            options: ["AI logic", "Collisions and movement", "Textures", "Sound"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - AR VR DEVELOPMENT
            // =====================================================

            case "arvr_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "AR overlays:",
                            options: ["Virtual worlds", "Digital objects on real world", "Only videos", "2D graphics"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "VR creates:",
                            options: ["Real environment", "Fully virtual environment", "Text UI", "Dashboards"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "AR/VR requires:",
                            options: ["High latency", "Low latency rendering", "No sensors", "Only keyboard input"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - SYSTEMS EMBEDDED
            // =====================================================

            case "embedded_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Embedded systems are:",
                            options: ["General computers", "Dedicated systems", "Web apps", "Mobile apps"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Microcontrollers include:",
                            options: ["CPU only", "CPU + memory + peripherals", "Only RAM", "Only storage"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Embedded systems prioritize:",
                            options: ["UX animations", "Real-time constraints", "Large screens", "High storage"],
                            correctIndex: 1
                        )
                    ]
                )

            // =====================================================
            // MARK: - PRODUCT MANAGEMENT
            // =====================================================

            case "pm_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName,
                    durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(
                            question: "Product management focuses on:",
                            options: ["Only coding", "Delivering customer value", "Design only", "Testing only"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "A product roadmap shows:",
                            options: ["Daily tasks", "Vision and priorities", "Bug list", "Code files"],
                            correctIndex: 1
                        ),
                        QuizQuestion(
                            question: "Stakeholders include:",
                            options: ["Only developers", "Users, business, tech teams", "Only managers", "Only testers"],
                            correctIndex: 1
                        )
                    ]
                )

        // =====================================================
        // MARK: - DEFAULT
        // =====================================================

        default:
            return Quiz(
                lessonId: lessonId,
                lessonName: lessonName,
                durationMinutes: 20,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Quiz not yet configured for this lesson.",
                        options: ["OK"],
                        correctIndex: 0
                    )
                ]
            )
        }
    }
}

var allRoadmapsData: [Roadmap] = [

    // MARK: - Machine Learning AI
    Roadmap(
        title: "Machine Learning AI",
        subtitle: "Intelligent Systems Track",
        description: "Build predictive, intelligent, and scalable AI systems using modern ML techniques.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "ML Foundations",
                subtitle: "Core concepts",
                iconName: "brain.head.profile",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                lessons: [
                    Lesson(
                        id: "ml_intro",
                        name: "Introduction to Machine Learning",
                        subtitle: "Supervised, unsupervised, and reinforcement learning.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ml_intro", title: "ML Explained", duration: "12:00", thumbnailName: "ml1", videoURL: "https://www.youtube.com/watch?v=ukzFI9rgwfU")
                        ],
                        documents: [
                            DocResource(lessonId: "ml_intro", title: "ML Basics", readTime: "8 min read", docURL: "https://developers.google.com/machine-learning/crash-course")
                        ]
                    ),
                    Lesson(
                        id: "ml_math",
                        name: "Math for ML",
                        subtitle: "Linear algebra, probability, calculus.",
                        dueDate: "Jan 7",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ml_math", title: "Math for ML", duration: "15:00", thumbnailName: "ml2", videoURL: "https://www.youtube.com/watch?v=fNk_zzaMoSs")
                        ],
                        documents: [
                            DocResource(lessonId: "ml_math", title: "ML Mathematics", readTime: "10 min read", docURL: "https://towardsdatascience.com/the-mathematics-of-machine-learning-894f046c568")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "Core Models",
                subtitle: "Classical ML algorithms",
                iconName: "chart.line.uptrend.xyaxis",
                iconColor: UIColor(hex: "#E67E22"),
                iconBackgroundColor: UIColor(hex: "#FDF2E9"),
                lessons: [
                    Lesson(
                        id: "regression_basics",
                        name: "Regression Models",
                        subtitle: "Linear and polynomial regression.",
                        dueDate: "Jan 12",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "regression_basics", title: "Regression Explained", duration: "14:00", thumbnailName: "ml3", videoURL: "https://www.youtube.com/watch?v=PaFPbb66DxQ")
                        ],
                        documents: [
                            DocResource(lessonId: "regression_basics", title: "Regression Guide", readTime: "7 min read", docURL: "https://www.ibm.com/topics/linear-regression")
                        ]
                    ),
                    Lesson(
                        id: "classification_models",
                        name: "Classification Models",
                        subtitle: "Logistic regression, SVMs, trees.",
                        dueDate: "Jan 15",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "classification_models", title: "Classification Models", duration: "16:00", thumbnailName: "ml4", videoURL: "https://www.youtube.com/watch?v=yIYKR4sgzI8")
                        ],
                        documents: [
                            DocResource(lessonId: "classification_models", title: "Classification Overview", readTime: "8 min read", docURL: "https://towardsdatascience.com/classification-algorithms-95f3a29e7e1")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Data Science
    Roadmap(
        title: "Data Science",
        subtitle: "Insights & Analytics",
        description: "Analyze, visualize, and interpret complex data to drive decisions.",
        imageName: "data-analytics-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Data Fundamentals",
                subtitle: "Understanding data",
                iconName: "tray.full.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                lessons: [
                    Lesson(
                        id: "data_types",
                        name: "Types of Data",
                        subtitle: "Numerical and categorical data.",
                        dueDate: "Jan 4",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "data_types", title: "Types of Data", duration: "10:00", thumbnailName: "ds1", videoURL: "https://www.youtube.com/watch?v=7bsNWqBAyk8")
                        ],
                        documents: [
                            DocResource(lessonId: "data_types", title: "Data Types Guide", readTime: "6 min read", docURL: "https://statistics.laerd.com/statistical-guides/types-of-variable.php")
                        ]
                    ),
                    Lesson(
                        id: "data_collection",
                        name: "Data Collection",
                        subtitle: "APIs, surveys, scraping.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "data_collection", title: "Collecting Data", duration: "12:30", thumbnailName: "ds2", videoURL: "https://www.youtube.com/watch?v=ov7vS0X2_50")
                        ],
                        documents: [
                            DocResource(lessonId: "data_collection", title: "Data Collection Methods", readTime: "7 min read", docURL: "https://www.questionpro.com/blog/sampling-methods/")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "Analytics Tools",
                subtitle: "SQL & Python",
                iconName: "hammer.fill",
                iconColor: UIColor(hex: "#D4A056"),
                iconBackgroundColor: UIColor(hex: "#FAF3E7"),
                lessons: [
                    Lesson(
                        id: "sql_queries",
                        name: "SQL Queries",
                        subtitle: "Filtering, joins, aggregation.",
                        dueDate: "Jan 10",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "sql_queries", title: "SQL Joins", duration: "16:00", thumbnailName: "ds3", videoURL: "https://www.youtube.com/watch?v=9yeOJ0ZMUYw")
                        ],
                        documents: [
                            DocResource(lessonId: "sql_queries", title: "SQL Handbook", readTime: "8 min read", docURL: "https://mode.com/sql-tutorial/")
                        ]
                    ),
                    Lesson(
                        id: "pandas_mastery",
                        name: "Pandas Mastery",
                        subtitle: "Data manipulation in Python.",
                        dueDate: "Jan 12",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "pandas_mastery", title: "Pandas Basics", duration: "14:00", thumbnailName: "ds4", videoURL: "https://www.youtube.com/watch?v=vmEHCJofslg")
                        ],
                        documents: [
                            DocResource(lessonId: "pandas_mastery", title: "Pandas Documentation", readTime: "10 min read", docURL: "https://pandas.pydata.org/docs/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Data Engineering
    Roadmap(
        title: "Data Engineering",
        subtitle: "Scalable Data Systems",
        description: "Build robust pipelines and infrastructure for large-scale data.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Data Storage",
                subtitle: "Databases & formats",
                iconName: "server.rack",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "de_data_models",
                        name: "Data Modeling",
                        subtitle: "OLTP vs OLAP.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "de_data_models", title: "Data Modeling", duration: "14:00", thumbnailName: "de1", videoURL: "https://www.youtube.com/watch?v=7PrU5d2zXoY")
                        ],
                        documents: [
                            DocResource(lessonId: "de_data_models", title: "Data Modeling Guide", readTime: "7 min read", docURL: "https://www.ibm.com/topics/data-modeling")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "Pipelines",
                subtitle: "ETL & orchestration",
                iconName: "arrow.triangle.branch",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#EAFBEA"),
                lessons: [
                    Lesson(
                        id: "data_pipelines",
                        name: "ETL Pipelines",
                        subtitle: "Batch and streaming pipelines.",
                        dueDate: "Jan 12",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "data_pipelines", title: "ETL Explained", duration: "13:00", thumbnailName: "de2", videoURL: "https://www.youtube.com/watch?v=0yF7oA7R5xE")
                        ],
                        documents: [
                            DocResource(lessonId: "data_pipelines", title: "ETL vs ELT", readTime: "6 min read", docURL: "https://www.integrate.io/blog/etl-vs-elt/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - DevOps Cloud
    Roadmap(
        title: "DevOps Cloud",
        subtitle: "Automation & Infrastructure",
        description: "Deploy, scale, and monitor applications in the cloud.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "DevOps Basics",
                subtitle: "CI/CD & containers",
                iconName: "gearshape.2.fill",
                iconColor: UIColor(hex: "#FF9F0A"),
                iconBackgroundColor: UIColor(hex: "#FFF3E0"),
                lessons: [
                    Lesson(
                        id: "devops_ci_cd",
                        name: "CI CD Pipelines",
                        subtitle: "Automated build and deploy.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "devops_ci_cd", title: "CI CD Explained", duration: "13:00", thumbnailName: "do1", videoURL: "https://www.youtube.com/watch?v=scEDHsr3APg")
                        ],
                        documents: [
                            DocResource(lessonId: "devops_ci_cd", title: "CI CD Basics", readTime: "7 min read", docURL: "https://www.redhat.com/en/topics/devops/what-is-ci-cd")
                        ]
                    ),
                    Lesson(
                        id: "devops_docker",
                        name: "Docker Fundamentals",
                        subtitle: "Containerization.",
                        dueDate: "Jan 7",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "devops_docker", title: "Docker Crash Course", duration: "15:00", thumbnailName: "do2", videoURL: "https://www.youtube.com/watch?v=gAkwW2tuIqE")
                        ],
                        documents: [
                            DocResource(lessonId: "devops_docker", title: "Docker Docs", readTime: "6 min read", docURL: "https://docs.docker.com/get-started/")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "Cloud Platforms",
                subtitle: "AWS, GCP, Azure",
                iconName: "cloud.fill",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "cloud_basics",
                        name: "Cloud Computing",
                        subtitle: "IaaS, PaaS, SaaS.",
                        dueDate: "Jan 10",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "cloud_basics", title: "Cloud Explained", duration: "11:00", thumbnailName: "do3", videoURL: "https://www.youtube.com/watch?v=36zducUX16w")
                        ],
                        documents: [
                            DocResource(lessonId: "cloud_basics", title: "Cloud Guide", readTime: "8 min read", docURL: "https://aws.amazon.com/what-is-cloud-computing/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),
    
    // MARK: - Mobile App Development
    Roadmap(
        title: "Mobile App Development",
        subtitle: "Android & iOS",
        description: "Design, build, and deploy modern mobile applications.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Mobile Foundations",
                subtitle: "Core concepts",
                iconName: "iphone",
                iconColor: UIColor(hex: "#007AFF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "mobile_app_basics",
                        name: "Mobile App Basics",
                        subtitle: "App lifecycle and UI fundamentals.",
                        dueDate: "Jan 4",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "mobile_app_basics", title: "Mobile App Development Overview", duration: "12:00", thumbnailName: "mob1", videoURL: "https://www.youtube.com/watch?v=0-S5a0eXPoc")
                        ],
                        documents: [
                            DocResource(lessonId: "mobile_app_basics", title: "Mobile App Fundamentals", readTime: "7 min read", docURL: "https://developer.android.com/guide")
                        ]
                    ),
                    Lesson(
                        id: "mobile_ui_design",
                        name: "Mobile UI Design",
                        subtitle: "Layouts and responsive design.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "mobile_ui_design", title: "Mobile UI Design Principles", duration: "10:30", thumbnailName: "mob2", videoURL: "https://www.youtube.com/watch?v=7ZfKovNAtpw")
                        ],
                        documents: [
                            DocResource(lessonId: "mobile_ui_design", title: "Mobile UI Guidelines", readTime: "6 min read", docURL: "https://developer.apple.com/design/human-interface-guidelines/")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "App Architecture",
                subtitle: "State & networking",
                iconName: "square.stack.3d.up.fill",
                iconColor: UIColor(hex: "#5856D6"),
                iconBackgroundColor: UIColor(hex: "#EFEFFD"),
                lessons: [
                    Lesson(
                        id: "mobile_state_mgmt",
                        name: "State Management",
                        subtitle: "Managing UI and data flow.",
                        dueDate: "Jan 10",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "mobile_state_mgmt", title: "State Management Explained", duration: "11:00", thumbnailName: "mob3", videoURL: "https://www.youtube.com/watch?v=F2G2FJ9ZP5Q")
                        ],
                        documents: [
                            DocResource(lessonId: "mobile_state_mgmt", title: "State Management Guide", readTime: "7 min read", docURL: "https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Web Development
    Roadmap(
        title: "Web Development",
        subtitle: "Frontend & Backend",
        description: "Build responsive, scalable, and secure web applications.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Frontend Basics",
                subtitle: "HTML, CSS, JavaScript",
                iconName: "globe",
                iconColor: UIColor(hex: "#FF3B30"),
                iconBackgroundColor: UIColor(hex: "#FEEBEA"),
                lessons: [
                    Lesson(
                        id: "html_css",
                        name: "HTML & CSS",
                        subtitle: "Structure and styling.",
                        dueDate: "Jan 3",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "html_css", title: "HTML CSS Crash Course", duration: "18:40", thumbnailName: "web1", videoURL: "https://www.youtube.com/watch?v=mU6anWqZJcc")
                        ],
                        documents: [
                            DocResource(lessonId: "html_css", title: "HTML Basics", readTime: "6 min read", docURL: "https://developer.mozilla.org/en-US/docs/Web/HTML")
                        ]
                    ),
                    Lesson(
                        id: "javascript_basics",
                        name: "JavaScript Fundamentals",
                        subtitle: "Core JS concepts.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "javascript_basics", title: "JavaScript Basics", duration: "16:00", thumbnailName: "web2", videoURL: "https://www.youtube.com/watch?v=W6NZfCO5SIk")
                        ],
                        documents: [
                            DocResource(lessonId: "javascript_basics", title: "JavaScript Guide", readTime: "7 min read", docURL: "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "Backend Basics",
                subtitle: "APIs & Databases",
                iconName: "server.rack",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#EAFBEA"),
                lessons: [
                    Lesson(
                        id: "express_js",
                        name: "Backend with Express",
                        subtitle: "REST APIs using Node.js.",
                        dueDate: "Jan 10",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "express_js", title: "Express.js Tutorial", duration: "15:00", thumbnailName: "web3", videoURL: "https://www.youtube.com/watch?v=L72fhGm1tfE")
                        ],
                        documents: [
                            DocResource(lessonId: "express_js", title: "Express Docs", readTime: "6 min read", docURL: "https://expressjs.com/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Software Development
    Roadmap(
        title: "Software Development",
        subtitle: "Core Engineering",
        description: "Learn programming, problem solving, and scalable system design.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Programming Basics",
                subtitle: "Foundations",
                iconName: "chevron.left.slash.chevron.right",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "sd_programming_basics",
                        name: "Programming Fundamentals",
                        subtitle: "Variables, loops, functions.",
                        dueDate: "Jan 3",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "sd_programming_basics", title: "Programming Basics", duration: "14:00", thumbnailName: "sd1", videoURL: "https://www.youtube.com/watch?v=zOjov-2OZ0E")
                        ],
                        documents: [
                            DocResource(lessonId: "sd_programming_basics", title: "Programming Guide", readTime: "7 min read", docURL: "https://www.geeksforgeeks.org/fundamentals-of-programming/")
                        ]
                    ),
                    Lesson(
                        id: "sd_oops",
                        name: "Object Oriented Programming",
                        subtitle: "Classes and inheritance.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "sd_oops", title: "OOP Explained", duration: "16:30", thumbnailName: "sd2", videoURL: "https://www.youtube.com/watch?v=SS-9y0H3Si8")
                        ],
                        documents: [
                            DocResource(lessonId: "sd_oops", title: "OOP Principles", readTime: "8 min read", docURL: "https://www.freecodecamp.org/news/object-oriented-programming-concepts/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - UI UX Engineering
    Roadmap(
        title: "UI UX Engineering",
        subtitle: "Design & Usability",
        description: "Design intuitive, accessible, and user-centered digital experiences.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "UX Foundations",
                subtitle: "User-centered design",
                iconName: "pencil.and.outline",
                iconColor: UIColor(hex: "#AF52DE"),
                iconBackgroundColor: UIColor(hex: "#F7EEFD"),
                lessons: [
                    Lesson(
                        id: "ux_principles",
                        name: "UX Principles",
                        subtitle: "Usability and heuristics.",
                        dueDate: "Jan 4",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ux_principles", title: "UX Design Basics", duration: "11:30", thumbnailName: "ux1", videoURL: "https://www.youtube.com/watch?v=Ovj4hFxko7c")
                        ],
                        documents: [
                            DocResource(lessonId: "ux_principles", title: "UX Principles Guide", readTime: "7 min read", docURL: "https://www.interaction-design.org/literature/topics/ux-design")
                        ]
                    ),
                    Lesson(
                        id: "ui_design",
                        name: "UI Design",
                        subtitle: "Visual hierarchy and layouts.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ui_design", title: "UI Design Principles", duration: "10:00", thumbnailName: "ux2", videoURL: "https://www.youtube.com/watch?v=7ZfKovNAtpw")
                        ],
                        documents: [
                            DocResource(lessonId: "ui_design", title: "UI Guidelines", readTime: "6 min read", docURL: "https://developer.apple.com/design/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),
    
    // MARK: - Cyber Security
    Roadmap(
        title: "Cyber Security",
        subtitle: "Defense & Offense",
        description: "Secure systems, networks, and applications against modern threats.",
        imageName: "cyber-security-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Security Fundamentals",
                subtitle: "Core principles",
                iconName: "lock.shield.fill",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "networking_basics",
                        name: "Networking Basics",
                        subtitle: "TCP/IP, OSI, DNS.",
                        dueDate: "Jan 4",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "networking_basics", title: "Networking Explained", duration: "14:00", thumbnailName: "cs1", videoURL: "https://www.youtube.com/watch?v=Dxcc6ycZ73M")
                        ],
                        documents: [
                            DocResource(lessonId: "networking_basics", title: "Networking Guide", readTime: "8 min read", docURL: "https://www.cloudflare.com/learning/network-layer/what-is-the-osi-model/")
                        ]
                    ),
                    Lesson(
                        id: "cia_triad",
                        name: "CIA Triad",
                        subtitle: "Confidentiality, Integrity, Availability.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "cia_triad", title: "CIA Triad Explained", duration: "08:30", thumbnailName: "cs2", videoURL: "https://www.youtube.com/watch?v=L5pAn6_O_vA")
                        ],
                        documents: [
                            DocResource(lessonId: "cia_triad", title: "CIA Model", readTime: "6 min read", docURL: "https://www.ibm.com/topics/cia-triad")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Blockchain Development
    Roadmap(
        title: "Blockchain Development",
        subtitle: "Web3 Systems",
        description: "Build decentralized applications and smart contracts.",
        imageName: "blockchain",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Blockchain Basics",
                subtitle: "Distributed ledgers",
                iconName: "link.circle.fill",
                iconColor: UIColor(hex: "#5856D6"),
                iconBackgroundColor: UIColor(hex: "#EFEFFD"),
                lessons: [
                    Lesson(
                        id: "intro_blockchain",
                        name: "Blockchain Fundamentals",
                        subtitle: "Blocks, hashing, decentralization.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "intro_blockchain", title: "Blockchain 101", duration: "12:00", thumbnailName: "bc1", videoURL: "https://www.youtube.com/watch?v=SSo_EIwHSd4")
                        ],
                        documents: [
                            DocResource(lessonId: "intro_blockchain", title: "Blockchain Explained", readTime: "8 min read", docURL: "https://www.ibm.com/topics/blockchain")
                        ]
                    )
                ]
            ),

            Milestone(
                title: "Smart Contracts",
                subtitle: "Ethereum & Solidity",
                iconName: "doc.text.fill",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#EAFBEA"),
                lessons: [
                    Lesson(
                        id: "solidity_basics",
                        name: "Solidity Basics",
                        subtitle: "Smart contract programming.",
                        dueDate: "Jan 10",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "solidity_basics", title: "Solidity Crash Course", duration: "20:00", thumbnailName: "bc2", videoURL: "https://www.youtube.com/watch?v=kYI8-t9K4V4")
                        ],
                        documents: [
                            DocResource(lessonId: "solidity_basics", title: "Solidity Docs", readTime: "10 min read", docURL: "https://docs.soliditylang.org/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Game Development
    Roadmap(
        title: "Game Development",
        subtitle: "Interactive Experiences",
        description: "Design and develop 2D and 3D games.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Game Foundations",
                subtitle: "Engines & mechanics",
                iconName: "gamecontroller.fill",
                iconColor: UIColor(hex: "#FF9500"),
                iconBackgroundColor: UIColor(hex: "#FFF4E6"),
                lessons: [
                    Lesson(
                        id: "game_dev_intro",
                        name: "Game Development Basics",
                        subtitle: "Game loops and engines.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "game_dev_intro", title: "Game Dev Overview", duration: "13:00", thumbnailName: "gd1", videoURL: "https://www.youtube.com/watch?v=GFO_txvwK_c")
                        ],
                        documents: [
                            DocResource(lessonId: "game_dev_intro", title: "Game Dev Basics", readTime: "7 min read", docURL: "https://gamedevelopment.tutsplus.com/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - AR VR Development
    Roadmap(
        title: "AR VR Development",
        subtitle: "Immersive Tech",
        description: "Build augmented and virtual reality experiences.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "AR VR Basics",
                subtitle: "Immersive fundamentals",
                iconName: "viewfinder.circle.fill",
                iconColor: UIColor(hex: "#AF52DE"),
                iconBackgroundColor: UIColor(hex: "#F7EEFD"),
                lessons: [
                    Lesson(
                        id: "arvr_intro",
                        name: "AR VR Fundamentals",
                        subtitle: "Augmented vs Virtual Reality.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "arvr_intro", title: "AR VR Explained", duration: "11:00", thumbnailName: "ar1", videoURL: "https://www.youtube.com/watch?v=IzAuGa7YKeU")
                        ],
                        documents: [
                            DocResource(lessonId: "arvr_intro", title: "AR VR Guide", readTime: "6 min read", docURL: "https://www.ibm.com/topics/augmented-reality")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Systems Embedded
    Roadmap(
        title: "Systems Embedded",
        subtitle: "Hardware & Firmware",
        description: "Develop low-level systems and embedded software.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "Embedded Basics",
                subtitle: "Microcontrollers",
                iconName: "cpu.fill",
                iconColor: UIColor(hex: "#34495E"),
                iconBackgroundColor: UIColor(hex: "#EBEDEF"),
                lessons: [
                    Lesson(
                        id: "embedded_intro",
                        name: "Embedded Systems",
                        subtitle: "MCUs, sensors, actuators.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "embedded_intro", title: "Embedded Systems Explained", duration: "15:00", thumbnailName: "es1", videoURL: "https://www.youtube.com/watch?v=0kzWjK5m8cY")
                        ],
                        documents: [
                            DocResource(lessonId: "embedded_intro", title: "Embedded Systems Guide", readTime: "8 min read", docURL: "https://www.electronics-tutorials.ws/embedded/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    // MARK: - Product Management
    Roadmap(
        title: "Product Management",
        subtitle: "Business & Strategy",
        description: "Lead product vision from idea to launch.",
        imageName: "aiml-role",
        percentage: 0,
        milestones: [

            Milestone(
                title: "PM Foundations",
                subtitle: "Product thinking",
                iconName: "briefcase.fill",
                iconColor: UIColor(hex: "#FF3B30"),
                iconBackgroundColor: UIColor(hex: "#FEEBEA"),
                lessons: [
                    Lesson(
                        id: "pm_intro",
                        name: "Product Management Basics",
                        subtitle: "Roadmaps, stakeholders, metrics.",
                        dueDate: "Jan 4",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "pm_intro", title: "What is Product Management?", duration: "12:30", thumbnailName: "pm1", videoURL: "https://www.youtube.com/watch?v=yUOC-Y0f5ZQ")
                        ],
                        documents: [
                            DocResource(lessonId: "pm_intro", title: "PM Guide", readTime: "7 min read", docURL: "https://www.atlassian.com/agile/product-management")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),
]
