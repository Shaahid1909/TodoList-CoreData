
import UIKit
import CoreData
import FloatingTabBarController

class CateDemoView: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let transiton = SlideInTransition()
    var topView: UIView?
    
      var actionButton : ActionButton!
  var categories = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let start_end_date = UIDatePicker()
   // let end_date = UIDatePicker()

    var designationview = UIPickerView()
    let designationoptions = ["Home","Official","Personal","Payment","Shopping","Wishlist","Travel","Meeting","Occasions","Study","Inbox","Others"]

    var updated:String = ""
    
    
    @IBAction func didTapMenu(_ sender: Any) {
        
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
            menuViewController.didTapMenuType = { menuType in
                self.transitionToNew(menuType)
            }
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.transitioningDelegate = self
            present(menuViewController, animated: true)
        }

        func transitionToNew(_ menuType: MenuType) {
            let title = String(describing: menuType).capitalized
            self.title = title

            topView?.removeFromSuperview()
            switch menuType {
            case .profile:
                let view = UIView()
                view.backgroundColor = .yellow
                view.frame = self.view.bounds
                self.view.addSubview(view)
                self.topView = view
            case .setting:
                let view = UIView()
                view.backgroundColor = .systemGreen
                view.frame = self.view.bounds
                self.view.addSubview(view)
                self.topView = view
            default:
                break
            }
        }
        
    
    @IBOutlet var lab1: UILabel!
    @IBOutlet var lab2: UILabel!
    @IBOutlet var lab3: UILabel!
    @IBOutlet var addNewTaskLab: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TaskName: UITextField!
    @IBOutlet weak var Currdate: UITextField!
    @IBOutlet weak var categorywise: UITextField!
    
    @IBOutlet var BlurEffect: UIVisualEffectView!
    @IBOutlet var PopView: UIView!
    @IBAction func CalButton(_ sender: UIBarButtonItem) {
        
//
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderID")
//        self.addChild(popOverVC)
//
//               popOverVC.view.frame = self.view.frame
//               self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParent: self)
//
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalenderID") as! CalenderViewController
        //
            self.navigationController?.pushViewController(vc, animated: true)
               navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem?.tintColor = UIColor.black

        
    }
    func setupButtons(){
               let google = ActionButtonItem(title: "Google", image: #imageLiteral(resourceName: "a1"))
               google.action = { item in self.view.backgroundColor = UIColor.red }
               let twitter = ActionButtonItem(title: "Twitter", image: #imageLiteral(resourceName: "a2"))
               twitter.action = { item in self.view.backgroundColor = UIColor.blue }
               let facebook = ActionButtonItem(title: "Facebook", image: #imageLiteral(resourceName: "a3"))
               let linkedin = ActionButtonItem(title: "Linkedin", image: #imageLiteral(resourceName: "a4"))
               actionButton = ActionButton(attachedToView: self.view, items: [google, twitter, facebook, linkedin])
           actionButton.setTitle("+", forState: UIControl.State())
               actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1)
               actionButton.action = { button in button.toggleMenu()}
           }

    @IBAction func didTapSort(_ sender: Any) {
        if tableView.isEditing{
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }

    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        setupButtons()
    PopView.layer.cornerRadius = 10
    PopView.layer.borderColor = UIColor.red.cgColor
    PopView.layer.borderWidth = 0.3
        
        
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        BlurEffect.bounds = self.view.bounds
        PopView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        tableView.register(UINib(nibName: "TableViewCell_1", bundle: nil), forCellReuseIdentifier: "TableViewCell_1")
        tableView.rowHeight = 80
//       btnaddoutlet.layer.cornerRadius = 30
//        btnaddoutlet.clipsToBounds = true
        designationview.dataSource=self
        designationview.delegate=self
        categorywise.inputView = designationview
        datepickerbirth()
        doneselect()
        joinpicker()
        joinselect()
        
        loadCategories()
        saveCategories()
        tableView.reloadData()
        
       }
    
    func datepickerbirth(){
        let toolbar=UIToolbar()
        toolbar.sizeToFit()
        let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect))
        toolbar.setItems([done], animated: false)
        Currdate.inputAccessoryView=toolbar
        Currdate.inputView=start_end_date
        start_end_date.datePickerMode = .date
    }
    
    @objc func doneselect(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        let datestring = dateformat.string(from: start_end_date.date)
        Currdate.text="\(datestring)"
        self.view.endEditing(true)
    }
    
    func joinpicker(){
        let toolbar=UIToolbar()
        toolbar.sizeToFit()
        let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(joinselect))
        toolbar.setItems([done], animated: false)
     
    }
    
    @objc func joinselect(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
//        let datestring = dateformat.string(from: end_date.date)
//        EndDate.text="\(datestring)"
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return designationoptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        designationoptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorywise.text = designationoptions[row]
        categorywise.resignFirstResponder()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            
            let Tasks = categories[indexPath.row]
            categories.remove(at: indexPath.row)
            context.delete(Tasks)
            
            do {
                try context.save()
            } catch {
                print("Error deleting Task with \(error)")
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    func saveCategories(){
        
        do{
            try context.save()
        }catch {
            print("Error saving Task with \(error)")
        }
        
        tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let doneAction = UIContextualAction(style: .normal, title: "☑️") {(action, view, completionHandler) in


       self.categories.remove(at: indexPath.row)
       tableView.deleteRows(at: [indexPath], with: .automatic)
                       completionHandler(true)
           }
           
           doneAction.backgroundColor = .systemGreen
           doneAction.image = #imageLiteral(resourceName: "29")
               
          let actionLike = UIContextualAction(style: .destructive, title: "🤍") {(action, view, completionHandler) in
          completionHandler(true)

           
           
               let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpID") as! signupPopupController
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
       
    
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "goToItems", sender: self)
    
//    let vc = self.storyboard?.instantiateViewController(withIdentifier: "pushView") as! NextCalController
//
//    self.navigationController?.pushViewController(vc, animated: true)
//       navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
//    navigationItem.backBarButtonItem?.tintColor = UIColor.black
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let destinationVC = segue.destination as! NextCalController
           
           if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.selectedCategory = categories[indexPath.row]
           }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
                   navigationItem.backBarButtonItem?.tintColor = UIColor.black

       }
       
   func loadCategories(){
            let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
//            let sort = NSSortDescriptor(key: #keyPath(Category.date), ascending: false)
//                   fetchRequest.sortDescriptors = [sort]
    
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    
                   do {
                      categories = try context.fetch(fetchRequest)
                   } catch {
                       print("Cannot fetch Todo")
                   }
                //   tableView.reloadData()
               }
    
    @IBAction func addTask(_ sender: Any) {
        
        let Task = Category(context: self.context)
        Task.name = TaskName.text
        Task.date = Currdate.text
        Task.category = categorywise.text
        self.categories.append(Task)
        self.loadCategories()
        self.saveCategories()
        TaskName.text = ""
        Currdate.text = ""
        animatedismiss(desiredView: PopView)
        animatedismiss(desiredView: BlurEffect)
        categorywise.text = ""
        tableView.reloadData()
    }
    

    
    @IBAction func animatedout(_ sender: Any) {
        
        animatedismiss(desiredView: PopView)
        animatedismiss(desiredView: BlurEffect)
    }
    
    @IBAction func addtodo(_ sender: Any) {
        
        animateIn(desiredView: BlurEffect)
        animateIn(desiredView: PopView)
        
    }
    //--- sort rows <
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        categories.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
 //sort row >
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_1", for: indexPath) as! TableViewCell_1
        if cell.CellTaskName.isEditing == true{
            let Task = Category(context: self.context)
            cell.CellTaskName.text = categories[indexPath.row].name
        }

        cell.CellTaskName.text = categories[indexPath.row].name
        cell.CellCurrDate.text = categories[indexPath.row].date
     
        if (categories[indexPath.row].category == "Others"){
        cell.imageViewcat.image = UIImage(named: "comm.jpg")
            cell.circleimg.tintColor = UIColor.brown
        }else if (categories[indexPath.row].category == "Shopping") {
            cell.imageViewcat.image = UIImage(named: "bag.jpg")
            cell.circleimg.tintColor = UIColor.systemYellow
            
        }else if (categories[indexPath.row].category == "Home") {
            cell.imageViewcat.image = UIImage(named: "house.png")
            cell.circleimg.tintColor = UIColor.systemOrange
        }else if (categories[indexPath.row].category == "Personal") {
            cell.imageViewcat.image = UIImage(named: "comm.jpg")
            cell.circleimg.tintColor = UIColor.brown
        }else if (categories[indexPath.row].category == "Wishlist") {
            cell.imageViewcat.image = UIImage(named: "wishlist.png")
            cell.circleimg.tintColor = UIColor.systemTeal
        }else if (categories[indexPath.row].category == "Study") {
            cell.imageViewcat.image = UIImage(named: "study.png")
            cell.circleimg.tintColor = UIColor.blue
        }else if (categories[indexPath.row].category == "Travel") {
            cell.imageViewcat.image = UIImage(named: "travel.png")
            cell.circleimg.tintColor = UIColor.blue
        }else if (categories[indexPath.row].category == "Occasions"){
            cell.imageViewcat.image = UIImage(named: "bag.png")
            cell.circleimg.tintColor = UIColor.systemYellow
        } else if (categories[indexPath.row].category == "Official"){
            cell.imageViewcat.image = UIImage(named: "comm.png")
              cell.circleimg.tintColor = UIColor.brown
        }else if (categories[indexPath.row].category == "Inbox"){
            cell.imageViewcat.image = UIImage(named: "inbox.png")
             cell.circleimg.tintColor = UIColor.red
        }else if (categories[indexPath.row].category == "Meeting"){
            cell.imageViewcat.image = UIImage(named: "comm.png")
              cell.circleimg.tintColor = UIColor.brown
        }else{
            cell.imageViewcat.image = UIImage(named: "wallet.png")
            cell.circleimg.tintColor = UIColor.systemOrange
        }
        return cell
    }}
extension CateDemoView: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
    
