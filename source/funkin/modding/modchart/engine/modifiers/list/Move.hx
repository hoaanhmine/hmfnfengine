package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;

class Move extends Modifier {
	static final AXES = ['x', 'y', 'z'];

	var moveIDs:Array<Int>;
	var moveLaneIDs:Array<Array<Int>>;

	public function new(pf) {
		super(pf);

		final maxKeys = 16;
		moveIDs = [for (a in AXES) findID('move' + a)];
		moveLaneIDs = [for (a in AXES) [for (l in 0...maxKeys) findID('move' + a + l)]];
	}

	inline function applyAxis(curPos:Vector3, params:ModifierParameters, axisIdx:Int, realAxisIdx:Int) {
		final lane = params.lane;
		final player = params.player;

		var amt = getUnsafe(moveIDs[axisIdx], player);
		if (Config.COLUMN_SPECIFIC_MODIFIERS)
			amt += getUnsafe(moveLaneIDs[axisIdx][lane], player);

		if (amt == 0)
			return;

		if (realAxisIdx == 0) curPos.x += amt * ARROW_SIZE;
		else if (realAxisIdx == 1) curPos.y += amt * ARROW_SIZE;
		else curPos.z += amt * ARROW_SIZE;
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		applyAxis(curPos, params, 0, 0); // movex -> x
		applyAxis(curPos, params, 1, 1); // movey -> y
		applyAxis(curPos, params, 2, 2); // movez -> z
		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
