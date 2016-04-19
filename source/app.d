import DE.Engine;

int main(string[] args) {
	string startText;
	if (args.length == 2) {
		import std.file;

		try {
			startText = readText(args[1]);
		}
		catch (FileException e) {
			import std.stdio : stderr;

			stderr.writeln("File error: ", e.msg);
			return -1;
		}
	}
	Engine engine = new Engine;
	scope (exit)
		engine.destroy;
	engine.Write(startText);
	engine.Run();
	return 0;
}
