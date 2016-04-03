module DE.TextBuffer;

import DE.Data;
import DE.Engine;
import DE.Style;

class Textbuffer {
public:
	this(Engine engine) {
		this.engine = engine;
	}

	void WriteString(dstring str) {
		foreach (ch; str)
			AddChar(ch);
	}

	void AddChar(dchar ch) {
		while (cursor.y >= data.length)
			data ~= "";

		if (ch == '\b') {
			dstring* line = &data[cursor.y];
			
			if (cursor.x < line.length)
				*line = (*line)[0 .. cursor.x] ~ (*line)[cursor.x .. $];
			else
				*line = (*line)[0 .. $ - 1];
		  cursor.x--;
		} else if (ch == '\n') {
			cursor.x = 0;
			cursor.y++;
		} else {
			dstring* line = &data[cursor.y];
			if (cursor.x < line.length)
				*line = (*line)[0 .. cursor.x] ~ ch ~ (*line)[cursor.x .. $];
			else
				*line ~= ch;
			cursor.x++;
		}
	}

	void Draw() {
		Vec2 pos;

		engine.Move(pos);
		foreach (line; data) {
			foreach (ch; line) {
				engine.Write(ch);
				pos.x++;
				
				engine.Color = Styles.Default;

				if (pos.x >= engine.Width) {
					pos.x = 0;
					pos.y++;
					engine.Color = Styles.LineWrapped;
				}
			}
			pos.x = 0;
			pos.y++;
		}
		
		engine.Move(cursor);
	}

	void Move(Vec2 dif) {
		import std.algorithm;
		cursor += dif;
		cursor.y = cursor.y.min(data.length - 1).max(0);
		cursor.x = cursor.x.min(data[cursor.y].length).max(0);
	}

private:
	Engine engine;
	dstring[] data;
	Vec2 cursor;
	Vec2 viewport;

	// On key press and viewport.contains(cursor) → viewport = cursor;
	// Text will be written to cursor pos;
}
