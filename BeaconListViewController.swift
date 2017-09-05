import UIKit

let savedItemsKey: String = "savedItems"


class BeaconListViewController: UIViewController {

    @IBOutlet weak var beaconTableView: UITableView!
    
    //Array to hold data for the beacon list tableview
    var beacons = [Beacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        setupTableView()
        
        
    }
    
    
    func setupTableView() {
        beaconTableView.delegate = self
        beaconTableView.dataSource = self
    }
    
    func loadItems() {
        guard let savedItems = UserDefaults.standard.array(forKey: savedItemsKey) as? [Data] else { return }
        
        for itemData in savedItems {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Beacon else { continue}
            beacons.append(item)
        }
    }
    
    func saveItems() {
        var itemsData = [Data]()
        
        for beacon in beacons {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: beacon)
            itemsData.append(itemData)
        }
        
        UserDefaults.standard.set(itemsData, forKey: savedItemsKey)
        UserDefaults.standard.synchronize()
    }
    


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddBeaconSegue" {
            
            let addVC = segue.destination as? AddBeaconViewController
            addVC?.delegate = self
        }
    }
}

extension BeaconListViewController: AddBeacon {
    func addBeacon(item: Beacon) {
        beacons.append(item)
        
        beaconTableView.beginUpdates()
        let newIndexPath = IndexPath(row: beacons.count - 1, section: 0)
        beaconTableView.insertRows(at: [newIndexPath], with: .automatic)
        beaconTableView.endUpdates()
        
        saveItems()
    }
}

// MARK: - TableView Data Source

extension BeaconListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Beacon", for: indexPath)
        cell.textLabel?.text = beacons[indexPath.row].name
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            beaconTableView.beginUpdates()
            beacons.remove(at: indexPath.row)
            beaconTableView.deleteRows(at: [indexPath], with: .automatic)
            beaconTableView.endUpdates()
            
            saveItems()
        }
    }
}

//MARK: - TableView Delegate
extension BeaconListViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = beacons[indexPath.row]
        let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
        
        
        let detailAlert = UIAlertController(title: "details", message: detailMessage, preferredStyle: .alert)
        
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(detailAlert, animated: true, completion: nil)

        //performSegue(withIdentifier: "BeaconInfoSegue", sender: nil)
    }
    
    
}
