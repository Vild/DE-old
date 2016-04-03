module DE.Style;

import arsd.terminal;

struct Style {
	Color fg;
	Color bg;
}

enum Styles : Style {
	Default = Style(Color.green, Color.black),
	LineWrapped = Style(Color.green, Color.cyan)
}