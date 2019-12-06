//
//  MemeListViewController.swift
//  
//
//  Created by Chelsea Cui on 11/5/19.
//

import UIKit


class MemeListViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
    var viewModel = MemesViewModel()
    var stationName: String?
    var stationId: String?
    var sortOptions = ["Latest", "Oldest", "Popularity"]
    var sortedBy:String = "Latest"
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var station_param = ""
    var sort_param = ""
    
    @IBOutlet weak var sortButton: UIButton!
  
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
      station_param = "station_id=\(stationId!)"
      viewModel.fetchMemeData(station_param+sort_param)
      viewModel.loadMemes(viewModel.data)
      self.navigationController?.navigationBar.isHidden = false
      let cellNib = UINib(nibName: "MemeListViewCell", bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: "cell")
      tableView.estimatedRowHeight = 350
      tableView.rowHeight = UITableView.automaticDimension
      tableView.allowsSelection = false
      createPickerView()
      self.picker.isHidden = true
      self.sortButton.setTitle(sortedBy, for: .normal)
      
      

      if let staName = stationName {
        self.title = staName
      }
      
      viewModel.refresh { [unowned self] in
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  
    @IBAction func sortButtonTapped(_ sender: UIButton) {
      if self.picker.isHidden == true {
        self.picker.isHidden = false
        sender.setTitleColor(UIColor.lightGray, for: .normal)
      } else {
        self.picker.isHidden = true
        sender.setTitleColor(UIColor.black, for: .normal)
        
        // supposed to refresh START
        viewModel.fetchMemeData(station_param+sort_param)
        viewModel.loadMemes(viewModel.data)
        self.tableView.reloadData()
        // supposed to refresh END
      }
    }
  
  
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // Your code here
      return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // Your code here
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemeListViewCell
      let meme = viewModel.memes[indexPath.row]
      cell.userName!.text = meme.userName
      cell.postDate!.text = meme.postDate
      cell.e1_like!.text = String(meme.e1_like)
      cell.e2_like!.text = String(meme.e2_like)
      cell.e3_like!.text = String(meme.e3_like)
      cell.e4_like!.text = String(meme.e4_like)
      cell.id = meme.id
      cell.e1_like_count = meme.e1_like
      cell.e2_like_count = meme.e2_like
      cell.e3_like_count = meme.e3_like
      cell.e4_like_count = meme.e4_like
      
      let url = NSURL(string: meme.meme)
      let data = NSData(contentsOf : url! as URL)
      
      cell.meme!.image = UIImage(data : data as! Data)
      
      //cell.meme!.image = UIImage(named: meme.meme)
      return cell
    }
  
    // MARK: - Picker view data source
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return sortOptions.count
    }
  
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return sortOptions[row]
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      sortedBy = sortOptions[row]
      switch sortedBy {
      case "Oldest":
        sort_param = "&order_by=asc"
      case "Popularity":
        sort_param = "&order_by=like"
      default:
        sort_param = ""
      }
      self.sortButton.setTitle(sortedBy, for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 25
    }
    
    func createPickerView() {
      picker.delegate = self
      picker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 150)//view.bounds
      picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      picker.backgroundColor = UIColor.white
      view.addSubview(picker)
    }
  
//  func dismissPickerView() {
//    toolBar.sizeToFit()
//
//    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(self.doneTapped))
//
//    toolBar.setItems([doneButton], animated: false)
//    toolBar.isUserInteractionEnabled = true
//    toolBar.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 50)//view.bounds
//    view.addSubview(toolBar)
//    }
//
//    @objc func doneTapped() {
//       self.picker.isHidden = true
//       self.toolBar.isHidden = true
//    }
}
