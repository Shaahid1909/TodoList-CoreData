

import UIKit
import CoreData

class CategoryViewController: UITableViewController, UITextFieldDelegate {
    
var taskField = UITextField()
var DateTask = UITextField()
    
    var taskArray = [String]()

    var categories = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.dataSource = self
        tableView.delegate = self
        saveCategories()
        tableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
//        cell.textLabel?.text = category.name
//
        cell.TaskName.backgroundColor = UIColor.clear
        cell.DateTask.backgroundColor = UIColor.clear


        cell.TaskName.isUserInteractionEnabled = false
        cell.TaskName.text = category.name
        cell.DateTask.text = category.date
    
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
//               if cell.TaskName.isEditing == true{
//                   let Task = Category(context: self.context)
//                   cell.TaskName.text = categories[indexPath.row].name
//               }
//
//               cell.TaskName.text = categories[indexPath.row].name
//               cell.DateTask.text = categories[indexPath.row].date
               
    
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let category = categories[indexPath.row]
            categories.remove(at: indexPath.row)
            context.delete(category)
            
            
            do {
                try context.save()
            } catch {
                print("Error deleting category with \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)  //includes updating UI so reloading is not necessary
        }
    }

    //MARK: Data Manipulation Methods
    
    func saveCategories(){
        
        do{
            try context.save()
        }catch {
            print("Error saving category with \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    func loadCategories(){
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categories = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        let sort = NSSortDescriptor(key: #keyPath(Category.date), ascending: false)
               fetchRequest.sortDescriptors = [sort]
               do {
                  categories = try context.fetch(fetchRequest)
               } catch {
                   print("Cannot fetch Todo")
               }
            //   tableView.reloadData()
           }

    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let doneAction = UIContextualAction(style: .normal, title: "☑️") {(action, view, completionHandler) in

    
//
//        let newCategory = Category(context: self.context)
//
//
//        newCategory.name = self.textField.text!
//
//        self.categories.append(newCategory)
//
//        self.saveCategories()
//
        
//      func prepare(segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! ItemViewController
//        destinationVC.selectedCategory = self.categories[indexPath.row]
//        }
    self.taskArray.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
        }
        
        doneAction.backgroundColor = .systemGreen
        doneAction.image = #imageLiteral(resourceName: "29")
            
       let actionLike = UIContextualAction(style: .destructive, title: "🤍") {(action, view, completionHandler) in
       completionHandler(true)

        
        
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signupPopUpID") as! signupPopupController
        self.addChild(popOverVC)
            
                   popOverVC.view.frame = self.view.frame
                   self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)

        }
    actionLike.backgroundColor = .systemPink
    let CatAction = UIContextualAction(style: .normal, title: "") {(action, view, completionHandler) in completionHandler(true)
    }
                   CatAction.backgroundColor = .systemBlue
                CatAction.image = #imageLiteral(resourceName: "29-1")
            return UISwipeActionsConfiguration(actions: [doneAction, actionLike, CatAction])
          //  return swipeActions
        
        }
    
    @IBAction func CalButton(_ sender: UIBarButtonItem) {
      
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderID")
        self.addChild(popOverVC)
        
               popOverVC.view.frame = self.view.frame
               self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       // var textField = UITextField()
        
        
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = self.taskField.text!
            self.categories.append(newCategory)
            self.saveCategories()
 
            
            
        }
        
        alert.addAction(action)
        
        
        alert.addTextField { (alertTaskField) in
            self.taskField = alertTaskField
            alertTaskField.placeholder = "Enter a new Task"
        }
//        alert.addTextField { (alertDateField) in
//            self.DateTask = alertDateField
//                   alertDateField.placeholder = "Add Date"
//               }
        
        present(alert, animated: true, completion: nil)
    }}
//            extension UITextField {
//        func setIcon(_ image: UIImage) {
//           let iconView = UIImageView(frame:
//                          CGRect(x: 0, y: 0, width: 30, height: 30))
//           iconView.image = image
//           let iconContainerView: UIView = UIView(frame:
//                          CGRect(x: 0, y: 0, width: 30, height: 30))
//           iconContainerView.addSubview(iconView)
//           leftView = iconContainerView
//           leftViewMode = .always
//        }
//}
    


