//
//  CreateSpinViewController.swift
//  KumuApp
//
//  Created by Jyoti on 14/06/21.
//

import UIKit

protocol CreateSpinDelegate {
    func onDismiss()
}

class CreateSpinViewController: UIViewController,  UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    var delegate: CreateSpinDelegate?
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewPageController: UIView! {
        didSet {
            createPageViewController()
        }
    }
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet private weak var btnCreateWheel: UIButton!
    @IBOutlet private weak var btnSpinSetting: UIButton!
    @IBOutlet private weak var btnPreviousWheel: UIButton!
    @IBOutlet private weak var viewLine: UIView! {
        didSet {
            viewLine.addGradientcolor(colors: [UIColor.hexStringToUIColor(hex: "#773EE4"), UIColor.hexStringToUIColor(hex: "#00C7FF")])
        }
    }
    @IBOutlet private weak var constantViewLeft: NSLayoutConstraint!
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!

    private var slices: [Slice] = []
    var isEditSetting = false
    private var setting = SpinSetting()
    
    var selecteditem : ItemsHistory?
    var isFromEditItems : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentPage = 0
        self.navigationController?.navigationBar.isHidden = true
        //temp_spinItem_setting
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem_setting") as? Data {
            let decoder = JSONDecoder()
            if let setting = try? decoder.decode(SpinSetting.self, from: savedUserData)  {
                self.setting = setting
            }
        }else {
            UserDefaults.standard.set(try? JSONEncoder().encode(self.setting), forKey: "temp_spinItem_setting")

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.onDismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.viewContainer != nil {
            self.viewContainer.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        }
    }
    
    @objc func tapToDismiss() {
          print("tapToDimiss")
        delegate?.onDismiss()
          self.dismiss(animated: true, completion: nil)
            //./delegate?.onDismiss()
      }
  
    
    private func createPageViewController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
        tapGesture.numberOfTapsRequired = 1
        self.viewBG.addGestureRecognizer(tapGesture)
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        self.pageController.view.backgroundColor = .black
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: 0, width: self.viewPageController.frame.size.width, height: self.viewPageController.frame.size.height)
        }
        
        if (isEditSetting) {
            self.btnSpinSetting.tag = 1
            self.btnSpinSetting.isEnabled = false
            //self.btnSpinSetting.setTitleColor(, for: .normal)
            self.btnCreateWheel.isHidden = true
            self.btnPreviousWheel.isHidden = true
            constantViewLeft.constant = btnSpinSetting.frame.origin.x
            
            UIView.animate(withDuration: 0.3) {
                self.viewLine.layoutIfNeeded()
            }
            let homeStoryboard = UIStoryboard(name: "CreateGame", bundle: nil)
          
            let tab2VC = homeStoryboard.instantiateViewController(withIdentifier: "SpinSettingViewController") as! SpinSettingViewController
            tab2VC.delegate = self
            tab2VC.isEditSetting = isEditSetting
            arrVC = [navController(controller: tab2VC)]
            pageController.setViewControllers([tab2VC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
           // resetTabBarForTag(tag: btnSpinSetting.tag)
            selectedButton(btn: btnSpinSetting)

        }else {
            let homeStoryboard = UIStoryboard(name: "CreateGame", bundle: nil)
          
            let tab1VC = homeStoryboard.instantiateViewController(withIdentifier: "SpinWheelCreatorViewController") as? SpinWheelCreatorViewController
            tab1VC?.delegate = self
            let vc1 = navController(controller: tab1VC!)
            let tab2VC = homeStoryboard.instantiateViewController(withIdentifier: "SpinSettingViewController") as! SpinSettingViewController
            tab2VC.delegate = self
            
            let tab3VC = homeStoryboard.instantiateViewController(withIdentifier: "SpinHistoryViewController") as! SpinHistoryViewController
            tab3VC.delegate = self
            arrVC = [vc1, navController(controller: tab2VC), navController(controller: tab3VC)]
            pageController.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)

        }
        
        
        
        //self.addChild(pageController)
        self.viewPageController.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.removeSwipeGesture()
    }
    
    func navController(controller: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: controller)
    }
    
    
    //MARK: - Custom Methods
    
    private func selectedButton(btn: UIButton) {
        
        //btn.setTitleColor(UIColor.black, for: .normal)

            btn.isSelected = true
            constantViewLeft.constant = btn.frame.origin.x
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        
    }
    
    private func unSelectedButton(btn: UIButton) {
        //btn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        btn.isSelected = false
    }
    
    //MARK: - IBaction Methods
    
    @IBAction private func btnOptionClicked(btn: UIButton) {
        
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in
        })
        
        
        resetTabBarForTag(tag: btn.tag-1)
    }
    
    private func resetTabBarForTag(tag: Int) {
        
        var sender: UIButton!
        
        if isEditSetting {
            //sender = btnSpinSetting
            return
        }
        if(tag == 0) {
            sender = btnCreateWheel
        }
        else if(tag == 1) {
            sender = btnSpinSetting
        }
        else if(tag == 2) {
            sender = btnPreviousWheel
        }
        
        currentPage = tag
        
        unSelectedButton(btn: btnCreateWheel)
        unSelectedButton(btn: btnSpinSetting)
        unSelectedButton(btn: btnPreviousWheel)
        
        
        selectedButton(btn: sender)
        
    }
    
    func removeSwipeGesture(){
        for view in self.pageController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.firstIndex(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            print("Swipe Right")
       }
       else if gesture.direction == .left {
            print("Swipe Left")
       }
       else if gesture.direction == .up {
            print("Swipe Up")
       }
       else if gesture.direction == .down {
            print("Swipe Down")
        if gesture.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
       }
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.firstIndex(of: (pageViewController1.viewControllers?.last)!)
            resetTabBarForTag(tag: currentPage)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if let controller = segue.destination as? AddEditItemViewController {
            controller.delegate = self
            controller.spinItem = sender as? SpinItem
        }else  if let spinWheel = sender as? [Slice], let controller = segue.destination as? CreateSpinGamePreviewViewController {
            controller.slices = spinWheel
            controller.setting = self.setting
            controller.isFromEditItems = self.isFromEditItems
            controller.selectedItem = self.selecteditem
        }
        
        
    }
}


