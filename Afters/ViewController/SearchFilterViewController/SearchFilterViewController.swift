//
//  SearchFilterViewController.swift
//  Afters
//
//  Created by C332268 on 20/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var filterValue = FilterSelectionValue()
    private var sections = [Section]()
    private let musicList = HostPartyHelper.musicList()
    private let ageList = HostPartyHelper.ageList()
    private let musicPickerView = UIPickerView()
    private let agePickerView = UIPickerView()
    public var delegate: SearchFilterDelegate?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.sections = [
            Section(name: "Date", items: ["MacBook"]),
            Section(name: "Radius", items: ["iPad Pro"]),
            Section(name: "Age", items: ["iPhone 6s"]),
            Section(name: "Music Genre", items: ["iPhone 6s"]),
            Section(name: "Music Genre", items: ["iPhone 6s"])
        ]
        
        if let data = UserDefaults.standard.object(forKey: "SelectedFilterValue") as? NSData {
            filterValue = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! FilterSelectionValue
        }
        musicPickerView.delegate = self
        musicPickerView.dataSource = self
        agePickerView.dataSource = self
        agePickerView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
    
// MARK: - Local Function
extension SearchFilterViewController {
    
    @objc private func handleToDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        filterValue.partyDate = sender.date
        filterValue.partyDateString = sender.date.stringFromDate()
        let headerView  = self.tableView.viewWithTag(999) as! FilterHeaderCell
        headerView.selectedValue.text = filterValue.partyDate.newStringFromDate() + " selected"
        let indexPath = IndexPath(row: 0, section: 0)
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                let cell = self.tableView.cellForRow(at: indexPath) as! FilterSelectDateCell
                cell.dateTextField.text = filterValue.partyDate.newStringFromDate()
            }
        }
        //        self.tableView.reloadData()
    }
    
    private func saveFilterValue(_ filterInfo : FilterSelectionValue){
        let data  = NSKeyedArchiver.archivedData(withRootObject: filterInfo)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey:"SelectedFilterValue" )
    }
}

// MARK: - IBAction
extension SearchFilterViewController {
    
