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
		while (cursor.y >= lines.length)
			lines ~= "";

		if (ch == '\b') {
			dstring* line = &lines[cursor.y];

			if (cursor.x < line.length)
				*line = (*line)[0 .. cursor.x] ~ (*line)[cursor.x .. $];
			else
				*line = (*line)[0 .. $ - 1];
			cursor.x--;
		} else if (ch == '\n') {
			cursor.x = 0;
			cursor.y++;
			lines = lines[0 .. cursor.y] ~ "" ~ lines[cursor.y .. $];
		} else {
			dstring* line = &lines[cursor.y];
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
		foreach (line; lines) {
			foreach (ch; line) {
				engine.Write(ch);
				pos.x++;

				engine.Color = Styles.Default;

				if (pos.x >= engine.Width) {
					pos.x = 0;
					pos.y++;
					engine.Move(pos);
					engine.Color = Styles.LineWrapped;
				}
			}
			pos.x = 0;
			pos.y++;
			engine.Move(pos);
		}

		engine.Move(cursor);
	}

	void Move(Vec2 dif) {
		import std.algorithm;

		cursor += dif;
		cursor.y = cursor.y.min(lines.length - 1).max(0);
		cursor.x = cursor.x.min(lines[cursor.y].length).max(0);
	}

private:
	Engine engine;
	dstring[] lines;
	Vec2 cursor;
	Vec2 viewport;

	// On key press and viewport.contains(cursor) → viewport = cursor;
	// Text will be written to cursor pos;
}