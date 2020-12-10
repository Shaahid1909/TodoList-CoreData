
import UIKit
import CoreData


class NextCalController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
var itemArray = [Item]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var pushTitle: UITextField!
    
    @IBOutlet var pushdesc: UITextField!
    
    @IBOutlet var pushpopup: UIView!
    
    
    @IBOutlet var blureffect: UIVisualEffectView!
    
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pushTable.dequeueReusableCell(withIdentifier: "TableViewCell2", for: indexPath) as! TableViewCell2
         let item = itemArray[indexPath.row]
        cell.TextTitle.text = item.title
        cell.pushTextField.text = item.notes
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           
           //context.delete(itemArray[indexPath.row])
           //itemArray.remove(at: indexPath.row)
           //toggle the check mark on or off
           itemArray[indexPath.row].done = !itemArray[indexPath.row].done
           
           saveItems()
           
           pushTable.deselectRow(at: indexPath, animated: true)
       }
    

    @IBOutlet var pushTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    pushpopup.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        
        pushpopup.layer.cornerRadius = 10
                         pushpopup.layer.borderColor = UIColor.red.cgColor
                   pushpopup.layer.borderWidth = 0.3
               
        
        pushTable.delegate = self
        pushTable.dataSource = self
        
        pushTable.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "TableViewCell2")
        pushTable.rowHeight = 80
        blureffect.bounds = self.view.bounds
//        loadItems()
//        saveItems()
      //  pushTable.reloadData()

    }
    
    func animateIn(desiredView:UIView){
           
           let backgroundView = self.view
           backgroundView?.addSubview(desiredView)
           desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
           desiredView.alpha = 0
           desiredView.center = backgroundView?.center as! CGPoint
           UIView.animate(withDuration: 0.3, animations: {
           desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
           desiredView.alpha = 1

           })
           
       }
       func  animatedismiss(desiredView:UIView){
           UIView.animate(withDuration: 0.3, animations: {
               desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
               desiredView.alpha = 0
           },completion: { _ in desiredView.removeFromSuperview()} )
       }
    
    @IBAction func AddingPush(_ sender: Any) {
        let Taski = Item(context: self.context)
              Taski.title = pushTitle.text!
              Taski.notes = pushdesc.text!
              
            
              self.loadItems()
             
              pushTitle.text = ""
              pushdesc.text = ""
              animatedismiss(desiredView: pushpopup)
              animatedismiss(desiredView: blureffect)
              
         
       Taski.parentCategory = selectedCategory
        self.itemArray.append(Taski)
        self.saveItems()
       // pushTable.reloadData()
    }
    @IBAction func pushAdd(_ sender: Any) {
        animateIn(desiredView: blureffect)
               animateIn(desiredView: pushpopup)
    }
    
    @IBAction func pushcancel(_ sender: Any) {
        animatedismiss(desiredView: pushpopup)
        animatedismiss(desiredView: blureffect)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            
            let Tasks = itemArray[indexPath.row]
            itemArray.remove(at: indexPath.row)
            context.delete(Tasks)
            
            do {
                try context.save()
            } catch {
                print("Error deleting Task with \(error)")
            }
            
            pushTable.beginUpdates()
            pushTable.deleteRows(at: [indexPath], with: .automatic)
            pushTable.endUpdates()
            pushTable.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    
    
    func saveItems(){
           do{
               try context.save()
           }catch {
               print("Error saving context with \(error)")
           }
           
           self.pushTable.reloadData()
           
       }
//      func loadItems(){
//                let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
//    //            let sort = NSSortDescriptor(key: #keyPath(Category.date), ascending: false)
//    //                   fetchRequest.sortDescriptors = [sort]
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//
//                       do {
//                          itemArray = try context.fetch(fetchRequest)
//                       } catch {
//                           print("Cannot fetch Todo")
//                       }
//       // self.pushTable.reloadData()
//                   }


//
       
func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){

      let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

      if let additionalPredicate = predicate {
          request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
      }else{
          request.predicate = categoryPredicate
      }



      do {
          itemArray = try context.fetch(request)
      }catch{
          print("Error fetching data from context \(error)")
      }

  // pushTable.reloadData()

  }
  



}