    @IBAction func resetFilterButtonClicked(_ sender : UIButton){
        self.saveFilterValue(FilterSelectionValue())
        self.delegate?.refreshSearchFilter()
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(true)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @IBAction func sliderValueChange(_ sender: AnyObject) {
        let slider = sender as! UISlider
        filterValue.radius = Int(slider.value)
        let headerView  = self.tableView.viewWithTag(111) as! FilterHeaderCell
        headerView.selectedValue.text = String(filterValue.radius) + " -Distance in km."
    }
    
    @IBAction func showResultButtonClicked(_ sender : UIButton){
        self.saveFilterValue(filterValue)
        self.delegate?.refreshSearchFilter()
        let tabBarController : TabBarController = self.tabBarController as! TabBarController
        tabBarController.canShowRightBarButton(true)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SearchFilterViewController:UITableViewDelegate, UITableViewDataSource {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell : FilterSelectDateCell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectDateCell", for: indexPath) as!
            FilterSelectDateCell
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            datePickerView.addTarget(self, action: #selector(HostViewController.handleToDatePicker(_:)), for:UIControl.Event.valueChanged)
            cell.dateTextField.text = filterValue.partyDateString
            cell.dateTextField.inputView = datePickerView
            cell.dateTextField.tag = 0
            return cell
        case 1:
            let cell : FilterSelectRediusCell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectRediusCell", for: indexPath) as! FilterSelectRediusCell
            return cell
        case 2:
            let cell : FilterSelectAgeAndMusicCell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectAgeAndMusicCell", for: indexPath) as! FilterSelectAgeAndMusicCell
            cell.textField.text = filterValue.age
            cell.textField.inputView = self.agePickerView
            cell.textField.tag = 2
            return cell
        case 3:
            let cell : FilterSelectAgeAndMusicCell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectAgeAndMusicCell", for: indexPath) as! FilterSelectAgeAndMusicCell
            cell.textField.text = filterValue.music
            cell.textField.inputView = self.musicPickerView
            cell.textField.tag = 3
            return cell
        default:
            let cell : FilterButtonCell = tableView.dequeueReusableCell(withIdentifier: "FilterButtonCell", for: indexPath) as! FilterButtonCell
            return cell
        }
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell : FilterHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCell") as! FilterHeaderCell
        cell.tag = 111*section
        let sectionInfo = sections[section]
        cell.arrowLabel.isHidden = false
        cell.delegate = self
        cell.titleLabel.text = sectionInfo.name
        cell.contentView.backgroundColor = UIColor.white
        cell.selectedValue.text = ""
        switch section {
        case 0:
            if filterValue.partyDateString == ""{
                cell.selectedValue.text = filterValue.partyDateString + "No date selected"
            }else{
                cell.selectedValue.text = filterValue.partyDateString + " selected"
            }
            cell.tag = 111*9
        case 1:
            cell.selectedValue.text = String(filterValue.radius) + "- Distance in km."
            
        case 2:
            if filterValue.age == "0"{
                cell.selectedValue.text = "No age selected"
            }else{
                cell.selectedValue.text = filterValue.age + " age selected"
            }
        case 3:
            if filterValue.music == ""{
                cell.selectedValue.text = "No music selected"
            }else{
                cell.selectedValue.text = filterValue.music + " music selected"
            }
        case 4:
            cell.selectedValue.text = filterValue.partyDateString
            cell.arrowLabel.isHidden = true
            
        default:
            cell.selectedValue.text = filterValue.partyDateString
        }
        cell.setCollapsed(sections[section].collapsed)
        cell.section = section
        return cell
    }
    
    internal  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 4{
            return 10.0
        }
        return 60.0
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return UITableView.automaticDimension
        }
        return sections[(indexPath as NSIndexPath).section].collapsed! ? 0 : UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return UITableView.automaticDimension
        }
        return sections[(indexPath as NSIndexPath).section].collapsed! ? 0 : UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: - UIPickerViewDelegate And Data Source Methods
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch pickerView {
        case musicPickerView :
            return (musicList?.count)!
        default:
            return (ageList?.count)!
        }
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch pickerView {
        case musicPickerView :
            return musicList?[row]
        default:
            return ageList?[row]
        }
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView {
        case musicPickerView :
            filterValue.music = (musicList?[row])!
            let headerView  = self.tableView.viewWithTag(333) as! FilterHeaderCell
            headerView.selectedValue.text = filterValue.music + " music selected"
            let indexPath = IndexPath(row: 0, section: 3)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                if visibleIndexPaths != NSNotFound {
                    let cell = self.tableView.cellForRow(at: indexPath) as! FilterSelectAgeAndMusicCell
                    cell.textField.text = filterValue.music
                }
            }
        default:
            filterValue.age = (ageList?[row])!
            let headerView  = self.tableView.viewWithTag(222) as! FilterHeaderCell
            headerView.selectedValue.text = filterValue.age + " age selected"
            
            let indexPath = IndexPath(row: 0, section: 2)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                if visibleIndexPaths != NSNotFound {
                    
                    let cell = self.tableView.cellForRow(at: indexPath) as! FilterSelectAgeAndMusicCell
                    cell.textField.text = filterValue.age
                }
            }
        }
        //        self.tableView.reloadData()
    }
}

// MARK: - Section Header Delegate
extension SearchFilterViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: FilterHeaderCell, section: Int) {
        let collapsed = !sections[section].collapsed
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        self.tableView.reloadData()
        // Adjust the height of the rows inside the section
        //        tableView.beginUpdates()
        //        for i in 0 ..< sections[section].items.count {
        
        //            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        //        }
        //        tableView.endUpdates()
    }
    
}

