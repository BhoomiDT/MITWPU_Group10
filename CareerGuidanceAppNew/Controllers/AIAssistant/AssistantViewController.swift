//
//  AssistantViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class AssistantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var messages = [ChatMessage(text: "Hi! I'm your AI learning assistant. Ask me anything about your roadmap or lessons.", isUser: false)]
    var conversationHistory: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //searchBar.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        searchBar.isUserInteractionEnabled = true
        searchBar.barTintColor = .appBackground
        tableView.backgroundColor = .appBackground
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.register(UINib(nibName: "aiCellView", bundle: nil), forCellReuseIdentifier: "aiCellView")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.sectionHeaderTopPadding = 0
        navigationController!.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self, selector: #selector(kbMove), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        conversationHistory.append([
            "role": "assistant",
            "content": "Hi! I'm your AI learning assistant. Ask me anything about your roadmap or lessons."
        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    func searchBarSearchButtonClicked(_ sb: UISearchBar) {
        
        guard let text = sb.text, !text.isEmpty else { return }
        
        sb.text = ""
        sb.resignFirstResponder()
        
        insert(ChatMessage(text: text, isUser: true))
        
        conversationHistory.append([
            "role": "user",
            "content": text
        ])
        
        callAI()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Tap detected - Search bar is trying to open keyboard")
        return true
    }

    func insert(_ msg: ChatMessage) {
        tableView.performBatchUpdates({
            messages.insert(msg, at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        })
    }
    
    func callAI() {
        
        guard let url = URL(string: "https://xffbxethqutrkgwyiick.supabase.co/functions/v1/chat-assistant") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmZmJ4ZXRocXV0cmtnd3lpaWNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4MDAzNjcsImV4cCI6MjA4NjM3NjM2N30._0gEE8TTSogvf4OrMEc5MBdWqO_MIQeZ8Shp6oAUw1g"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(supabaseKey)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")

        //request.setValue("Bearer sb_publishable_Ym3WzGM1Uv4rZ_uK_q2wAQ_CwvMFSNj", forHTTPHeaderField: "Authorization")

        //request.setValue("sb_publishable_Ym3WzGM1Uv4rZ_uK_q2wAQ_CwvMFSNj", forHTTPHeaderField: "apikey")
        
        if conversationHistory.count > 8 {
            conversationHistory = Array(conversationHistory.suffix(8))
        }
        
        guard let userId = UserSessionManager.shared.userId?.uuidString else {
            print("User ID missing")
            return
        }
        
        let body: [String: Any] = [
            "user_id": userId,
            "messages": conversationHistory
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("API Error:", error)
                return
            }
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let reply = json["reply"] as? String {
                    
                    DispatchQueue.main.async {
                        
                        self.insert(ChatMessage(text: reply, isUser: false))
                        
                        self.conversationHistory.append([
                            "role": "assistant",
                            "content": reply
                        ])
                    }
                }
                
            } catch {
                print("JSON Parse Error:", error)
            }
            
        }.resume()
    }

    @objc func kbMove(_ n: NSNotification) {
        guard let userInfo = n.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardViewEndFrame = view.convert(keyboardFrame.cgRectValue, from: view.window)
        let heightOffset = view.bounds.height - keyboardViewEndFrame.origin.y
        
        bottomConstraint.constant = heightOffset - view.safeAreaInsets.bottom
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curveValue << 16))

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func kbHide() {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) { view.endEditing(true) }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { messages.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aiCellView", for: indexPath) as! aiCellView
        cell.configure(with: messages[indexPath.row])
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

    
