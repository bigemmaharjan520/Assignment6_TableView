//
//  ViewController.swift
//  Assignment6_TableView_Bigem
//
//  Created by user240741 on 2/18/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
  var allTasks = [String]() //creating array variable to store the tasks
    
    //Add button
    @IBAction func todoAddBtn(_ sender: UIButton) {
        //Alert box with the message
        let alert = UIAlertController(title:"Task Reminder", message:"Please write what you want to remember", preferredStyle: .alert)
        
        //textfield in alert box
        alert.addTextField{field in field.placeholder = "Enter task..."}
        
        //Cancel button in alert
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler:{[weak alert](_) in alert?.dismiss(animated:true)}))
        
        //Done button in alert
        alert.addAction(UIAlertAction(title:"Done", style:.default, handler:{ [weak self] (_) in
            if let field = alert.textFields?.first{
            if let text = field.text, !text.isEmpty{
                //Enter new to do list item
//                print(text)
                
                DispatchQueue.main.async{
                    //For Data persistence
                    var currentTasks = UserDefaults.standard.stringArray(forKey: "allTasks") ?? []
                    currentTasks.append(text)
                    UserDefaults.standard.setValue(currentTasks, forKey: "allTasks")
                    
                    self?.allTasks.append(text)
                    self?.todoTableView.reloadData() //reloading
                }
            }
        }}))
        self.present(alert, animated:true, completion: nil)
    }
    
    //Edit button
    @IBAction func todoEditBtn(_ sender: UIButton) {
        if isEditing{
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        }else{
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated:true)
        }
    }
    
    //edit button setEditing function
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        todoTableView.setEditing(editing, animated: animated)
    }
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.allTasks = UserDefaults.standard.stringArray(forKey: "allTasks") ?? []
        todoTableView.dataSource = self
        todoTableView.delegate = self
    }
    
    //geeting number of tasks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count
    }
    
    //Display all task
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        cell.textLabel?.text = allTasks[indexPath.row]
        return cell
    }
    
    //Moving tasks
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingList = allTasks.remove(at: sourceIndexPath.row)
        allTasks.insert(movingList, at: destinationIndexPath.row)
        //updating the data persistence to get the same task placement as changes made
        callToSave()
    }
    
    //Deleting Task
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                allTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                callToSave()
            }
        }
    
    //Function to be called whenever the change is made so to make sure that data persistence is with the same data as we want
    func callToSave(){
        UserDefaults.standard.setValue(allTasks, forKey:"allTasks")
    }
}

