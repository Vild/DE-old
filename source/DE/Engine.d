module DE.Engine;

import DE.Style;
import DE.TextBuffer;
import DE.Data;

import arsd.terminal;

class Engine {
public:
	this() {
		terminal = Terminal(ConsoleOutputType.cellular);
		terminal.setTitle("DE - <FILE>");
		Color = Styles.Default;
		terminal.clear();

		input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.raw | ConsoleInputFlags.allInputEvents);
		buf = new Textbuffer(this);
	}

	void Run() {
		while (true) {
			Color = Styles.Default;
			terminal.clear();
			buf.Draw();
			auto event = input.nextEvent();
			handleEvent(event);
			if (timeToBreak)
				break;
		}
	}

	void Write(dchar ch) {
		terminal.write(ch);
	}

	void Write(string str) {
		foreach (ch; str)
		  buf.AddChar(ch);
  }

	void Move(Vec2 pos) {
		terminal.moveTo(pos.x, pos.y);
	}

	@property void Color(Style style) {
		terminal.color(style.fg, style.bg);
	}

	@property int Width() {
		return terminal.width;
	}

private:
	Terminal terminal;
	RealTimeConsoleInput input;
	Textbuffer buf;
	bool timeToBreak = false;

	void handleEvent(InputEvent event) {
		final switch (event.type) {
		case InputEvent.Type.UserInterruptionEvent:
		case InputEvent.Type.HangupEvent:
		case InputEvent.Type.EndOfFileEvent:
			timeToBreak = true;
			break;
		case InputEvent.Type.SizeChangedEvent:
			break;
		case InputEvent.Type.KeyboardEvent:
			auto ev = event.get!(InputEvent.Type.KeyboardEvent);
			if (ev.which == KeyboardEvent.Key.UpArrow)
				buf.Move(Vec2(0, -1));
			else if (ev.which == KeyboardEvent.Key.DownArrow)
				buf.Move(Vec2(0, 1));
			else if (ev.which == KeyboardEvent.Key.LeftArrow)
				buf.Move(Vec2(-1, 0));
			else if (ev.which == KeyboardEvent.Key.RightArrow)
				buf.Move(Vec2(1, 0));
			else
				buf.AddChar(ev.which);

			break;
		case InputEvent.Type.CharacterEvent: // obsolete
		case InputEvent.Type.NonCharacterKeyEvent: // obsolete
			break;
		case InputEvent.Type.PasteEvent:
			break;
		case InputEvent.Type.MouseEvent:
			break;
		case InputEvent.Type.CustomEvent:
			break;
		}
	}
}