extension CreateSpinViewController: HistoryDelegate {
    func onEdit(setting: SpinSetting,selecteditem : ItemsHistory,isFromEditItems : Bool) {
        self.setting = setting
        self.selecteditem = selecteditem
        self.isFromEditItems = isFromEditItems
        UserDefaults.standard.set(try? JSONEncoder().encode(self.setting), forKey: "temp_spinItem_setting")
        if let nav = arrVC.first as? UINavigationController, let vc = nav.viewControllers.first as? SpinWheelCreatorViewController {
            vc.setWheel()
            self.btnCreateWheel.sendActions(for: .touchUpInside)
        }
        
    }
    
    func onRelaunch(spinItem: [SpinItem], setting: SpinSetting) {
        self.setting = setting
        
        //gradient colors....
        let slices : [Slice] = spinItem.map { spinItem in
           let colors = spinItem.colorHex?.components(separatedBy: ",")
           if colors?.count ?? 0 > 1 {
               var gradientColors = [UIColor]()
               colors?.forEach({ color in
                   gradientColors.append(UIColor.hexStringToUIColor(hex: String(color)))
               })
               return Slice(contents: spinItem.sliceContentTypes(withLine: true), backgroundColor: nil, backgroundColors: gradientColors)
           }else {
               return Slice(contents: spinItem.sliceContentTypes(withLine: true), backgroundColor: UIColor.hexStringToUIColor(hex: spinItem.colorHex!))
           }
         
       }
        self.performSegue(withIdentifier: "SpinToLaunch", sender: slices)
    }
}

extension CreateSpinViewController: EditItemDelegate {
    func onEditItem(item: SpinItem) {
        if let controller = arrVC[0] as? UINavigationController{
            if let topViewController = controller.topViewController as? SpinWheelCreatorViewController {
                topViewController.updateItem(item: item)
            }
        }
    }
}

extension CreateSpinViewController: SpinWheelCreatorSelectItemDelegate {
    func onItemSelection(item: SpinItem) {
        self.performSegue(withIdentifier: "EditGame", sender: item)
    }
    func onDone(item: [Slice]) {
        self.performSegue(withIdentifier: "SpinToLaunch", sender: item)
    }
}

extension CreateSpinViewController: SpinSettingDelegate {
    func onSettingChange(setting: SpinSetting , needToUpdate : Bool = true) {
        self.setting = setting
        
        
        if UserDefaults.standard.integer(forKey: "gameId") > 0 && needToUpdate{
            let gameId = UserDefaults.standard.integer(forKey: "gameId")
            
            let params : [String : Any] = [
                
                "isViewerSpin": (setting.canViewerSpin == true) ? 1 : 0,
                "spinLimit": setting.limit!,
                "coins": "\(setting.cost!)",
                "game_id": "\(gameId)"
            ]
            
            print("Updated Setting params : \(params)")
            
            NetworkClient.shared.updateSetting(showAlert: true, params: params, vc: self) { (success,message, result) -> (Void) in
                
                if success ?? false{
                  UserDefaults.standard.set(try? JSONEncoder().encode(self.setting), forKey: "temp_spinItem_setting")
                }
            }
        }else {
            UserDefaults.standard.set(try? JSONEncoder().encode(self.setting), forKey: "temp_spinItem_setting")
        }
    }
}
