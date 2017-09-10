import UIKit
import Eureka

protocol AddItem {
    func addItem(item: Item)
}

class AddBeaconViewController: FormViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var delegate: AddItem?
    let allIcons = Icon.allIcons
    var icon = Icon.customItem
    
    var isValid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configForm()
    }
    
    func configForm() {
        
        var isNameValid: Bool = false
        var isUuidValid: Bool = false
        
        form +++ Section("Section 1")
            <<< TextRow(){ nameRow in
                nameRow.title = "Name"
                nameRow.placeholder = "My Beacon"
                nameRow.tag = "nameRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                    //cell.textField.delegate = self
                }.onChange{ nameRow in
                    isNameValid = self.checkNameIsValid(name: (nameRow.value ?? ""))
                    self.addButton.isEnabled = (isNameValid && isUuidValid)
            }
            
            <<< TextRow(){ uuid in
                uuid.title = "UUID"
                uuid.placeholder = "12345678-12ab-34cd-56ef-123456789abc"
                uuid.tag = "uuidRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                    cell.textField.delegate = self
                }.onChange{ uuid in
                    isUuidValid = self.checkUUIDValid(UUID: (uuid.value ?? ""))
                    uuid.cell.textField.textColor = (isUuidValid) ? .black : .red
                    self.addButton.isEnabled = (isNameValid && isUuidValid)
                }
        
            // CHECK INPUT FOR MAJOR & MINOR
            
            <<< IntRow(){ majorRow in
                majorRow.title = "Major"
                majorRow.placeholder = "12345"
                majorRow.tag = "majorRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
        
            <<< IntRow(){ minorRow in
                minorRow.title = "Minor"
                minorRow.placeholder = "12345"
                minorRow.tag = "minorRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
    }
    
    func checkNameIsValid(name: String) -> Bool {
        return (name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count) > 0
    }
    
    // Use regular expression to make sure user has correct format for UUID
    func checkUUIDValid(UUID: String) -> Bool {
        let uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
        
        let uuidString = UUID.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if uuidString.characters.count > 0 {
            return uuidRegex.numberOfMatches(in: uuidString, options: [], range: NSMakeRange(0, uuidString.characters.count)) > 0
        }
        
        return false
    }
    
    // Remove Eureka toolbar
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let nameString = (form.rowBy(tag: "nameRow") as? TextRow)!.value!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let uuidString = (form.rowBy(tag: "uuidRow") as? TextRow)!.value!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        guard let uuid = UUID(uuidString: uuidString) else {
            print("error getting UUID")
            return
        }
        
        let major = (form.rowBy(tag: "majorRow") as? IntRow)?.value ?? 0
        let minor = (form.rowBy(tag: "minorRow") as? IntRow)?.value ?? 0

        //Create a new beacon object
        let newItem = Item(name: nameString, icon: icon.rawValue, uuid: uuid, majorValue: major, minorValue: minor)
        
        delegate?.addItem(item: newItem)
        navigationController?.popViewController(animated: true)
    }
}

extension AddBeaconViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let uuidTextField: UITextField = (form.rowBy(tag: "uuidRow") as? TextRow)!.cell.textField
        
        // Automatically inserts hyphens in text field
        if textField == uuidTextField {
            if range.location == 36 {
                return false
            }
            
            var strText: String? = textField.text
            
            if strText == nil {
                strText = ""
            }
        
            // NEED TO DELETE - IF USER GOING BACKWARDS
            strText = strText?.replacingOccurrences(of: "-", with:"")
            if strText!.characters.count > 1  && string != ""
                && (strText!.characters.count == 8 || strText!.characters.count == 12
                    || strText!.characters.count == 16 || strText!.characters.count == 20
                        || strText!.characters.count == 32) {
              
                textField.text = "\(textField.text!)-\(string)"
                return false
            }
            // Limit to 36 characters, including the hyphens
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 36
        }
        
        //MARK:- TODO
        //if textField == (majorTextField || minorTextField) {
                // MAKE SURE doesnt exceed UINT
        //}
        
        return true
    }
}
    

