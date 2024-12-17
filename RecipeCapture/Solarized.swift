//
//  Solarized.swift
//  RecipeCapture
//
//  This file defines a Solarized theme structure with the entire Solarized palette.
//  We have full sets of base and accent colors. The structure automatically returns
//  colors from either the "light" or "dark" palette depending on @AppStorage("isDarkMode").
//
//  Each color is stored under its technical name (e.g., "base03", "yellow") as keys.
//  The human-readable name with underscores is the same as the technical name for simplicity.
//
//  Usage Example:
//    let bgColor = sol.base3   // Automatically returns light or dark version based on isDarkMode
//
//  The Solarized palette (hex and RGB):
//  base03:  #002b36 (0,43,54)
//  base02:  #073642 (7,54,66)
//  base01:  #586e75 (88,110,117)
//  base00:  #657b83 (101,123,131)
//  base0:   #839496 (131,148,150)
//  base1:   #93a1a1 (147,161,161)
//  base2:   #eee8d5 (238,232,213)
//  base3:   #fdf6e3 (253,246,227)
//  yellow:  #b58900 (181,137,0)
//  orange:  #cb4b16 (203,75,22)
//  red:     #dc322f (220,50,47)
//  magenta: #d33682 (211,54,130)
//  violet:  #6c71c4 (108,113,196)
//  blue:    #268bd2 (38,139,210)
//  cyan:    #2aa198 (42,161,152)
//  green:   #859900 (133,153,0)
//
//  In the canonical Solarized scheme, the hex values are stable. However, you can assign
//  different roles to these colors depending on the mode. Here, we provide identical hex
//  codes for both light and dark palettes. If desired, you can tweak them per mode later.
//

import SwiftUI

struct Solarized {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    private let lightPalette: [String: Color] = [
        "base03": Color(red: 0x00/255, green: 0x2b/255, blue: 0x36/255),
        "base02": Color(red: 0x07/255, green: 0x36/255, blue: 0x42/255),
        "base01": Color(red: 0x58/255, green: 0x6e/255, blue: 0x75/255),
        "base00": Color(red: 0x65/255, green: 0x7b/255, blue: 0x83/255),
        "base0":  Color(red: 0x83/255, green: 0x94/255, blue: 0x96/255),
        "base1":  Color(red: 0x93/255, green: 0xa1/255, blue: 0xa1/255),
        "base2":  Color(red: 0xee/255, green: 0xe8/255, blue: 0xd5/255),
        "base3":  Color(red: 0xfd/255, green: 0xf6/255, blue: 0xe3/255),
        "yellow": Color(red: 0xb5/255, green: 0x89/255, blue: 0x00/255),
        "orange": Color(red: 0xcb/255, green: 0x4b/255, blue: 0x16/255),
        "red":    Color(red: 0xdc/255, green: 0x32/255, blue: 0x2f/255),
        "magenta":Color(red: 0xd3/255, green: 0x36/255, blue: 0x82/255),
        "violet": Color(red: 0x6c/255, green: 0x71/255, blue: 0xc4/255),
        "blue":   Color(red: 0x26/255, green: 0x8b/255, blue: 0xd2/255),
        "cyan":   Color(red: 0x2a/255, green: 0xa1/255, blue: 0x98/255),
        "green":  Color(red: 0x85/255, green: 0x99/255, blue: 0x00/255),
    ]

    private let darkPalette: [String: Color] = [
        "base03": Color(red: 0x00/255, green: 0x2b/255, blue: 0x36/255),
        "base02": Color(red: 0x07/255, green: 0x36/255, blue: 0x42/255),
        "base01": Color(red: 0x58/255, green: 0x6e/255, blue: 0x75/255),
        "base00": Color(red: 0x65/255, green: 0x7b/255, blue: 0x83/255),
        "base0":  Color(red: 0x83/255, green: 0x94/255, blue: 0x96/255),
        "base1":  Color(red: 0x93/255, green: 0xa1/255, blue: 0xa1/255),
        "base2":  Color(red: 0xee/255, green: 0xe8/255, blue: 0xd5/255),
        "base3":  Color(red: 0xfd/255, green: 0xf6/255, blue: 0xe3/255),
        "yellow": Color(red: 0xb5/255, green: 0x89/255, blue: 0x00/255),
        "orange": Color(red: 0xcb/255, green: 0x4b/255, blue: 0x16/255),
        "red":    Color(red: 0xdc/255, green: 0x32/255, blue: 0x2f/255),
        "magenta":Color(red: 0xd3/255, green: 0x36/255, blue: 0x82/255),
        "violet": Color(red: 0x6c/255, green: 0x71/255, blue: 0xc4/255),
        "blue":   Color(red: 0x26/255, green: 0x8b/255, blue: 0xd2/255),
        "cyan":   Color(red: 0x2a/255, green: 0xa1/255, blue: 0x98/255),
        "green":  Color(red: 0x85/255, green: 0x99/255, blue: 0x00/255),
    ]

    private var palette: [String: Color] {
        isDarkMode ? darkPalette : lightPalette
    }

    var base03: Color    { palette["base03"]! }
    var base02: Color    { palette["base02"]! }
    var base01: Color    { palette["base01"]! }
    var base00: Color    { palette["base00"]! }
    var base0:  Color    { palette["base0"]! }
    var base1:  Color    { palette["base1"]! }
    var base2:  Color    { palette["base2"]! }
    var base3:  Color    { palette["base3"]! }

    var primary_text: Color { palette["base0"]! }
    var highlight_bg: Color { palette["base2"]! }

    var yellow: Color    { palette["yellow"]! }
    var orange: Color    { palette["orange"]! }
    var red: Color       { palette["red"]! }
    var magenta: Color   { palette["magenta"]! }
    var violet: Color    { palette["violet"]! }
    var blue: Color      { palette["blue"]! }
    var cyan: Color      { palette["cyan"]! }
    var green: Color     { palette["green"]! }
}

// Global instance for convenience
let sol = Solarized()
