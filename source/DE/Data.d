module DE.Data;

struct Vec2 {
	int x, y;

	Vec2 opBinary(string op)(const ref Vec2 other) {
		mixin("return Vec2(x " ~ op ~ " other.x, y " ~ op ~ " other.y;");
	}

	ref Vec2 opOpAssign(string op)(const ref Vec2 other) {
		mixin("x " ~ op ~ "= other.x;");
		mixin("y " ~ op ~ "= other.y;");
		return this;
	}
}
