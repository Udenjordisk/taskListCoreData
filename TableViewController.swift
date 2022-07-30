//
//  TableViewController.swift
//  toDoListCoreData
//
//  Created by Кирилл on 28.07.2022.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {
    

    var tasks: [Tasks] = []
    
    @IBAction func deleteTasks(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()

        if let tasks = try? context.fetch(fetchRequest){
            for task in tasks {
                context.delete(task)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.tasks.removeAll(keepingCapacity: false)

        tableView.reloadData()
        
    }
    
    @IBAction func plusTasks(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Новая задача", message: "Введите задачу", preferredStyle: .alert)
        
        let saveTask = UIAlertAction(title: "Сохранить", style: .default) { action in
            let tf = alertController.textFields?.first
            if let newTask = tf?.text{
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        alertController.addAction(saveTask)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
        
    }
    
    
    
    

    func saveTask(withTitle title: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
        
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
            
            do {
                tasks = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title

        return cell
    }
    

}
