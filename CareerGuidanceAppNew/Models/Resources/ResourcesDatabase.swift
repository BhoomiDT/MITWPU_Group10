import Foundation

enum ResourcesDatabase {

    static let videos: [VideoResource] = [
        VideoResource(
            title: "Introduction to Machine Learning",
            duration: "10:45",
            thumbnailName: "campusx_ml",
            videoURL: "https://www.youtube.com/watch?v=GwIo3gDZCVQ"
        ),
        VideoResource(
            title: "Machine Learning Explained Simply",
            duration: "10:15",
            thumbnailName: "techwithtim_ml",
            videoURL: "https://www.youtube.com/watch?v=ukzFI9rgwfU"
        ),
        VideoResource(
            title: "Machine Learning Roadmap 2024",
            duration: "10:30",
            thumbnailName: "gatesmashers_ml",
            videoURL: "https://www.youtube.com/watch?v=1vsmaEfbno8"
        )
    ]

    static let documents: [DocResource] = [
        DocResource(
            title: "Introduction to Machine Learning",
            readTime: "10 min read",
            docURL: "https://developers.google.com/machine-learning/crash-course"
        ),
        DocResource(
            title: "Supervised Learning",
            readTime: "21 min read",
            docURL: "https://www.ibm.com/topics/supervised-learning"
        ),
        DocResource(
            title: "Unsupervised Learning",
            readTime: "19 min read",
            docURL: "https://www.ibm.com/topics/unsupervised-learning"
        )
    ]
}

