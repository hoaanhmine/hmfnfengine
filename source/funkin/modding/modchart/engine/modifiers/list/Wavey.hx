package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;
import funkin.modding.modchart.backend.core.VisualParameters;

class Wavey extends Modifier {
	static final AXES = ['', 'x', 'y', 'z'];

	var wAmtIDs:Array<Int>;
	var wSpeedIDs:Array<Int>;
	var wDesyncIDs:Array<Int>;
	var wOffsetIDs:Array<Int>;

	public function new(pf) {
		super(pf);

		final maxKeys = 16;
		wAmtIDs = [for (a in AXES) findID('wavey' + a)];
		wSpeedIDs = [for (a in AXES) findID('wavey' + a + 'Speed')];
		wDesyncIDs = [for (a in AXES) findID('wavey' + a + 'Desync')];
		wOffsetIDs = [for (a in AXES) findID('wavey' + a + 'Offset')];
	}

	inline function applyAxis(curPos:Vector3, params:ModifierParameters, axisIdx:Int, realAxisIdx:Int) {
		final player = params.player;
		final lane = params.lane;

		var amt = getUnsafe(wAmtIDs[axisIdx], player);
		if (amt == 0)
			return;

		var speed = getUnsafe(wSpeedIDs[axisIdx], player);
		if (speed == 0)
			speed = 1;
		var desync = getUnsafe(wDesyncIDs[axisIdx], player);
		if (desync == 0)
			desync = 0.2;
		var offset = getUnsafe(wOffsetIDs[axisIdx], player);

		var time = params.songTime * 0.001;
		time *= speed;
		time += offset;
		var shift = amt * sin(time + lane * desync * Math.PI) * (ARROW_SIZE * 0.5);

		if (realAxisIdx == 0) curPos.x += shift;
		else if (realAxisIdx == 1) curPos.y += shift;
		else curPos.z += shift;
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		applyAxis(curPos, params, 0, 0); // wavey -> x
		applyAxis(curPos, params, 1, 0); // waveyx -> x
		applyAxis(curPos, params, 2, 1); // waveyy -> y
		applyAxis(curPos, params, 3, 2); // waveyz -> z
		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;

	override public function allowOnStraightHolds():Bool
		return false;
}
