

import Foundation

class BottomSheetViewModel {
    let options: [String]
    var selectedIndex: Int?
    var title: String?
    
    init(options: [String], selectedIndex: Int? = nil, title: String? = nil) {
        self.options = options
        self.selectedIndex = selectedIndex
        self.title = title
    }
    
    func numberOfOptions() -> Int {
        return options.count
    }
    
    func displayedText(atIndex index: Int) -> String {
        guard index >= 0, index < options.count else { return "" }
        return options[index]
    }
    
    func isOptionSelected(atIndex index: Int) -> Bool {
        guard index >= 0, index < options.count else { return false }
        return index == selectedIndex
    }
}
