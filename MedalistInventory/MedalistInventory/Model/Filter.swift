import Foundation

struct Filter {
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

        var id: String { rawValue }
    }

    // https://developer.apple.com/documentation/swiftui/picker
    enum Thickness: String, CaseIterable, Identifiable {
        case all = "All"
        case thickness002 = "0.02 (SHIM)"
        case thickness036 = "0.036 (20GA)"
        case thickness04 = "0.04 (SHIM)"
        case thickness048 = "0.048 (18GA)"
        case thickness005 = "0.05"
        case thickness06 = "0.06 (16GA)"
        case thickness075 = "0.075 (14GA)"
        case thickness08 = "0.08 (SHIM)"
        case thickness09 = "0.09 (13GA)"
        case thickness01 = "0.1"
        case thickness105 = "0.105 (12GA)"
        case thickness12 = "0.12 (11GA)"
        case thickness135 = "0.135 (10GA)"
        case thickness16 = "0.16 (8GA)"
        case thickness18 = "0.18 (7GA)"
        case thickness25 = "0.25"
        case thickness32 = "0.32"
        case thickness38 = "0.38"
        case thickness375 = "0.375"
        case thickness5 = "0.5"
        case thickness625 = "0.625"
        case thickness75 = "0.75"
        case thickness875 = "0.875"
        case thickness1 = "1"
        case thickness12_13 = "1/2-#13"
        case thickness34_9 = "3/4-#9"
        case thickness34_125 = "3/4-1.25"

        var id: String { rawValue }
    }

    enum SheetSize: String, CaseIterable, Identifiable {
        case all = "All"
        case fullsheet = "Fullsheets"
        case remnant = "Remnants"

        var id: String { rawValue }
    }

    enum Company: String, CaseIterable, Identifiable {
        case all = "All"
        case johnDeere = "John Deere"
        case jonnysFabShop = "Jonny's Fab Shop"
        case kramerMetalFab = "Kramer Metal Fab"
        case medalist = "Medalist"
        case mobilityWorldwide = "Mobility Worldwide"
        case northstar = "Northstar"
        case pellaCorp = "Pella Corp"
        case ringOMatic = "Ring-O-Matic"
        case sealForce = "Seal Force"
        case weiler = "Weiler"
        case misc = "Misc."
        var id: String { rawValue }
    }
}
