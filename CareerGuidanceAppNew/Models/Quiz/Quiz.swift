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

        case "data_types":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which data type would be most appropriate for 'Customer Names'?", options: ["Integer", "Float", "String", "Boolean"], correctIndex: 2),
                        QuizQuestion(question: "What type of data is 'Temperature' recorded over a day?", options: ["Discrete", "Continuous", "Categorical", "Binary"], correctIndex: 1),
                        QuizQuestion(question: "A column with values 'High', 'Medium', 'Low' is an example of:", options: ["Ordinal Data", "Nominal Data", "Ratio Data", "Interval Data"], correctIndex: 0)
                    ]
                )

            case "data_collection":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which of these is a primary data collection method?", options: ["Reading a research paper", "Downloading a public dataset", "Conducting a user survey", "Analyzing census reports"], correctIndex: 2),
                        QuizQuestion(question: "What is 'Web Scraping' used for?", options: ["Cleaning local databases", "Extracting data from websites", "Designing UI layouts", "Hosting a server"], correctIndex: 1),
                        QuizQuestion(question: "Which protocol is standard for fetching data from an API?", options: ["FTP", "SMTP", "HTTP/HTTPS", "SSH"], correctIndex: 2)
                    ]
                )

            case "excel_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which feature allows you to summarize large amounts of data quickly?", options: ["VLOOKUP", "Pivot Tables", "Conditional Formatting", "Data Validation"], correctIndex: 1),
                        QuizQuestion(question: "How do you lock a cell reference (Absolute Reference) in a formula?", options: ["Use # symbols", "Use @ symbols", "Use $ symbols", "Use ! symbols"], correctIndex: 2),
                        QuizQuestion(question: "What does VLOOKUP stand for?", options: ["Value Lookup", "Variable Lookup", "Vertical Lookup", "Virtual Lookup"], correctIndex: 2)
                    ]
                )

            case "sql_queries":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which command is used to remove duplicate rows from a result?", options: ["UNIQUE", "DISTINCT", "ONLY", "SINGLE"], correctIndex: 1),
                        QuizQuestion(question: "Which JOIN returns all rows from the left table even if there are no matches in the right?", options: ["INNER JOIN", "FULL JOIN", "LEFT JOIN", "RIGHT JOIN"], correctIndex: 2),
                        QuizQuestion(question: "What is the correct order of clauses in a SQL statement?", options: ["SELECT, WHERE, FROM", "SELECT, FROM, WHERE", "FROM, SELECT, WHERE", "WHERE, FROM, SELECT"], correctIndex: 1)
                    ]
                )

            case "viz_principles":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which chart is best for showing parts of a whole?", options: ["Line Chart", "Scatter Plot", "Pie Chart", "Histogram"], correctIndex: 2),
                        QuizQuestion(question: "What is the primary purpose of using 'Contrast' in visualization?", options: ["To use more colors", "To highlight key insights", "To make it look artistic", "To fill white space"], correctIndex: 1),
                        QuizQuestion(question: "Which chart is best for showing trends over time?", options: ["Bar Chart", "Line Chart", "Heat Map", "Box Plot"], correctIndex: 1)
                    ]
                )

            case "tableau_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "In Tableau, what are 'Dimensions'?", options: ["Numerical data", "Qualitative or categorical data", "Aggregated sums", "Coordinate points"], correctIndex: 1),
                        QuizQuestion(question: "What color represents 'Measures' in the Tableau interface?", options: ["Blue", "Green", "Red", "Orange"], correctIndex: 1),
                        QuizQuestion(question: "Which feature combines multiple worksheets into a single interactive view?", options: ["Story", "Dashboard", "Workbook", "Project"], correctIndex: 1)
                    ]
                )

            case "descriptive_stats":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which measure is most affected by extreme outliers?", options: ["Median", "Mode", "Mean", "Interquartile Range"], correctIndex: 2),
                        QuizQuestion(question: "What does 'Standard Deviation' represent?", options: ["The average value", "The middle value", "The spread of data around the mean", "The frequency of values"], correctIndex: 2),
                        QuizQuestion(question: "In a 'Normal Distribution', what percentage falls within 1 standard deviation?", options: ["50%", "68%", "95%", "99%"], correctIndex: 1)
                    ]
                )

            case "hypothesis_testing":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is a 'Null Hypothesis' (H0)?", options: ["The effect we hope to prove", "The assumption of no effect", "An error in data", "The final result"], correctIndex: 1),
                        QuizQuestion(question: "A p-value less than 0.05 generally means:", options: ["Result is not significant", "Fail to reject Null Hypothesis", "Result is statistically significant", "Data is missing"], correctIndex: 2),
                        QuizQuestion(question: "What is a 'Type I Error'?", options: ["False Positive", "False Negative", "Missing Data", "Calculation Error"], correctIndex: 0)
                    ]
                )

            case "pandas_mastery":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which function is used to load a CSV file in Pandas?", options: ["pd.open_csv()", "pd.load_csv()", "pd.read_csv()", "pd.get_csv()"], correctIndex: 2),
                        QuizQuestion(question: "What is a 1-dimensional array in Pandas called?", options: ["DataFrame", "Matrix", "Series", "Panel"], correctIndex: 2),
                        QuizQuestion(question: "Which method returns the first 5 rows of a DataFrame?", options: ["df.first()", "df.top()", "df.head()", "df.show()"], correctIndex: 2)
                    ]
                )

            case "exploratory_analysis":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the main goal of EDA?", options: ["Building a final model", "Cleaning the server", "Summarizing main characteristics of data", "Deploying an API"], correctIndex: 2),
                        QuizQuestion(question: "Which plot is commonly used to check for correlation?", options: ["Pie Chart", "Histogram", "Scatter Plot", "Bar Chart"], correctIndex: 2),
                        QuizQuestion(question: "Which Pandas method provides a statistical summary (mean, std, etc.)?", options: ["df.summary()", "df.describe()", "df.info()", "df.stats()"], correctIndex: 1)
                    ]
                )

            case "regression_models":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "In Y = mX + c, what does 'm' represent?", options: ["Intercept", "Error", "Slope", "Dependent Variable"], correctIndex: 2),
                        QuizQuestion(question: "Which metric is commonly used to evaluate regression models?", options: ["Accuracy", "F1-Score", "R-Squared", "Precision"], correctIndex: 2),
                        QuizQuestion(question: "What happens in 'Overfitting'?", options: ["Model is too simple", "Model learns noise as patterns", "Data is too small", "Model cannot predict at all"], correctIndex: 1)
                    ]
                )

            case "google_bigquery":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "BigQuery is primarily a:", options: ["NoSQL Database", "Data Warehouse", "Web Server", "Text Editor"], correctIndex: 1),
                        QuizQuestion(question: "Which architecture does BigQuery use to process data?", options: ["Row-based", "Collocation", "Columnar Storage", "Peer-to-Peer"], correctIndex: 2),
                        QuizQuestion(question: "Does BigQuery require users to manage infrastructure (servers)?", options: ["Yes", "No", "Only for large datasets", "Depends on the region"], correctIndex: 1)
                    ]
                )

            case "data_pipelines":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What does ETL stand for?", options: ["Encrypt, Transfer, Load", "Extract, Transform, Load", "Enter, Test, List", "Execute, Track, Log"], correctIndex: 1),
                        QuizQuestion(question: "What is the main goal of a data pipeline?", options: ["Data Encryption", "Moving data from source to destination", "Visualizing charts", "Writing code comments"], correctIndex: 1),
                        QuizQuestion(question: "Which tool is popular for orchestrating data pipelines?", options: ["Apache Airflow", "VS Code", "Excel", "Postman"], correctIndex: 0)
                    ]
                )

            case "portfolio_project":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the most important part of a data portfolio project?", options: ["Using the most complex math", "Explaining the 'Why' and 'So What'", "Having 1000 lines of code", "Using every possible tool"], correctIndex: 1),
                        QuizQuestion(question: "Where is the best place to host your project code?", options: ["Desktop folder", "GitHub", "Email drafts", "USB Drive"], correctIndex: 1),
                        QuizQuestion(question: "A good README should include:", options: ["Only the code", "Problem statement and insights", "Your social security number", "A list of your favorite foods"], correctIndex: 1)
                    ]
                )

            case "interview_prep":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "How should you explain a technical concept to a non-technical manager?", options: ["Use heavy jargon", "Use analogies and focus on business value", "Refuse to explain", "Read the code aloud"], correctIndex: 1),
                        QuizQuestion(question: "What is the 'STAR' method used for?", options: ["Database joining", "Answering behavioral questions", "Sorting arrays", "Data cleaning"], correctIndex: 1),
                        QuizQuestion(question: "If asked about a time you failed, you should:", options: ["Blame a teammate", "Say you never fail", "Discuss what you learned from the experience", "Ignore the question"], correctIndex: 2)
                    ]
                )
            // MARK: - AI & Machine Learning Quizzes

            case "ml_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the primary difference between Supervised and Unsupervised learning?", options: ["Supervised uses labeled data; Unsupervised uses unlabeled data", "Supervised is for robots; Unsupervised is for humans", "Supervised is faster; Unsupervised is more accurate", "There is no difference"], correctIndex: 0),
                        QuizQuestion(question: "Which of the following is an example of a Classification task?", options: ["Predicting the price of a house", "Grouping customers by shopping habits", "Identifying if an email is 'Spam' or 'Not Spam'", "Generating a new image of a cat"], correctIndex: 2),
                        QuizQuestion(question: "What does the term 'Inference' refer to in Machine Learning?", options: ["Training a model with data", "The process of a model making predictions on new data", "Deleting old data from a server", "Debugging code"], correctIndex: 1)
                    ]
                )

            case "ml_math":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "In Linear Algebra, what is a 'Tensor'?", options: ["A single number", "A 1D array", "A 2D matrix", "A multi-dimensional array of numbers"], correctIndex: 3),
                        QuizQuestion(question: "What is the purpose of 'Gradient Descent' in ML?", options: ["To increase the error rate", "To minimize the loss function and optimize parameters", "To sort data alphabetically", "To visualize 3D models"], correctIndex: 1),
                        QuizQuestion(question: "Which mathematical concept is used to measure the relationship between two variables?", options: ["Calculus", "Probability", "Correlation/Covariance", "Geometry"], correctIndex: 2)
                    ]
                )

            case "regression_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "In Linear Regression, what does the 'R-squared' value represent?", options: ["The speed of the model", "The proportion of variance explained by the model", "The number of rows in data", "The square root of the error"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Overfitting' in a regression model?", options: ["When the model is too simple for the data", "When the model is perfectly accurate on all data", "When the model learns noise instead of the actual pattern", "When the model runs out of memory"], correctIndex: 2),
                        QuizQuestion(question: "Which of these is used to predict continuous numerical values?", options: ["Logistic Regression", "K-Means Clustering", "Linear Regression", "Decision Trees"], correctIndex: 2)
                    ]
                )

            case "classification_models":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which algorithm is commonly used for binary classification despite its name?", options: ["Linear Regression", "Logistic Regression", "K-Means", "Principal Component Analysis"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Confusion Matrix' used for?", options: ["To confuse the developer", "To evaluate the performance of a classification model", "To store training data", "To generate random numbers"], correctIndex: 1),
                        QuizQuestion(question: "Which model uses a 'Support Vector' to maximize the margin between classes?", options: ["Random Forest", "Naive Bayes", "SVM (Support Vector Machine)", "Neural Networks"], correctIndex: 2)
                    ]
                )

            case "random_forests":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Ensemble Learning'?", options: ["Using a single large model", "Combining multiple models to improve performance", "Learning in a group session", "Visualizing model layers"], correctIndex: 1),
                        QuizQuestion(question: "In a Random Forest, what does 'Bagging' stand for?", options: ["Binary Aggregation", "Bootstrap Aggregating", "Base Grouping", "Balanced Algorithm"], correctIndex: 1),
                        QuizQuestion(question: "Why is XGBoost often preferred over standard Decision Trees?", options: ["It is easier to draw", "It uses gradient boosting to reduce errors and prevents overfitting", "It only works on small data", "It does not require math"], correctIndex: 1)
                    ]
                )

            case "hyperparameter_tuning":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the difference between a parameter and a hyperparameter?", options: ["Parameters are learned from data; Hyperparameters are set manually", "Parameters are set manually; Hyperparameters are learned", "They are the same thing", "Parameters are for Python; Hyperparameters are for Java"], correctIndex: 0),
                        QuizQuestion(question: "Which method tries every possible combination of hyperparameters in a specified range?", options: ["Random Search", "Grid Search", "Bayesian Optimization", "Manual Search"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Cross-Validation' used for?", options: ["To delete bad data", "To ensure the model generalizes well to unseen data", "To double the training time", "To encrypt the model"], correctIndex: 1)
                    ]
                )

            case "neural_net_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the role of an 'Activation Function' like ReLU?", options: ["To shut down the computer", "To introduce non-linearity into the network", "To store the input data", "To multiply the final score"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Backpropagation'?", options: ["Moving data to the input layer", "Adjusting weights based on the error of the output", "Deleting the hidden layers", "Printing the results"], correctIndex: 1),
                        QuizQuestion(question: "Which layer in a Neural Network is responsible for extracting features?", options: ["The Input Layer", "The Output Layer", "The Hidden Layer(s)", "The Data Layer"], correctIndex: 2)
                    ]
                )

            case "pytorch_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the basic building block of data in PyTorch?", options: ["Array", "List", "Tensor", "Matrix"], correctIndex: 2),
                        QuizQuestion(question: "Which PyTorch component is responsible for automatic differentiation?", options: ["nn.Module", "torch.optim", "Autograd", "DataLoader"], correctIndex: 2),
                        QuizQuestion(question: "In PyTorch, what does 'model.train()' do?", options: ["Starts the training process", "Sets the model to training mode (affects Dropout/BatchNorm)", "Loads the dataset", "Saves the weights to disk"], correctIndex: 1)
                    ]
                )

            case "cnn_vision":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What does the 'Convolutional' layer primarily do in a CNN?", options: ["Flattens the image", "Detects features like edges and textures using filters", "Classifies the final object", "Changes the image color"], correctIndex: 1),
                        QuizQuestion(question: "What is the purpose of a 'Pooling' layer?", options: ["To add more pixels", "To reduce the spatial dimensions of the data", "To increase training time", "To make the image brighter"], correctIndex: 1),
                        QuizQuestion(question: "Which task is best suited for a CNN?", options: ["Predicting stock prices", "Image recognition/Classification", "Translating text", "Sorting a list"], correctIndex: 1)
                    ]
                )

            case "transformers_nlp":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the key mechanism that allows Transformers to focus on specific words in a sentence?", options: ["Recursion", "Attention Mechanism", "Convolution", "Tokenization"], correctIndex: 1),
                        QuizQuestion(question: "Unlike RNNs, Transformers process text:", options: ["One word at a time", "In parallel (all at once)", "Backwards", "Only in uppercase"], correctIndex: 1),
                        QuizQuestion(question: "Which famous model architecture is based on Transformers?", options: ["AlexNet", "ResNet", "BERT / GPT", "VGG"], correctIndex: 2)
                    ]
                )

            case "llm_finetuning":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Fine-tuning' a Large Language Model?", options: ["Creating a model from scratch", "Taking a pre-trained model and training it further on a specific dataset", "Deleting the model's vocabulary", "Changing the font of the output"], correctIndex: 1),
                        QuizQuestion(question: "What does the 'T' in GPT stand for?", options: ["Text", "Training", "Transformer", "Tensor"], correctIndex: 2),
                        QuizQuestion(question: "Which technique is used to reduce the memory required for fine-tuning LLMs?", options: ["Quantization (QLoRA/LoRA)", "Encryption", "Binary Search", "Manual Weight Adjustment"], correctIndex: 0)
                    ]
                )

            case "prompt_engineering":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Few-shot prompting'?", options: ["Asking a question once", "Providing a few examples in the prompt to guide the model", "Prompting the model very quickly", "Using short words"], correctIndex: 1),
                        QuizQuestion(question: "What is the 'System Message' in a chat API used for?", options: ["Sending an error report", "Setting the behavior or persona of the AI", "Starting the computer", "Displaying the time"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Chain of Thought' prompting?", options: ["Connecting different AI models", "Asking the model to explain its reasoning step-by-step", "A list of prompts", "A faster way to generate text"], correctIndex: 1)
                    ]
                )

            case "model_deployment":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is an 'API Endpoint' in the context of model serving?", options: ["The end of the code", "A URL that accepts input data and returns model predictions", "A specific database row", "The model's training loop"], correctIndex: 1),
                        QuizQuestion(question: "Why is 'Docker' useful for ML deployment?", options: ["It draws charts", "It packages the model and dependencies into a consistent container", "It makes the model smarter", "It is a social network for developers"], correctIndex: 1),
                        QuizQuestion(question: "Which of these is a Python framework commonly used to build ML APIs?", options: ["Flask / FastAPI", "Pandas", "Matplotlib", "Seaborn"], correctIndex: 0)
                    ]
                )

            case "monitoring_drift":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Data Drift'?", options: ["Deleting data by accident", "When the statistical properties of input data change over time", "Moving data to the cloud", "Correcting data errors"], correctIndex: 1),
                        QuizQuestion(question: "What happens when a model's performance decreases in production?", options: ["Model Decay", "Model Growth", "System Update", "Perfect Accuracy"], correctIndex: 0),
                        QuizQuestion(question: "How do you fix a model that has suffered from significant drift?", options: ["Re-train it on the new, updated data", "Restart the server", "Use a different color scheme", "Wait for it to fix itself"], correctIndex: 0)
                    ]
                )
            // MARK: - App Development Quizzes

            case "ui_design":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which UI principle ensures that important elements stand out from the background?", options: ["Alignment", "Contrast", "Proximity", "Repetition"], correctIndex: 1),
                        QuizQuestion(question: "What is the primary purpose of 'White Space' in a layout?", options: ["To save on ink", "To make the app look empty", "To reduce cognitive load and improve readability", "To fill up unused space"], correctIndex: 2),
                        QuizQuestion(question: "In Apple's Human Interface Guidelines, what is the minimum recommended touch target size?", options: ["22x22 points", "32x32 points", "44x44 points", "64x64 points"], correctIndex: 2)
                    ]
                )

            case "swiftui_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which protocol must a SwiftUI view conform to?", options: ["UIView", "View", "ObservableObject", "Scene"], correctIndex: 1),
                        QuizQuestion(question: "How do you stack elements horizontally in SwiftUI?", options: ["VStack", "ZStack", "HStack", "StackView"], correctIndex: 2),
                        QuizQuestion(question: "Which property wrapper is used for simple, local state management within a single view?", options: ["@Binding", "@Published", "@State", "@ObservedObject"], correctIndex: 2)
                    ]
                )

            case "state_management":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the purpose of '@Binding' in SwiftUI?", options: ["To create a new source of truth", "To create a two-way connection to a state owned by another view", "To save data to the disk", "To hide a view"], correctIndex: 1),
                        QuizQuestion(question: "Which property wrapper should be used for data that is shared across the entire app hierarchy?", options: ["@State", "@EnvironmentObject", "@Published", "@Binding"], correctIndex: 1),
                        QuizQuestion(question: "An object must conform to which protocol to be used as an '@ObservedObject'?", options: ["Identifiable", "Codable", "ObservableObject", "Hashable"], correctIndex: 2)
                    ]
                )

            case "json_parsing":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which Swift protocol allows a type to be converted from a JSON representation?", options: ["Encodable", "Decodable", "Stringy", "JSONConvertible"], correctIndex: 1),
                        QuizQuestion(question: "What is the primary class used to perform network requests in iOS?", options: ["NetworkSession", "HTTPManager", "URLSession", "DataFetcher"], correctIndex: 2),
                        QuizQuestion(question: "Which object is used to actually convert JSON data into Swift structs?", options: ["JSONEncoder", "JSONDecoder", "DataConverter", "StringDecoder"], correctIndex: 1)
                    ]
                )

            case "async_await":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What does the 'await' keyword signify in Swift?", options: ["It stops the app forever", "It yields the thread while waiting for a task to complete", "It makes the code run faster", "It creates a background thread"], correctIndex: 1),
                        QuizQuestion(question: "Which keyword must be added to a function signature to allow it to run asynchronous code?", options: ["sync", "async", "await", "defer"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Task' in Swift concurrency?", options: ["A unit of asynchronous work", "A scheduled reminder", "A database row", "A UI element"], correctIndex: 0)
                    ]
                )

            case "express_js":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the primary role of Express.js?", options: ["To design databases", "To act as a web application framework for Node.js", "To compile Swift code", "To manage mobile notifications"], correctIndex: 1),
                        QuizQuestion(question: "Which HTTP method is typically used to 'Create' data in a REST API?", options: ["GET", "POST", "PUT", "DELETE"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Middleware' in Express?", options: ["Hardware between servers", "Functions that have access to request and response objects", "The CSS of the backend", "A database driver"], correctIndex: 1)
                    ]
                )

            case "sql_db":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What does the 'Relational' in Relational Database mean?", options: ["Data is related to the user", "Data is organized into tables with predefined relationships", "The database is shared with relatives", "It uses only NoSQL"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Primary Key'?", options: ["The first password used", "A unique identifier for each record in a table", "The most important table", "A key to the server room"], correctIndex: 1),
                        QuizQuestion(question: "Which SQL command is used to retrieve data from a table?", options: ["FETCH", "GET", "SELECT", "EXTRACT"], correctIndex: 2)
                    ]
                )

            case "swift_data":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which macro is used to identify a class as a SwiftData model?", options: ["@Model", "@Persist", "@Entity", "@Table"], correctIndex: 0),
                        QuizQuestion(question: "In SwiftData, what is the 'ModelContext' responsible for?", options: ["Defining UI colors", "Tracking changes and managing data objects in memory", "Performing network calls", "Animating transitions"], correctIndex: 1),
                        QuizQuestion(question: "SwiftData is primarily built on top of which legacy framework?", options: ["Realm", "SQLite", "Core Data", "Firebase"], correctIndex: 2)
                    ]
                )

            case "user_auth":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the benefit of using OAuth/Social Auth (like Google or Apple)?", options: ["It's harder to code", "Users don't have to create a new password for your app", "It gives you access to their bank accounts", "It makes the app run in the background"], correctIndex: 1),
                        QuizQuestion(question: "Which of these is a secure way to store a user's token on iOS?", options: ["UserDefaults", "The Keychain", "A text file", "Hardcoded in a String"], correctIndex: 1),
                        QuizQuestion(question: "What does 'Authentication' verify?", options: ["What you are allowed to do", "Who you are", "The speed of your internet", "If the server is awake"], correctIndex: 1)
                    ]
                )

            case "mvvm_pattern":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What are the three components of MVVM?", options: ["Mode, View, VariableManager", "Model, View, ViewModel", "Mobile, View, Version", "Main, View, Valve"], correctIndex: 1),
                        QuizQuestion(question: "What is the primary responsibility of the ViewModel?", options: ["Drawing pixels", "Holding business logic and preparing data for the View", "Managing the database directly", "Handling network hardware"], correctIndex: 1),
                        QuizQuestion(question: "In MVVM, should the Model know about the View?", options: ["Yes, always", "Only for animations", "No, the Model should be independent", "Only if it's an iOS app"], correctIndex: 2)
                    ]
                )

            case "unit_testing":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is a 'Unit Test'?", options: ["Testing the entire app at once", "Testing a small, isolated piece of logic", "Testing the physical iPhone hardware", "Testing the app store description"], correctIndex: 1),
                        QuizQuestion(question: "Which framework is provided by Apple for writing tests?", options: ["SwiftTest", "XCTest", "LogicTest", "AppleVerify"], correctIndex: 1),
                        QuizQuestion(question: "What does 'Test Coverage' refer to?", options: ["How much of your code is exercised by tests", "The price of your developer license", "The signal strength of the device", "The size of the test file"], correctIndex: 0)
                    ]
                )

            case "app_store_connect":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Metadata' in the context of the App Store?", options: ["Hidden code", "App title, description, keywords, and category", "User credit card info", "The binary file size"], correctIndex: 1),
                        QuizQuestion(question: "Which document is required to explain how you handle user data?", options: ["User Manual", "Privacy Policy", "Terms of Service", "Bank Statement"], correctIndex: 1),
                        QuizQuestion(question: "What is the purpose of 'Keywords' in App Store optimization?", options: ["To make the code run faster", "To help users find your app when they search", "To secure the app from hackers", "To define variables"], correctIndex: 1)
                    ]
                )

            case "testflight":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is TestFlight used for?", options: ["Flying drones", "Distributing beta versions of your app to testers", "Compressing images", "Buying apps"], correctIndex: 1),
                        QuizQuestion(question: "How do testers receive your app via TestFlight?", options: ["In a physical mail", "Through an email invite or a public link", "They must build it from Source Code", "Via AirDrop only"], correctIndex: 1),
                        QuizQuestion(question: "What are 'Internal Testers' in TestFlight?", options: ["People outside your company", "Members of your App Store Connect team", "Random users from the internet", "Apple employees only"], correctIndex: 1)
                    ]
                )
            // MARK: - Cyber Security Quizzes

            case "networking_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which layer of the OSI model is responsible for IP addressing and routing?", options: ["Data Link Layer", "Transport Layer", "Network Layer", "Session Layer"], correctIndex: 2),
                        QuizQuestion(question: "What is the main difference between TCP and UDP?", options: ["TCP is faster", "TCP is connection-oriented and reliable, while UDP is connectionless", "UDP is more secure", "There is no difference"], correctIndex: 1),
                        QuizQuestion(question: "What does DHCP stand for in networking?", options: ["Data Hosting Control Protocol", "Dynamic Host Configuration Protocol", "Direct Hyperlink Connection Process", "Digital Hardware Communication Protocol"], correctIndex: 1)
                    ]
                )

            case "cia_triad":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Using encryption to ensure only authorized users can read a message is an example of:", options: ["Availability", "Integrity", "Confidentiality", "Authentication"], correctIndex: 2),
                        QuizQuestion(question: "Which principle is violated if a hacker changes the balance in your bank account?", options: ["Confidentiality", "Integrity", "Availability", "Non-repudiation"], correctIndex: 1),
                        QuizQuestion(question: "A Denial of Service (DoS) attack primarily targets which part of the CIA triad?", options: ["Confidentiality", "Integrity", "Availability", "Authorization"], correctIndex: 2)
                    ]
                )

            case "crypto_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the main characteristic of Asymmetric Encryption?", options: ["It uses the same key for encryption and decryption", "It uses a Public Key for encryption and a Private Key for decryption", "It is faster than Symmetric encryption", "It doesn't require keys"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Hash Function' primarily used for?", options: ["Encrypting large files", "Ensuring data integrity", "Connecting to a VPN", "Storing passwords in plain text"], correctIndex: 1),
                        QuizQuestion(question: "Which of the following is a common hashing algorithm?", options: ["AES-256", "RSA", "SHA-256", "Diffie-Hellman"], correctIndex: 2)
                    ]
                )

            case "linux_security":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which Linux command is used to change file permissions?", options: ["chown", "ls -la", "chmod", "sudo"], correctIndex: 2),
                        QuizQuestion(question: "In the permission string '-rwxr-xr--', what does the 'x' signify?", options: ["Read access", "Write access", "Execute access", "Hidden file"], correctIndex: 2),
                        QuizQuestion(question: "What is the primary purpose of 'SSH' (Secure Shell)?", options: ["To browse the web", "To securely access a remote computer's terminal", "To install software", "To compile code"], correctIndex: 1)
                    ]
                )

            case "windows_sec":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What Windows feature allows administrators to manage users and computers in a network?", options: ["Task Manager", "Active Directory", "File Explorer", "Windows Defender"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Group Policy' (GPO) used for?", options: ["Sending emails to groups", "Defining security and operational settings for users/computers", "Chatting with coworkers", "Backing up the hard drive"], correctIndex: 1),
                        QuizQuestion(question: "What is the 'Principle of Least Privilege'?", options: ["Giving users full admin access", "Providing users only the minimum access necessary to perform their jobs", "Restricting internet access", "Using weak passwords"], correctIndex: 1)
                    ]
                )

            case "malware_types":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which type of malware encrypts your files and demands payment for the decryption key?", options: ["Spyware", "Adware", "Ransomware", "Trojan"], correctIndex: 2),
                        QuizQuestion(question: "How does a 'Worm' differ from a 'Virus'?", options: ["A worm requires human action to spread", "A worm can self-replicate and spread across networks without human interaction", "A worm is harmless", "A virus only affects Macs"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Trojan Horse' in cybersecurity?", options: ["A hardware device", "Malware disguised as legitimate software", "A strong firewall", "A secure password manager"], correctIndex: 1)
                    ]
                )

            case "vuln_assessment":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is a 'Vulnerability' in a system?", options: ["A strong firewall", "A weakness that could be exploited by a threat", "A type of antivirus", "A scheduled backup"], correctIndex: 1),
                        QuizQuestion(question: "What is the primary goal of a Vulnerability Scan?", options: ["To delete viruses", "To identify known security weaknesses in a system or network", "To speed up the network", "To install updates automatically"], correctIndex: 1),
                        QuizQuestion(question: "What does the 'CVE' acronym stand for in security research?", options: ["Common Vulnerabilities and Exposures", "Central Virus Engine", "Computer Virus Evaluation", "Critical Vulnerability Error"], correctIndex: 0)
                    ]
                )

            case "web_app_sec":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What occurs during a 'SQL Injection' attack?", options: ["The server crashes", "Malicious SQL statements are inserted into entry fields for execution", "The website font changes", "The internet disconnects"], correctIndex: 1),
                        QuizQuestion(question: "What is Cross-Site Scripting (XSS)?", options: ["Stealing a physical laptop", "Injecting malicious scripts into trusted websites", "Using a very long password", "A type of network cable"], correctIndex: 1),
                        QuizQuestion(question: "What does 'HTTPS' provide that 'HTTP' does not?", options: ["Faster loading", "Encryption and server authentication", "More images", "Better SEO only"], correctIndex: 1)
                    ]
                )

            case "metasploit_intro":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Metasploit' primarily used for?", options: ["Writing documentation", "Exploitation and penetration testing research", "Editing photos", "Hosting websites"], correctIndex: 1),
                        QuizQuestion(question: "In penetration testing, what is a 'Payload'?", options: ["The weight of the server", "The code that runs on the target system after a successful exploit", "The cost of the software", "A network packet"], correctIndex: 1),
                        QuizQuestion(question: "What is the purpose of 'Nmap'?", options: ["To draw maps", "To discover hosts and services on a computer network", "To crack passwords", "To clean the registry"], correctIndex: 1)
                    ]
                )

            case "ir_lifecycle":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the first phase of the Incident Response lifecycle?", options: ["Eradication", "Detection", "Preparation", "Containment"], correctIndex: 2),
                        QuizQuestion(question: "What is the goal of the 'Containment' phase?", options: ["To find the hacker's identity", "To limit the damage and prevent further spread of the incident", "To delete all logs", "To buy new hardware"], correctIndex: 1),
                        QuizQuestion(question: "Why is the 'Lessons Learned' phase important?", options: ["To blame people", "To improve future response capabilities and security posture", "To close the ticket", "To clear the cache"], correctIndex: 1)
                    ]
                )

            case "digital_forensics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 12, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the most important rule when collecting digital evidence?", options: ["Format the drive first", "Preserve the original evidence and work on a copy (image)", "Turn off the computer immediately", "Post it on social media"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Chain of Custody'?", options: ["A physical chain on a server", "A chronological record showing the seizure, custody, and transfer of evidence", "A type of encryption", "A list of employee passwords"], correctIndex: 1),
                        QuizQuestion(question: "Which of these is 'Volatile Data' that is lost when a computer is powered off?", options: ["Hard Drive contents", "Registry files", "RAM (Random Access Memory)", "USB drive data"], correctIndex: 2)
                    ]
                )

            case "iso_standards":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which ISO standard is the international benchmark for Information Security Management Systems (ISMS)?", options: ["ISO 9001", "ISO 14001", "ISO 27001", "ISO 45001"], correctIndex: 2),
                        QuizQuestion(question: "What is the primary focus of 'GDPR'?", options: ["Speeding up the internet", "Protecting the privacy and personal data of EU citizens", "Securing military networks", "standardizing USB ports"], correctIndex: 1),
                        QuizQuestion(question: "In compliance, what is an 'Audit'?", options: ["A software update", "A systematic evaluation of how well an organization follows security policies", "A type of malware", "A backup process"], correctIndex: 1)
                    ]
                )

            case "sec_cert_prep":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which entry-level certification is highly recommended for starting a career in Cyber Security?", options: ["CCNA", "CompTIA Security+", "PMP", "AWS Solutions Architect"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Social Engineering'?", options: ["Writing social media code", "Manipulating people into giving up confidential information", "Fixing a broken router", "Building a community"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Phishing' attack?", options: ["A sport", "Fraudulent attempts to obtain sensitive info via electronic communication", "Attacking a server with high traffic", "Cracking a local password"], correctIndex: 1)
                    ]
                )
            // MARK: - Blockchain Development Quizzes

            case "intro_blockchain":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the main purpose of a 'Distributed Ledger'?", options: ["To centralize data for faster access", "To allow multiple parties to share a synchronized record of transactions", "To store high-definition video files", "To act as a replacement for standard RAM"], correctIndex: 1),
                        QuizQuestion(question: "In a blockchain, what does an individual 'block' typically contain?", options: ["A list of transactions, a timestamp, and the hash of the previous block", "The user's social security number", "A backup of the entire internet", "Only the private keys of all users"], correctIndex: 0),
                        QuizQuestion(question: "What makes a blockchain 'Immutable'?", options: ["It is updated every second", "Changing data in one block requires changing all subsequent blocks, which is computationally infeasible", "It can be deleted by a system administrator", "It is stored in the cloud"], correctIndex: 1)
                    ]
                )

            case "consensus_mechanisms":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the primary goal of a Consensus Mechanism?", options: ["To pick the best looking block", "To ensure all nodes in a network agree on the validity of transactions", "To encrypt user passwords", "To reduce the cost of hardware"], correctIndex: 1),
                        QuizQuestion(question: "How does 'Proof of Work' (PoW) secure the network?", options: ["By requiring users to vote", "By requiring miners to solve complex mathematical puzzles", "By checking the user's bank balance", "By using a centralized server"], correctIndex: 1),
                        QuizQuestion(question: "What is a key feature of 'Proof of Stake' (PoS) compared to PoW?", options: ["It is more energy intensive", "Validators are chosen based on the number of coins they hold and are willing to 'stake'", "It is only used for private blockchains", "It doesn't use cryptography"], correctIndex: 1)
                    ]
                )

            case "bc_hashing":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is a 'Merkle Tree' used for in Blockchain?", options: ["To store user profile pictures", "To efficiently verify that a specific transaction is included in a block", "To generate random numbers", "To connect different blockchains together"], correctIndex: 1),
                        QuizQuestion(question: "Which of these is a property of a Cryptographic Hash Function?", options: ["The same input always produces a different output", "It is easy to reverse-engineer the input from the output", "A small change in input produces a significantly different output (Avalanche effect)", "It only works on numbers"], correctIndex: 2),
                        QuizQuestion(question: "Why is the 'Previous Block Hash' included in the current block?", options: ["To save storage space", "To create a link that ensures the chain's integrity", "To identify the miner's name", "To speed up the network"], correctIndex: 1)
                    ]
                )

            case "wallets_keys":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which key is used to generate your public blockchain address and should never be shared?", options: ["Public Key", "Private Key", "API Key", "License Key"], correctIndex: 1),
                        QuizQuestion(question: "What happens if you lose your Private Key and do not have a recovery seed?", options: ["You can call support to reset it", "You lose access to the funds associated with that address forever", "The blockchain automatically sends a new one", "You can use your email to recover it"], correctIndex: 1),
                        QuizQuestion(question: "In asymmetric cryptography, what is the Public Key used for?", options: ["To sign a transaction", "To encrypt data or derive a receiving address", "To access the server's backend", "To hide the transaction amount"], correctIndex: 1)
                    ]
                )

            case "solidity_basics":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 15, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is 'Solidity'?", options: ["A hardware wallet", "An object-oriented, high-level language for implementing smart contracts", "A type of consensus algorithm", "A decentralized storage provider"], correctIndex: 1),
                        QuizQuestion(question: "Which data type in Solidity is specifically designed to store Ethereum addresses?", options: ["string", "uint256", "address", "bool"], correctIndex: 2),
                        QuizQuestion(question: "What is the purpose of a 'Mapping' in Solidity?", options: ["To draw a geographic map of nodes", "To store data in key-value pairs (like a dictionary)", "To navigate the blockchain history", "To delete old data"], correctIndex: 1)
                    ]
                )

            case "evm_logic":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What does EVM stand for?", options: ["Electronic Virtual Money", "Ethereum Virtual Machine", "External Validation Module", "Encrypted Verification Method"], correctIndex: 1),
                        QuizQuestion(question: "What is 'Gas' in the context of the Ethereum network?", options: ["The speed of the internet", "The unit used to measure the computational effort required to execute operations", "A type of cryptocurrency", "The physical cooling for servers"], correctIndex: 1),
                        QuizQuestion(question: "Why is a 'Gas Limit' necessary?", options: ["To prevent infinite loops from draining all funds or stalling the network", "To make transactions more expensive", "To limit the number of users", "To encrypt the block data"], correctIndex: 0)
                    ]
                )

            case "ethers_js":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the primary role of Ethers.js or Web3.js?", options: ["To mine Bitcoin", "To allow a web frontend to interact with a blockchain node", "To design 3D models for NFTs", "To replace CSS in dApps"], correctIndex: 1),
                        QuizQuestion(question: "In Ethers.js, what is a 'Provider'?", options: ["A person who sells crypto", "A read-only abstraction of a connection to the Ethereum network", "A high-speed server", "A user's wallet"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Signer' used for in Ethers.js?", options: ["To view transaction history", "To authorize and send transactions that modify state on the blockchain", "To host the website files", "To check the gas price"], correctIndex: 1)
                    ]
                )

            case "ipfs_storage":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Why is IPFS used for many NFT projects?", options: ["It makes the images look better", "To provide decentralized, content-addressed storage instead of relying on a central server", "It's faster than Google Drive", "It automatically mines crypto"], correctIndex: 1),
                        QuizQuestion(question: "How does IPFS identify files?", options: ["By their file name", "By a Content Identifier (CID) based on the file's cryptographic hash", "By the date they were uploaded", "By the user's IP address"], correctIndex: 1),
                        QuizQuestion(question: "What does 'Content Addressing' mean?", options: ["Searching for a file by where it is stored", "Searching for a file by what is inside it (its hash)", "Using a mailing address", "Using an IP address"], correctIndex: 1)
                    ]
                )

            case "token_standards":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "Which standard is used for Fungible Tokens (like most cryptocurrencies)?", options: ["ERC-721", "ERC-20", "ERC-1155", "ERC-404"], correctIndex: 1),
                        QuizQuestion(question: "Which standard is primarily used for Non-Fungible Tokens (NFTs)?", options: ["ERC-20", "ERC-721", "ERC-101", "ERC-223"], correctIndex: 1),
                        QuizQuestion(question: "What is the main feature of the ERC-1155 standard?", options: ["It is only for Bitcoin", "It allows for both fungible and non-fungible tokens in a single contract", "It makes transactions free", "It requires no gas"], correctIndex: 1)
                    ]
                )

            case "defi_protocols":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is a 'Liquidity Pool'?", options: ["A pool of water for server cooling", "A collection of funds locked in a smart contract to facilitate trading", "A group of miners", "A backup database"], correctIndex: 1),
                        QuizQuestion(question: "In DeFi, what does 'Yield Farming' involve?", options: ["Playing games for crypto", "Staking or lending crypto assets to generate high returns or rewards", "Building physical farms", "Selling hardware"], correctIndex: 1),
                        QuizQuestion(question: "What is an 'Automated Market Maker' (AMM)?", options: ["A human trader", "A protocol that uses algorithmic bots to provide liquidity and set prices", "A central bank", "A stock exchange building"], correctIndex: 1)
                    ]
                )

            case "layer_2_solutions":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is the main problem Layer 2 solutions aim to solve?", options: ["Blockchain security", "Scalability and high transaction fees on Layer 1", "User interface design", "Internet speed"], correctIndex: 1),
                        QuizQuestion(question: "How does a 'Rollup' work?", options: ["It deletes old transactions", "It bundles multiple transactions into a single piece of data submitted to Layer 1", "It moves the blockchain to a different server", "It increases the block size to 1GB"], correctIndex: 1),
                        QuizQuestion(question: "What is a 'Zero-Knowledge' (ZK) Rollup?", options: ["A rollup that knows nothing", "A solution that uses validity proofs to prove transactions are correct without revealing the data", "A rollup with zero users", "A backup of the main chain"], correctIndex: 1)
                    ]
                )

            case "bc_interoperability":
                return Quiz(
                    lessonId: lessonId, lessonName: lessonName, durationMinutes: 10, passingPercent: 70,
                    questions: [
                        QuizQuestion(question: "What is a 'Blockchain Bridge'?", options: ["A physical cable", "A protocol that allows the transfer of assets and data between different blockchains", "A way to connect to a VPN", "A type of crypto wallet"], correctIndex: 1),
                        QuizQuestion(question: "What does 'Interoperability' mean in Web3?", options: ["The ability of different blockchains to communicate and share data", "The speed of a single chain", "The cost of gas", "The number of nodes"], correctIndex: 0),
                        QuizQuestion(question: "Which of these is a risk associated with using bridges?", options: ["Faster speeds", "Smart contract vulnerabilities or centralization of the bridge", "Too many users", "Free transactions"], correctIndex: 1)
                    ]
                )
            

        default:
            //Fallback quiz
            return Quiz(
                lessonId: lessonId,
                lessonName: lessonName,
                durationMinutes: 20,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Placeholder question?",
                        options: ["A", "B", "C", "D"],
                        correctIndex: 0
                    )
                ]
            )
        }
    }
}

