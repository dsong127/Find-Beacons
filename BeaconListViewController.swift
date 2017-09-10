import UIKit
import CoreLocation

let savedBeaconsKey: String = "savedBeacons"

class BeaconListViewController: UIViewController {

    @IBOutlet weak var beaconTableView: UITableView!
    
    //Array to hold data for the beacon list tableview
    var beacons = [Beacon]()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        loadBeacons()
        setupTableView()

    }
    
    func setupTableView() {
        beaconTableView.delegate = self
        beaconTableView.dataSource = self
    }
    
    func loadBeacons() {
        guard let savedBeacons = UserDefaults.standard.array(forKey: savedBeaconsKey) as? [Data] else { return }
        
        for beaconData in savedBeacons {
            guard let beacon = NSKeyedUnarchiver.unarchiveObject(with: beaconData) as? Beacon else { continue}
            
            beacons.append(beacon)
            
            startMonitoring(beacon: beacon)
        }
    }
    
    func saveBeacons() {
        var beaconsData = [Data]()
        
        for beacon in beacons {
            let beaconData = NSKeyedArchiver.archivedData(withRootObject: beacon)
            beaconsData.append(beaconData)
        }
        
        UserDefaults.standard.set(beaconsData, forKey: savedBeaconsKey)
        UserDefaults.standard.synchronize()
    }
    
    func startMonitoring(beacon: Beacon) {
        let region = beacon.asBeaconRegion()
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
    
    func stopMonitoring(beacon: Beacon) {
        let region = beacon.asBeaconRegion()
        locationManager.stopMonitoring(for: region)
        locationManager.stopRangingBeacons(in: region)
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
    func addBeacon(beacon: Beacon) {
        beacons.append(beacon)
        
        beaconTableView.beginUpdates()
        let newIndexPath = IndexPath(row: beacons.count - 1, section: 0)
        beaconTableView.insertRows(at: [newIndexPath], with: .automatic)
        beaconTableView.endUpdates()
        
        startMonitoring(beacon: beacon)
        saveBeacons()
    }
}

extension BeaconListViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoring region error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
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
            
            stopMonitoring(beacon: beacons[indexPath.row])

            beaconTableView.beginUpdates()
            beacons.remove(at: indexPath.row)
            beaconTableView.deleteRows(at: [indexPath], with: .automatic)
            beaconTableView.endUpdates()
            
            saveBeacons()
        }
    }
}

//MARK: - TableView Delegate
extension BeaconListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        let beacon = beacons[indexPath.row]
        let detailMessage = "UUID: \(beacon.uuid.uuidString)\nMajor: \(beacon.majorValue)\nMinor: \(beacon.minorValue)"
        let detailAlert = UIAlertController(title: "details", message: detailMessage, preferredStyle: .alert)
        
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(detailAlert, animated: true, completion: nil)

        //performSegue(withIdentifier: "BeaconInfoSegue", sender: nil)
    }
}
