import UIKit
import Eureka

class DetailsViewController: FormViewController {

    var item: Item!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configForm()
    }
    
    func configForm() {
        
        form
            +++ Section("Name"){
                $0.header?.height = { 50 }
            }
            <<< LabelRow(){ nameRow in
                nameRow.value = item.name
                nameRow.tag = "nameRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
            
            +++ Section("UUID"){
                $0.header?.height = { 15 }
            }
            <<< LabelRow(){ uuid in
                uuid.value = item.uuid.uuidString
                uuid.tag = "uuidRow"
                
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
            
            // CHECK INPUT FOR MAJOR & MINOR
            +++ Section("Major"){
                $0.header?.height = { 15 }
            }
            <<< LabelRow(){ majorRow in
                majorRow.value = "\(item.majorValue)"
                majorRow.tag = "majorRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
            }
            
            +++ Section("Minor"){
                $0.header?.height = { 15 }
            }
            <<< LabelRow(){ minorRow in
                minorRow.value = "\(item.minorValue)"
                minorRow.tag = "minorRow"
                }.cellUpdate{ cell, row in
                    cell.textLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
    }
}
