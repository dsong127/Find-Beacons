import UIKit
import CoreLocation

let savedItemsKey: String = "savedItems"

class BeaconListViewController: UIViewController {

    @IBOutlet weak var beaconTableView: UITableView!
    
    //Array to hold data for the beacon list tableview
    var items = [Item]()
    var index: IndexPath!
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        //This will display a message when user has added no item to track
        if items.isEmpty {
            displayEmptyData(message: "There are no item to show!", on: self)
        } else {
            beaconTableView.backgroundView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        loadItems()
        setupTableView()
    }
    
    private func setupTableView() {
        beaconTableView.delegate = self
        beaconTableView.dataSource = self

        beaconTableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    }
    
    func loadItems() {
        guard let savedItems = UserDefaults.standard.array(forKey: savedItemsKey) as? [Data] else { return }
        
        for itemData in savedItems {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Item else { continue}
            
            items.append(item)
            startMonitoring(item: item)
        }
    }
    
    func saveItems() {
        var itemsData = [Data]()
        
        for item in items {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
            itemsData.append(itemData)
        }
        
        UserDefaults.standard.set(itemsData, forKey: savedItemsKey)
        UserDefaults.standard.synchronize()
    }
    
    func startMonitoring(item: Item) {
        let region = item.asBeaconRegion()
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
    
    func stopMonitoring(item: Item) {
        let region = item.asBeaconRegion()
        locationManager.stopMonitoring(for: region)
        locationManager.stopRangingBeacons(in: region)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddBeaconSegue" {
            let addVC = segue.destination as? AddBeaconViewController
            addVC?.delegate = self
        }
        
        if segue.identifier == "DetailsSegue" {
            let detailsVC = segue.destination as? DetailsViewController
            detailsVC?.item = self.items[index.row]
        }
 
    }
}

extension BeaconListViewController: AddItem {
    func addItem(item: Item) {
        items.append(item)
        
        beaconTableView.beginUpdates()
        let newIndexPath = IndexPath(row: items.count - 1, section: 0)
        beaconTableView.insertRows(at: [newIndexPath], with: .automatic)
        beaconTableView.endUpdates()
        
        startMonitoring(item: item)
        saveItems()
    }
}

extension BeaconListViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoring region error: \(error.localizedDescription)")
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
        for beacon in beacons {
            for row in 0..<items.count {
                if items[row] == beacon {
                    items[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        
        // Update beacon locations of visible rows.
        if let visibleRows = beaconTableView.indexPathsForVisibleRows {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for row in rowsToUpdate {
                let cell = beaconTableView.cellForRow(at: row) as! ItemCell
                cell.refreshLocation()
            }
        }
    }
}

// MARK: - TableView Data Source

extension BeaconListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Beacon", for: indexPath) as! ItemCell
        cell.item = items[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            stopMonitoring(item: items[indexPath.row])

            beaconTableView.beginUpdates()
            items.remove(at: indexPath.row)
            beaconTableView.deleteRows(at: [indexPath], with: .automatic)
            beaconTableView.endUpdates()
            
            if items.isEmpty {
                displayEmptyData(message: "There are no item to show!", on: self)
            }
            
            saveItems()
        }
    }
}

//MARK: - TableView Delegate
extension BeaconListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        let item = items[indexPath.row]
        let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
        let detailAlert = UIAlertController(title: "details", message: detailMessage, preferredStyle: .alert)
        
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(detailAlert, animated: true, completion: nil)
*/
        self.index = indexPath
        performSegue(withIdentifier: "DetailsSegue", sender: nil)
 
       
    }
}