var allRoadmapsData: [Roadmap] = [

    //Data Analytics
    Roadmap(
        title: "Data Analytics",
        subtitle: "Personalised Roadmap",
        description: "Learn to collect, clean, and visualize complex datasets for actionable insights.",
        imageName: "data-analytics-role",
        percentage: 90,
        milestones: [
            Milestone(
                title: "Data Fundamentals",
                subtitle: "Understand and prepare data",
                iconName: "tray.full.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                lessons: [
                    Lesson(
                        id: "data_types",
                        name: "Data Cleaning Basics",
                        subtitle: "Categorize quantitative and qualitative data.",
                        dueDate: "Dec 18",
                        status: .seeResults,
                        videos: [
                            VideoResource(lessonId: "data_types", title: "Quantitative vs Qualitative", duration: "10:20", thumbnailName: "vid_thumb_1", videoURL: "https://www.youtube.com/watch?v=7bsNWqBAyk8")
                        ],
                        documents: [
                            DocResource(lessonId: "data_types", title: "Data Classification Guide", readTime: "5 min read", docURL: "https://en.wikipedia.org/wiki/Statistical_data_type")
                        ]
                    ),
                    Lesson(
                        id: "data_collection",
                        name: "Data Collection Methods",
                        subtitle: "Surveys, APIs, and web scraping basics.",
                        dueDate: "Dec 18",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "data_collection", title: "Introduction to APIs", duration: "15:45", thumbnailName: "vid_thumb_2", videoURL: "https://www.youtube.com/watch?v=ov7vS0X2_50")
                        ],
                        documents: [
                            DocResource(lessonId: "data_collection", title: "Web Scraping 101", readTime: "10 min read", docURL: "https://www.scrapingbee.com/blog/web-scraping-101/")
                        ]
                    )
                ]
            ),
            Milestone(
                title: "Analytics Tools",
                subtitle: "Excel, SQL, Python",
                iconName: "hammer.fill",
                iconColor: UIColor(hex: "#D4A056"),
                iconBackgroundColor: UIColor(hex: "#FAF3E7"),
                lessons: [
                    Lesson(
                        id: "excel_basics",
                        name: "Excel Mastery",
                        subtitle: "Pivot tables and advanced lookups.",
                        dueDate: "Dec 22",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "excel_basics", title: "Advanced Excel for Data", duration: "22:10", thumbnailName: "vid_excel", videoURL: "https://www.youtube.com/watch?v=0nbkaYsR94c")
                        ]
                    ),
                    Lesson(
                        id: "sql_queries",
                        name: "SQL Queries & Joins",
                        subtitle: "Relational database querying essentials.",
                        dueDate: "Dec 22",
                        status: .startTest,
                        documents: [
                            DocResource(lessonId: "sql_queries", title: "The SQL Joins Handbook", readTime: "12 min read", docURL: "https://www.sqlshack.com/sql-join-overview-and-tutorial/")
                        ]
                    )
                ]
            ),
            // Milestone 3: Data Visualization & Storytelling
                        Milestone(
                            title: "Data Visualization",
                            subtitle: "Tell stories with data",
                            iconName: "chart.bar.xaxis",
                            iconColor: UIColor(hex: "#E67E22"),
                            iconBackgroundColor: UIColor(hex: "#FDF2E9"),
                            lessons: [
                                Lesson(
                                    id: "viz_principles",
                                    name: "Visualization Theory",
                                    subtitle: "Choosing the right chart for your data.",
                                    dueDate: "Jan 05",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "viz_principles", title: "Effective Data Viz", duration: "12:45", thumbnailName: "vid_viz", videoURL: "https://www.youtube.com/watch?v=hE709Ssh-m0")
                                    ]
                                ),
                                Lesson(
                                    id: "tableau_basics",
                                    name: "Tableau Essentials",
                                    subtitle: "Building interactive dashboards.",
                                    dueDate: "Jan 10",
                                    status: .startTest,
                                    documents: [
                                        DocResource(lessonId: "tableau_basics", title: "Tableau Starter Guide", readTime: "15 min read", docURL: "https://help.tableau.com/current/guides/get-started-tutorial/en-us/get-started-tutorial-home.htm")
                                    ]
                                )
                            ]
                        ),
                        
                        // Milestone 4: Statistical Analysis
                        Milestone(
                            title: "Statistics for Analytics",
                            subtitle: "Mathematical foundations",
                            iconName: "function",
                            iconColor: UIColor(hex: "#9B59B6"),
                            iconBackgroundColor: UIColor(hex: "#F5EEF8"),
                            lessons: [
                                Lesson(
                                    id: "descriptive_stats",
                                    name: "Probability & Distribution",
                                    subtitle: "Mean, Median, Standard Deviation, and Normal Distribution.",
                                    dueDate: "Jan 15",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "descriptive_stats", title: "Statistics Explained", duration: "18:20", thumbnailName: "vid_stats", videoURL: "https://www.youtube.com/watch?v=sxQaBpKfDRk")
                                    ]
                                ),
                                Lesson(
                                    id: "hypothesis_testing",
                                    name: "Hypothesis Testing",
                                    subtitle: "Understanding P-values and A/B testing basics.",
                                    dueDate: "Jan 20",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 5: Programming with Python for Data
                        Milestone(
                            title: "Advanced Python",
                            subtitle: "Pandas and NumPy mastery",
                            iconName: "terminal.fill",
                            iconColor: UIColor(hex: "#2ECC71"),
                            iconBackgroundColor: UIColor(hex: "#EAFAF1"),
                            lessons: [
                                Lesson(
                                    id: "pandas_mastery",
                                    name: "Pandas DataFrames",
                                    subtitle: "Manipulating complex datasets efficiently.",
                                    dueDate: "Jan 25",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "pandas_mastery", title: "Pandas in 10 Minutes", duration: "10:00", thumbnailName: "vid_pandas", videoURL: "https://www.youtube.com/watch?v=dcqPhpY761c")
                                    ]
                                ),
                                Lesson(
                                    id: "exploratory_analysis",
                                    name: "Exploratory Data Analysis",
                                    subtitle: "Using Python to uncover hidden patterns.",
                                    dueDate: "Jan 30",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 6: Machine Learning Foundations
                        Milestone(
                            title: "Predictive Analytics",
                            subtitle: "Intro to Machine Learning",
                            iconName: "brain.headset",
                            iconColor: UIColor(hex: "#3498DB"),
                            iconBackgroundColor: UIColor(hex: "#EBF5FB"),
                            lessons: [
                                Lesson(
                                    id: "regression_models",
                                    name: "Linear Regression",
                                    subtitle: "Predicting continuous outcomes.",
                                    dueDate: "Feb 05",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "classification_basics",
                                    name: "Classification Basics",
                                    subtitle: "Logic of Decision Trees and K-Nearest Neighbors.",
                                    dueDate: "Feb 10",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 7: Big Data & Cloud Analytics
                        Milestone(
                            title: "Scalable Analytics",
                            subtitle: "Big Data environments",
                            iconName: "cloud.fill",
                            iconColor: UIColor(hex: "#1ABC9C"),
                            iconBackgroundColor: UIColor(hex: "#E8F8F5"),
                            lessons: [
                                Lesson(
                                    id: "google_bigquery",
                                    name: "Google BigQuery",
                                    subtitle: "Querying petabytes of data using SQL.",
                                    dueDate: "Feb 15",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "data_pipelines",
                                    name: "ETL Pipelines",
                                    subtitle: "Automating data flow from source to warehouse.",
                                    dueDate: "Feb 20",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 8: Capstone Project & Portfolio
                        Milestone(
                            title: "Industry Capstone",
                            subtitle: "Professional portfolio building",
                            iconName: "briefcase.fill",
                            iconColor: UIColor(hex: "#34495E"),
                            iconBackgroundColor: UIColor(hex: "#EBEDEF"),
                            lessons: [
                                Lesson(
                                    id: "portfolio_project",
                                    name: "End-to-End Analysis",
                                    subtitle: "From raw data to a presented dashboard.",
                                    dueDate: "Mar 01",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "interview_prep",
                                    name: "Analytics Interview Prep",
                                    subtitle: "Case studies and technical SQL/Python tests.",
                                    dueDate: "Mar 05",
                                    status: .startTest
                                )
                            ]
                        )
        ],
        isStarted: false
    ),
    
    //AI & Machine Learning
    Roadmap(
        title: "AI & Machine Learning",
        subtitle: "Advanced Career Track",
        description: "Learn machine learning, deep learning, and AI systems.",
        imageName: "aiml-role",
        percentage: 40,
        milestones: [
            Milestone(
                title: "Python for ML",
                subtitle: "Core programming skills",
                iconName: "terminal.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                lessons: [
                    Lesson(
                        id: "ml_intro",
                        name: "Introduction to ML",
                        subtitle: "Understanding supervised vs unsupervised learning.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ml_intro", title: "The Map of Machine Learning", duration: "12:00", thumbnailName: "vid_ml_map", videoURL: "https://www.youtube.com/watch?v=HcqpanDadyQ")
                        ],
                        documents: [
                            DocResource(lessonId: "ml_intro", title: "Supervised vs Unsupervised Study", readTime: "8 min read", docURL: "https://towardsdatascience.com/supervised-vs-unsupervised-learning-140455914805")
                        ]
                    ),
                    Lesson(
                        id: "ml_math",
                        name: "Math for ML",
                        subtitle: "Linear Algebra and Calculus for optimization.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ml_math", title: "Linear Algebra Essence", duration: "25:00", thumbnailName: "vid_math", videoURL: "https://www.youtube.com/watch?v=fNk_zzaMoSs")
                        ]
                    )
                ]
            ),
            // Milestone 2: Classical Machine Learning
                        Milestone(
                            title: "Supervised Learning",
                            subtitle: "Predictive modeling",
                            iconName: "chart.line.uptrend.xyaxis",
                            iconColor: UIColor(hex: "#E67E22"),
                            iconBackgroundColor: UIColor(hex: "#FDF2E9"),
                            lessons: [
                                Lesson(
                                    id: "regression_basics",
                                    name: "Regression Analysis",
                                    subtitle: "Linear and Polynomial regression techniques.",
                                    dueDate: "Jan 12",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "regression_basics", title: "Linear Regression Path", duration: "15:30", thumbnailName: "vid_reg", videoURL: "https://www.youtube.com/watch?v=PaFPbb66DxQ")
                                    ]
                                ),
                                Lesson(
                                    id: "classification_models",
                                    name: "Classification Mastery",
                                    subtitle: "Logistic Regression, SVMs, and Decision Trees.",
                                    dueDate: "Jan 15",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 3: Ensemble Methods & Optimization
                        Milestone(
                            title: "Advanced Algorithms",
                            subtitle: "Boosting and Bagging",
                            iconName: "square.stack.3d.up.fill",
                            iconColor: UIColor(hex: "#9B59B6"),
                            iconBackgroundColor: UIColor(hex: "#F5EEF8"),
                            lessons: [
                                Lesson(
                                    id: "random_forests",
                                    name: "Random Forests & XGBoost",
                                    subtitle: "Building robust ensemble models.",
                                    dueDate: "Jan 20",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "random_forests", title: "XGBoost Explained", duration: "18:45", thumbnailName: "vid_ensemble", videoURL: "https://www.youtube.com/watch?v=OtD8wVaFm6E")
                                    ]
                                ),
                                Lesson(
                                    id: "hyperparameter_tuning",
                                    name: "Model Optimization",
                                    subtitle: "Grid search and Bayesian optimization.",
                                    dueDate: "Jan 24",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 4: Deep Learning Foundations
                        Milestone(
                            title: "Neural Networks",
                            subtitle: "Artificial intelligence core",
                            iconName: "brain.headset",
                            iconColor: UIColor(hex: "#2ECC71"),
                            iconBackgroundColor: UIColor(hex: "#EAFAF1"),
                            lessons: [
                                Lesson(
                                    id: "neural_net_intro",
                                    name: "Perceptrons & Backpropagation",
                                    subtitle: "How neural networks learn from error.",
                                    dueDate: "Jan 30",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "neural_net_intro", title: "But what is a Neural Network?", duration: "20:00", thumbnailName: "vid_3b1b", videoURL: "https://www.youtube.com/watch?v=aircAruvnKk")
                                    ]
                                ),
                                Lesson(
                                    id: "pytorch_basics",
                                    name: "PyTorch Framework",
                                    subtitle: "Building DL models with tensors.",
                                    dueDate: "Feb 05",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 5: Computer Vision & NLP
                        Milestone(
                            title: "Specialized AI",
                            subtitle: "Vision and Language",
                            iconName: "eye.fill",
                            iconColor: UIColor(hex: "#3498DB"),
                            iconBackgroundColor: UIColor(hex: "#EBF5FB"),
                            lessons: [
                                Lesson(
                                    id: "cnn_vision",
                                    name: "Convolutional Networks",
                                    subtitle: "Image recognition and spatial data processing.",
                                    dueDate: "Feb 12",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "transformers_nlp",
                                    name: "Transformers & Attention",
                                    subtitle: "The architecture behind modern NLP.",
                                    dueDate: "Feb 18",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 6: Large Language Models (LLMs)
                        Milestone(
                            title: "Generative AI",
                            subtitle: "Modern LLM development",
                            iconName: "sparkles",
                            iconColor: UIColor(hex: "#F1C40F"),
                            iconBackgroundColor: UIColor(hex: "#FEF9E7"),
                            lessons: [
                                Lesson(
                                    id: "llm_finetuning",
                                    name: "Fine-tuning LLMs",
                                    subtitle: "Customizing GPT models for specific tasks.",
                                    dueDate: "Feb 25",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "prompt_engineering",
                                    name: "Prompt Engineering",
                                    subtitle: "Advanced techniques for GenAI control.",
                                    dueDate: "Mar 01",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 7: MLOps & Deployment
                        Milestone(
                            title: "AI Production",
                            subtitle: "Deploying intelligent systems",
                            iconName: "shippingbox.fill",
                            iconColor: UIColor(hex: "#34495E"),
                            iconBackgroundColor: UIColor(hex: "#EBEDEF"),
                            lessons: [
                                Lesson(
                                    id: "model_deployment",
                                    name: "Model Serving",
                                    subtitle: "Deploying models as APIs using FastAPI.",
                                    dueDate: "Mar 08",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "monitoring_drift",
                                    name: "Monitoring & Drift",
                                    subtitle: "Ensuring AI reliability in production.",
                                    dueDate: "Mar 12",
                                    status: .startTest
                                )
                            ]
                        )
        ],
        isStarted: false
    ),

    //App Development
    Roadmap(
        title: "App Development",
        subtitle: "Full Stack Builder",
        description: "Build modern mobile and web applications.",
        imageName: "appdev-role 1",
        percentage: 65,
        milestones: [
            Milestone(
                title: "UI Development",
                subtitle: "Build app interfaces",
                iconName: "iphone",
                iconColor: UIColor(hex: "#007AFF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "ui_design",
                        name: "UI Design Principles",
                        subtitle: "Typography, spacing, and accessibility.",
                        dueDate: "Jan 8",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ui_design", title: "Principles of Clean UI", duration: "08:30", thumbnailName: "vid_ui", videoURL: "https://www.youtube.com/watch?v=7ZfKovNAtpw")
                        ],
                        documents: [
                            DocResource(lessonId: "ui_design", title: "Apple Human Interface Guidelines", readTime: "20 min read", docURL: "https://developer.apple.com/design/human-interface-guidelines/")
                        ]
                    )
                ]
            ),
            // Milestone 2: Native iOS Development (SwiftUI)
                        Milestone(
                            title: "Frontend Frameworks",
                            subtitle: "SwiftUI & State Management",
                            iconName: "swift",
                            iconColor: UIColor(hex: "#F05138"),
                            iconBackgroundColor: UIColor(hex: "#FEEBE9"),
                            lessons: [
                                Lesson(
                                    id: "swiftui_basics",
                                    name: "Declarative UI with SwiftUI",
                                    subtitle: "Views, Stacks, and Lists.",
                                    dueDate: "Jan 15",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "swiftui_basics", title: "SwiftUI for Beginners", duration: "15:20", thumbnailName: "vid_swiftui", videoURL: "https://www.youtube.com/watch?v=b1oC7sli_6Q")
                                    ]
                                ),
                                Lesson(
                                    id: "state_management",
                                    name: "Data Flow & State",
                                    subtitle: "@State, @Binding, and @EnvironmentObject.",
                                    dueDate: "Jan 18",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 3: Networking & API Integration
                        Milestone(
                            title: "Data & Networking",
                            subtitle: "Connect to the world",
                            iconName: "network",
                            iconColor: UIColor(hex: "#5856D6"),
                            iconBackgroundColor: UIColor(hex: "#EFEFFD"),
                            lessons: [
                                Lesson(
                                    id: "json_parsing",
                                    name: "REST APIs & JSON",
                                    subtitle: "Using URLSession and Codable to fetch data.",
                                    dueDate: "Jan 25",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "json_parsing", title: "Networking in Swift", duration: "12:45", thumbnailName: "vid_network", videoURL: "https://www.youtube.com/watch?v=cuEtnjdC670")
                                    ]
                                ),
                                Lesson(
                                    id: "async_await",
                                    name: "Concurrency",
                                    subtitle: "Mastering Async/Await for smooth performance.",
                                    dueDate: "Jan 30",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 4: Backend Development
                        Milestone(
                            title: "Backend Foundations",
                            subtitle: "Node.js & Databases",
                            iconName: "server.rack",
                            iconColor: UIColor(hex: "#34C759"),
                            iconBackgroundColor: UIColor(hex: "#EBF9EE"),
                            lessons: [
                                Lesson(
                                    id: "express_js",
                                    name: "Server-Side Logic",
                                    subtitle: "Building APIs with Express.js.",
                                    dueDate: "Feb 05",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "express_js", title: "Express.js Crash Course", duration: "20:00", thumbnailName: "vid_express", videoURL: "https://www.youtube.com/watch?v=L72fhGm1tfE")
                                    ]
                                ),
                                Lesson(
                                    id: "sql_db",
                                    name: "Database Management",
                                    subtitle: "PostgreSQL and relational data modeling.",
                                    dueDate: "Feb 10",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 5: Local Persistence & Security
                        Milestone(
                            title: "Advanced App Logic",
                            subtitle: "Persistence & Auth",
                            iconName: "lock.shield.fill",
                            iconColor: UIColor(hex: "#FF9500"),
                            iconBackgroundColor: UIColor(hex: "#FFF4E6"),
                            lessons: [
                                Lesson(
                                    id: "swift_data",
                                    name: "SwiftData & CoreData",
                                    subtitle: "Saving user data locally on the device.",
                                    dueDate: "Feb 18",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "user_auth",
                                    name: "Firebase Authentication",
                                    subtitle: "Implementing Login, Signup, and Social Auth.",
                                    dueDate: "Feb 22",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 6: Architecture & Testing
                        Milestone(
                            title: "Pro Architecture",
                            subtitle: "MVVM & Unit Testing",
                            iconName: "square.stack.3d.up.fill",
                            iconColor: UIColor(hex: "#AF52DE"),
                            iconBackgroundColor: UIColor(hex: "#F7EEFD"),
                            lessons: [
                                Lesson(
                                    id: "mvvm_pattern",
                                    name: "MVVM Architecture",
                                    subtitle: "Separating logic from view for scalability.",
                                    dueDate: "Mar 01",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "unit_testing",
                                    name: "XCTest & Debugging",
                                    subtitle: "Writing tests to ensure app reliability.",
                                    dueDate: "Mar 05",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 7: Deployment & App Store
                        Milestone(
                            title: "Ship to Store",
                            subtitle: "Deployment & Analytics",
                            iconName: "paperplane.fill",
                            iconColor: UIColor(hex: "#007AFF"),
                            iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                            lessons: [
                                Lesson(
                                    id: "app_store_connect",
                                    name: "App Store Connect",
                                    subtitle: "Preparing metadata, screenshots, and privacy info.",
                                    dueDate: "Mar 12",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "testflight",
                                    name: "Beta Testing",
                                    subtitle: "Using TestFlight for user feedback.",
                                    dueDate: "Mar 15",
                                    status: .startTest
                                )
                            ]
                        )
        ],
        isStarted: false
    ),

    //Cyber Security
    Roadmap(
        title: "Cyber Security",
        subtitle: "Security Specialist Track",
        description: "Protect systems and networks from cyber threats.",
        imageName: "cyber-security-role",
        percentage: 20,
        milestones: [
            Milestone(
                title: "Network Security",
                subtitle: "Protect infrastructure",
                iconName: "network",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "networking_basics",
                        name: "Networking Fundamentals",
                        subtitle: "TCP/IP models and network protocols.",
                        dueDate: "Jan 7",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "networking_basics", title: "How the Internet Works", duration: "14:20", thumbnailName: "vid_net", videoURL: "https://www.youtube.com/watch?v=Dxcc6ycZ73M")
                        ]
                    )
                ]
            ),
            // Milestone 2: Security Foundations & Cryptography
                        Milestone(
                            title: "Security Principles",
                            subtitle: "Protecting Data Integrity",
                            iconName: "lock.shield.fill",
                            iconColor: UIColor(hex: "#FF9500"),
                            iconBackgroundColor: UIColor(hex: "#FFF4E6"),
                            lessons: [
                                Lesson(
                                    id: "cia_triad",
                                    name: "The CIA Triad",
                                    subtitle: "Confidentiality, Integrity, and Availability.",
                                    dueDate: "Jan 12",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "cia_triad", title: "Cybersecurity Core Principles", duration: "08:45", thumbnailName: "vid_cia", videoURL: "https://www.youtube.com/watch?v=L5pAn6_O_vA")
                                    ]
                                ),
                                Lesson(
                                    id: "crypto_basics",
                                    name: "Cryptography Basics",
                                    subtitle: "Encryption, Hashing, and Digital Signatures.",
                                    dueDate: "Jan 15",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 3: Operating Systems & Endpoint Security
                        Milestone(
                            title: "Endpoint Security",
                            subtitle: "Secure OS Environments",
                            iconName: "desktopcomputer",
                            iconColor: UIColor(hex: "#5856D6"),
                            iconBackgroundColor: UIColor(hex: "#EFEFFD"),
                            lessons: [
                                Lesson(
                                    id: "linux_security",
                                    name: "Linux Hardening",
                                    subtitle: "Permissions, firewalls, and secure shell (SSH).",
                                    dueDate: "Jan 22",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "linux_security", title: "Linux Security Essentials", duration: "18:20", thumbnailName: "vid_linux_sec", videoURL: "https://www.youtube.com/watch?v=0_u9H_D9B_w")
                                    ]
                                ),
                                Lesson(
                                    id: "windows_sec",
                                    name: "Windows Defense",
                                    subtitle: "Active Directory and Group Policy security.",
                                    dueDate: "Jan 25",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 4: Threat Intelligence & Vulnerabilities
                        Milestone(
                            title: "Threat Landscape",
                            subtitle: "Identify and Analyze Threats",
                            iconName: "ant.fill",
                            iconColor: UIColor(hex: "#FF3B30"),
                            iconBackgroundColor: UIColor(hex: "#FEEBEA"),
                            lessons: [
                                Lesson(
                                    id: "malware_types",
                                    name: "Malware Analysis",
                                    subtitle: "Viruses, Ransomware, and Trojans.",
                                    dueDate: "Feb 02",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "malware_types", title: "How Malware Works", duration: "12:10", thumbnailName: "vid_malware", videoURL: "https://www.youtube.com/watch?v=7P-O7u_Iu2c")
                                    ]
                                ),
                                Lesson(
                                    id: "vuln_assessment",
                                    name: "Vulnerability Scanning",
                                    subtitle: "Using tools like Nessus to find weaknesses.",
                                    dueDate: "Feb 06",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 5: Ethical Hacking & Penetration Testing
                        Milestone(
                            title: "Ethical Hacking",
                            subtitle: "Offensive Security Basics",
                            iconName: "terminal.fill",
                            iconColor: UIColor(hex: "#2ECC71"),
                            iconBackgroundColor: UIColor(hex: "#EAFAF1"),
                            lessons: [
                                Lesson(
                                    id: "web_app_sec",
                                    name: "Web Security (OWASP Top 10)",
                                    subtitle: "SQL Injection and Cross-Site Scripting (XSS).",
                                    dueDate: "Feb 15",
                                    status: .startTest,
                                    videos: [
                                        VideoResource(lessonId: "web_app_sec", title: "OWASP Top 10 Explained", duration: "25:00", thumbnailName: "vid_owasp", videoURL: "https://www.youtube.com/watch?v=68D_qL8p08I")
                                    ]
                                ),
                                Lesson(
                                    id: "metasploit_intro",
                                    name: "Exploitation Frameworks",
                                    subtitle: "Intro to Metasploit and Nmap.",
                                    dueDate: "Feb 20",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 6: Incident Response & Forensics
                        Milestone(
                            title: "Defense Operations",
                            subtitle: "Respond and Recover",
                            iconName: "bandage.fill",
                            iconColor: UIColor(hex: "#AF52DE"),
                            iconBackgroundColor: UIColor(hex: "#F7EEFD"),
                            lessons: [
                                Lesson(
                                    id: "ir_lifecycle",
                                    name: "Incident Response Steps",
                                    subtitle: "Preparation, Detection, and Containment.",
                                    dueDate: "Mar 02",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "digital_forensics",
                                    name: "Digital Forensics",
                                    subtitle: "Evidence collection and log analysis.",
                                    dueDate: "Mar 08",
                                    status: .startTest
                                )
                            ]
                        ),
                        
                        // Milestone 7: GRC & Professional Career
                        Milestone(
                            title: "Security Governance",
                            subtitle: "Compliance & Industry Standards",
                            iconName: "briefcase.fill",
                            iconColor: UIColor(hex: "#34495E"),
                            iconBackgroundColor: UIColor(hex: "#EBEDEF"),
                            lessons: [
                                Lesson(
                                    id: "iso_standards",
                                    name: "Compliance (ISO 27001)",
                                    subtitle: "GDPR, HIPAA, and industry frameworks.",
                                    dueDate: "Mar 15",
                                    status: .startTest
                                ),
                                Lesson(
                                    id: "sec_cert_prep",
                                    name: "Security+ Certification Prep",
                                    subtitle: "Mock exams and technical interview prep.",
                                    dueDate: "Mar 20",
                                    status: .startTest
                                )
                            ]
                        )
        ],
        isStarted: false
    ),
    
    //Blockchain
    Roadmap(
        title: "Blockchain Development",
        subtitle: "Web3 & Decentralized Systems",
        description: "Master the foundations of distributed ledgers, smart contracts, and decentralized application (dApp) architecture.",
        imageName: "blockchain",
        percentage: 0,
        milestones: [
            // Milestone 1: Blockchain Fundamentals
            Milestone(
                title: "Blockchain Core",
                subtitle: "Distributed Ledger Basics",
                iconName: "link.circle.fill",
                iconColor: UIColor(hex: "#5856D6"),
                iconBackgroundColor: UIColor(hex: "#EFEFFD"),
                lessons: [
                    Lesson(
                        id: "intro_blockchain",
                        name: "What is Blockchain?",
                        subtitle: "Blocks, chains, and decentralization concepts.",
                        dueDate: "Jan 10",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "intro_blockchain", title: "Blockchain 101", duration: "12:30", thumbnailName: "vid_bc_intro", videoURL: "https://www.youtube.com/watch?v=SSo_EIwHSd4")
                        ]
                    ),
                    Lesson(
                        id: "consensus_mechanisms",
                        name: "Consensus Protocols",
                        subtitle: "Proof of Work vs. Proof of Stake.",
                        dueDate: "Jan 14",
                        status: .startTest
                    )
                ]
            ),

            // Milestone 2: Cryptography & Security
            Milestone(
                title: "Web3 Security",
                subtitle: "Hashing & Digital Signatures",
                iconName: "lock.shield.fill",
                iconColor: UIColor(hex: "#FF9500"),
                iconBackgroundColor: UIColor(hex: "#FFF4E6"),
                lessons: [
                    Lesson(
                        id: "bc_hashing",
                        name: "SHA-256 & Merkle Trees",
                        subtitle: "Securing data integrity within blocks.",
                        dueDate: "Jan 20",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "bc_hashing", title: "Cryptographic Hash Functions", duration: "09:45", thumbnailName: "vid_hashing", videoURL: "https://www.youtube.com/watch?v=0WiTaBI828U")
                        ]
                    ),
                    Lesson(
                        id: "wallets_keys",
                        name: "Public vs Private Keys",
                        subtitle: "Understanding wallet addresses and signatures.",
                        dueDate: "Jan 25",
                        status: .startTest
                    )
                ]
            ),

            // Milestone 3: Ethereum & Smart Contracts
            Milestone(
                title: "Smart Contract Logic",
                subtitle: "Solidity Development",
                iconName: "doc.text.below.ecg.fill",
                iconColor: UIColor(hex: "#2ECC71"),
                iconBackgroundColor: UIColor(hex: "#EAFAF1"),
                lessons: [
                    Lesson(
                        id: "solidity_basics",
                        name: "Solidity Syntax",
                        subtitle: "Variables, functions, and state management.",
                        dueDate: "Feb 02",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "solidity_basics", title: "Solidity in 20 Minutes", duration: "20:00", thumbnailName: "vid_solidity", videoURL: "https://www.youtube.com/watch?v=kYI8-t9K4V4")
                        ]
                    ),
                    Lesson(
                        id: "evm_logic",
                        name: "Ethereum Virtual Machine",
                        subtitle: "How gas fees and contract execution work.",
                        dueDate: "Feb 07",
                        status: .startTest
                    )
                ]
            ),

            // Milestone 4: dApp Architecture
            Milestone(
                title: "Decentralized Apps",
                subtitle: "Connecting Web2 to Web3",
                iconName: "square.grid.3x3.fill",
                iconColor: UIColor(hex: "#3498DB"),
                iconBackgroundColor: UIColor(hex: "#EBF5FB"),
                lessons: [
                    Lesson(
                        id: "ethers_js",
                        name: "Ethers.js & Web3.js",
                        subtitle: "Interacting with the blockchain via JavaScript.",
                        dueDate: "Feb 15",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ethers_js", title: "Connecting Frontend to Smart Contracts", duration: "15:10", thumbnailName: "vid_web3js", videoURL: "https://www.youtube.com/watch?v=pdsBaCHX2-Q")
                        ]
                    ),
                    Lesson(
                        id: "ipfs_storage",
                        name: "Decentralized Storage",
                        subtitle: "Using IPFS for off-chain file storage.",
                        dueDate: "Feb 20",
                        status: .startTest
                    )
                ]
            ),

            // Milestone 5: DeFi & Token Standards
            Milestone(
                title: "Tokenomics",
                subtitle: "ERC Standards & DeFi",
                iconName: "bitcoinsign.circle.fill",
                iconColor: UIColor(hex: "#F1C40F"),
                iconBackgroundColor: UIColor(hex: "#FEF9E7"),
                lessons: [
                    Lesson(
                        id: "token_standards",
                        name: "ERC-20 & ERC-721",
                        subtitle: "Building Fungible tokens and NFTs.",
                        dueDate: "Feb 28",
                        status: .startTest
                    ),
                    Lesson(
                        id: "defi_protocols",
                        name: "DeFi Ecosystems",
                        subtitle: "Liquidity pools, staking, and yield farming.",
                        dueDate: "Mar 05",
                        status: .startTest
                    )
                ]
            ),

            // Milestone 6: Layer 2 & Scalability
            Milestone(
                title: "Advanced Scalability",
                subtitle: "Scaling the Ecosystem",
                iconName: "arrow.up.right.and.arrow.down.left.rectangle.fill",
                iconColor: UIColor(hex: "#AF52DE"),
                iconBackgroundColor: UIColor(hex: "#F7EEFD"),
                lessons: [
                    Lesson(
                        id: "layer_2_solutions",
                        name: "L2 & Rollups",
                        subtitle: "Optimism, Arbitrum, and ZK-Rollups.",
                        dueDate: "Mar 15",
                        status: .startTest
                    ),
                    Lesson(
                        id: "bc_interoperability",
                        name: "Cross-Chain Bridges",
                        subtitle: "Connecting different blockchain ecosystems.",
                        dueDate: "Mar 20",
                        status: .startTest
                    )
                ]
            )
        ],
        isStarted: false
    ),
    
]
