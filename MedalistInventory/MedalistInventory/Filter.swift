import Foundation

struct Filter {
    var search: String
    var materialFilter = Material.all
    var thicknessFilter = Thickness.all
    var sheetSizeFilter = SheetSize.all

    //static let "defaultFilter" = Filter(search: "")

    enum Material: String, CaseIterable, Identifiable {
        case all = "All"
        case aluminum3003 = "Aluminum 3003"
        case aluminum5052 = "Aluminum 5052"
        case aluminum6061 = "Aluminum 6061"
        case aluminumdiamontreadplate = "Aluminum Diamond Tread Plate"
        case aluminumexpandedmetal = "Aluminum Expanded Metal"
        case mildsteel = "Mild Steel"
        case mildsteeldiamondtreadplate = "Mild Steel Diamond Tread Plate"
        case mildsteelexpandedmetal = "Mild Steel Expanded Metal"
        case stainlesssteel = "Stainless Steel"

        //var id: String { self.rawValue }
        var id: String { rawValue }
    }

    enum Thickness: String, CaseIterable, Identifiable {
        case all = "All"

        var id: String { rawValue }
    }

    enum SheetSize: String, CaseIterable, Identifiable {
        case all = "All"
        case fullsheet = "Fullsheets"
        case remnant = "Remnants"

        var id: String { rawValue }
    }
}
