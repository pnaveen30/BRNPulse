//
//  ViewController.swift
//  menuSlider
//
//  Created by Naveen on 1/22/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var loadActiveIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var attendanceTV: UITableView!
    var slideMenu : menuSlider!
    var reqURL:URLRequest?
    var sessionURL : URLSession?
    var dataTask : URLSessionDataTask?
    var allStore = [Any]()
    var some = true
    var attendanceSumDetails : Array< String > = Array < String >()
    let subMArr = ["Total Days","Working Days","Leaves","Absents","Days Attend","Updates Sent","Working Hours","Worked Hours","Overall Spent Summary","Worked Per day(Avg.Hrs)","Shortage Per day(Avg.Hrs)","Late to Office","Minimum Hrs Missed","Max Points","Points Earned","Your Performance Score"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slideMenu = self.storyboard?.instantiateViewController(withIdentifier: "menuSlider") as! menuSlider
        self.loadAttendanceDetails()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureMethod(sender:)))
        self.view.addGestureRecognizer(panGesture)
        self.loadActiveIndicator.isHidden = false
        self.loadActiveIndicator.startAnimating()
        //self.tableViewElements()
        }
    
    func tableViewElements(){
        
        self.attendanceTV?.delegate = self
        self.attendanceTV?.dataSource = self
        let attendanceCellxib = UINib(nibName: "AttendanceCell", bundle: nil)
        attendanceTV.register(attendanceCellxib, forCellReuseIdentifier: "abc")
        self.attendanceTV.reloadData()
    }
    
    func panGestureMethod(sender: UIPanGestureRecognizer){
        
        let velocity = sender.velocity(in: self.view)
        
        if velocity.x > 0{
            
            print("right swipt")
            openMenu()
        }else{
            print("Left swipt")
            closeMenu()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonTapEvent(_ sender: UIBarButtonItem) {
        
        if some == true{
            
            openMenu()
            
        }else if some == false{
            closeMenu()
            
        }
        
    }
    
    func openMenu(){
        
        UIView.animate(withDuration: 1) { ()->Void in
            
            self.slideMenu?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            //           self.view.frame = CGRect(x: (self.slideMenu?.view.frame.size.width)!-50, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            
            self.some = false
            //self.addChildViewController(slideMenu!)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.view.addSubview(self.slideMenu!.view)
            self.view.bringSubview(toFront: self.slideMenu!.view)
            
            
        }
        
    }
    func closeMenu(){
        
        UIView.animate(withDuration: 1, animations: { ()->Void in
            
            self.slideMenu?.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            // self.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }) {(finished) in
            self.slideMenu.view.removeFromSuperview()
            
        }
        
        
        //        ///
        //        UIView.animate(withDuration: 0.3,animation { ()->Void in
        //
        //            self.slideMenu?.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        //            self.slideMenu.view.removeFromSuperview()
        //
        //
        //        }
        self.some = true
    }
    

    @IBAction func swipeRight(_ sender: Any) {
        
        openMenu()
    }
    
    
    @IBAction func swipeLeft(_ sender: Any) {
        
        closeMenu()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subMArr.count
        
    }
    
    
    
    
    func loadAttendanceDetails(){
        
        let add = "http://www.brninfotech.com/pulse/modules/admin/DashboardSnippets.php"
        sessionURL = URLSession(configuration: URLSessionConfiguration.default)
        reqURL = URLRequest(url: URL(string: add)!)
        
        reqURL?.httpMethod = "POST"
        
       
        
        let dataToServer = "funcName=getUserAttendance&studentIDByAdmin=NoValue"
        reqURL?.httpBody = dataToServer.data(using: .utf8)
        dataTask = sessionURL?.dataTask(with: reqURL!, completionHandler: { (data, response, error) in
            print(data!)
            do{
                let dataResult = try JSONSerialization.jsonObject(with: data!, options:[])
                //print("FromDataStore \(dataResult)")
                // self.allStore = dataResult as! [String : String]
               let dStore = dataResult as! [Any]
                //print(dataResult["totalWorkingDays"])
                self.allStore = dataResult as! [Any]
                let dicStoreAttendance:Dictionary = dStore[0] as![String:Any]
                var someWhileStore = dStore
                someWhileStore.remove(at: 0)
                
                ForAttendanceStore.fullAttendanceDetails = someWhileStore.reversed()
                let some1:[String:Any] = dStore[1] as! [String : Any]
                
                print("All Keys:----->>>>\(some1.keys)")
                
                print("from dictionary\(String(describing: dicStoreAttendance["totalDays"]))")

                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalDays"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalWorkingDays"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalLeaves"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalAbsents"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalDaysAttended"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalUpdatesSent"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalWorkingHours"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["totalWorkedHours"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["avgWorkingHours"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["avgWorkingHours"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["avgShortageHours"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["numberOfTimesLateToOffice"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["numberOfTimesMinimumHoursMissed"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["maxPoints"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["pointsScored"]!))
                self.attendanceSumDetails.append(String(describing: dicStoreAttendance["percScored"]!))
                
               ForAttendanceStore.attendanceDict = dStore[170] as! [String : Any]
            
                ForAttendanceStore.attendanceSummaryDetailsArr = self.attendanceSumDetails
                print(self.attendanceSumDetails)
                
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["attendanceDayCount"]!)
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["attendanceDay"]!)
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["checkIn"]!)
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["checkOut"]!)
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["timeSpent"]!)
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["shortageExcessTime"]!)
                ForAttendanceStore.valueStoreArr.append(ForAttendanceStore.attendanceDict["totalPoints"]!)
                
                }catch{
                
                print("Something gone wrong")
            }
            DispatchQueue.main.async {
                
                self.attendanceTV.reloadData()
                self.loadActiveIndicator.isHidden = true
                self.loadActiveIndicator.stopAnimating()
            }
        })
        
        dataTask?.resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 65.00
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "abc", for: indexPath) as! AttendanceCell
        
        cell.frame.size.width = UIScreen.main.bounds.size.width
        cell.subMenuLabel?.text = self.subMArr[indexPath.row]
        if self.attendanceSumDetails.count == 0{
            
            print("Loading Please Wait.....")
        }else{
        cell.dataFromSerLBL?.text = self.attendanceSumDetails[indexPath.row]
        }
        print("For Atten Class Store\(self.attendanceSumDetails)")
        print("sM.count\(self.subMArr.count)")
        
        
        return cell
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let lateThread = DispatchQueue(label: "late",qos: .utility)
        lateThread.async {
            
            self.tableViewElements()
        }
        
        //print("For Atten Class Store\(ForAttendanceStore.attendanceSummaryDetailsArr)")
    }
    
    func do_table_refresh()
    {
        DispatchQueue.main.async {
            self.attendanceTV.reloadData()
            
        }
    }
    
    
}

