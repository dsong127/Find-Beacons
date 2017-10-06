import UIKit
import Eureka


class AddBeaconViewController: FormViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var delegate: AddItem?
    let allIcons = Icon.allIcons
    var icon = Icon.customItem
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configForm()
    }
    
    func configForm() {
        
        var isNameValid: Bool = false
        var isUuidValid: Bool = false
        var isMajorValid: Bool = false
        var isMinorValid: Bool = false
        
        form +++ Section()
            <<< TextRow(){ nameRow in
                nameRow.title = "Name"
                nameRow.placeholder = "My Beacon"
                nameRow.tag = "nameRow"
                nameRow.cell.textField.autocorrectionType = .no

                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                    //cell.textField.delegate = self
                }.onChange{ nameRow in
                    isNameValid = self.checkNotEmpty(name: (nameRow.value ?? ""))
                    self.addButton.isEnabled = (isNameValid && isUuidValid && isMajorValid && isMinorValid)
            }
            
            <<< TextRow(){ uuid in
                uuid.title = "UUID"
                uuid.placeholder = "12345678-12ab-34cd-56ef-123456789abc"
                uuid.tag = "uuidRow"
                uuid.cell.textField.autocapitalizationType = .allCharacters
                uuid.cell.textField.autocorrectionType = .no
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }.onChange{ uuid in
                    isUuidValid = self.checkUUIDValid(UUID: (uuid.value ?? ""))
                    uuid.cell.textField.textColor = (isUuidValid) ? .black : .red
                    self.addButton.isEnabled = (isNameValid && isUuidValid && isMajorValid && isMinorValid)
                }
            
            <<< TextRow(){ majorRow in
                majorRow.title = "Major"
                majorRow.placeholder = "12345"
                majorRow.tag = "majorRow"
                majorRow.cell.textField.keyboardType = .numberPad
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }.onChange{ major in
                    isMajorValid = self.checkNotEmpty(name: major.value ?? "")
                    self.addButton.isEnabled = (isNameValid && isUuidValid && isMajorValid && isMinorValid)
                }
        
            <<< TextRow(){ minorRow in
                minorRow.title = "Minor"
                minorRow.placeholder = "12345"
                minorRow.tag = "minorRow"
                minorRow.cell.textField.keyboardType = .numberPad
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }.onChange{ minor in
                    isMinorValid = self.checkNotEmpty(name: minor.value ?? "")
                    self.addButton.isEnabled = (isNameValid && isUuidValid && isMajorValid && isMinorValid)
                }
            /*
        +++ Section("ViewRow Demo")
            <<< ViewRow<MyView>("view") { (row) in
                row.title = "My View Title" // optional
                }
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = MyView()
                    cell.view?.backgroundColor = UIColor.orange
                    cell.contentView.addSubview(cell.view!)
                    
                    //  Define the cell's height
                    cell.height = { return CGFloat(200) }
        }
        
        */
        
        
        //Set textfield delegate to self
        let rows = (form.allRows as! [TextRow])
        for row in rows {
            row.cellUpdate{ cell, row in
                row.cell.textField.delegate = self
            }
        }
    }

    func checkNotEmpty(name: String) -> Bool {
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
        
        let major = Int((form.rowBy(tag: "majorRow") as? TextRow)?.value ?? "0")!
        let minor = Int((form.rowBy(tag: "minorRow") as? TextRow)?.value ?? "0")!
        
        let enabled = true

        //Create a new beacon object
        let newItem = Item(name: nameString, icon: icon.rawValue, uuid: uuid, majorValue: major, minorValue: minor, enabled: enabled)
        
        delegate?.addItem(item: newItem)
        navigationController?.popViewController(animated: true)
    }
}

extension AddBeaconViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let majorTextField: UITextField = (form.rowBy(tag: "majorRow") as? TextRow)!.cell.textField
        let minorTextField: UITextField = (form.rowBy(tag: "minorRow") as? TextRow)!.cell.textField
        let uuidTextField: UITextField = (form.rowBy(tag: "uuidRow") as? TextRow)!.cell.textField
        
        
        if (textField == majorTextField || textField == minorTextField) {
            guard let text = textField.text else {
                return true
            }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 5
        }
        
    
        if textField == uuidTextField {
        /*
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
            }*/
 
         // Limit to 36 characters, including the hyphens
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 36
         }

        return true
    }
 
}


