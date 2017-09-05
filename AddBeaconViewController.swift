import UIKit
import Eureka

protocol AddBeacon {
    func addBeacon(item: Beacon)
}

class AddBeaconViewController: FormViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var delegate: AddBeacon?
    let allIcons = Icon.allIcons
    var icon = Icon.customItem
    
    
    var isValid: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupForm()
        /*
        var isNameValid: (String) -> (Bool) = { name in
            return (name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count) > 0
        }
        */
        
       
    }
    
    func setupForm() {
        
        var isNameValid: Bool = false
        var isUuidValid: Bool = false
        

        
        form +++ Section("Section 1")
            <<< TextRow(){ nameRow in
                nameRow.title = "Name"
                nameRow.placeholder = "My Beacon"
                nameRow.tag = "nameRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
                
                }.onChange{ nameRow in
                    isNameValid = self.checkNameIsValid(name: nameRow.value!)
                    self.addButton.isEnabled = (isNameValid && isUuidValid)
            }
            
            
            <<< PhoneRow(){ uuid in
                uuid.title = "Phone Row"
                uuid.placeholder = "12345678-12ab-34cd-56ef-123456789abc"
                uuid.tag = "uuidTag"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
                    
                }.onChange{ uuid in
                    isUuidValid = self.checkUUIDValid(UUID: uuid.value!)
                    self.addButton.isEnabled = (isNameValid && isUuidValid)
        }
        
        
 
    }
    
    func checkNameIsValid(name: String) -> Bool {
        return (name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count) > 0
    }

    
    func checkUUIDValid(UUID: String) -> Bool {
        let uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
        
        let uuidString = UUID.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if uuidString.characters.count > 0 {
            return uuidRegex.numberOfMatches(in: uuidString, options: [], range: NSMakeRange(0, uuidString.characters.count)) > 0
        }
        
        return false
    }
    

    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }

}
    


/*
extension AddBeaconViewController: UICollectionViewDelegate {
    
}

extension AddBeaconViewController: UICollectionViewDataSource {
    
}
*/
