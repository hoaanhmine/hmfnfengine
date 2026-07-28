package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;

class Circ extends Modifier {
	static final AXES = ['x', 'y', 'z'];

	var circIDs:Array<Int>;
	var circOffsetIDs:Array<Int>;

	public function new(pf) {
		super(pf);

		circIDs = [for (a in AXES) findID('circ' + a)];
		circOffsetIDs = [for (a in AXES) findID('circ' + a + 'Offset')];
	}

	inline function applyAxis(curPos:Vector3, params:ModifierParameters, axisIdx:Int, realAxisIdx:Int) {
		final player = params.player;
		final amt = getUnsafe(circIDs[axisIdx], player);
		if (amt == 0)
			return;

		final offset = getUnsafe(circOffsetIDs[axisIdx], player);
		final dist = params.distance + offset;
		final shift = amt * dist * dist * -0.001;

		if (realAxisIdx == 0) curPos.x += shift;
		else if (realAxisIdx == 1) curPos.y += shift;
		else curPos.z += shift;
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		applyAxis(curPos, params, 0, 0); // circx -> x
		applyAxis(curPos, params, 1, 1); // circy -> y
		applyAxis(curPos, params, 2, 2); // circz -> z
		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;

	override public function allowOnStraightHolds():Bool
		return false;
}
