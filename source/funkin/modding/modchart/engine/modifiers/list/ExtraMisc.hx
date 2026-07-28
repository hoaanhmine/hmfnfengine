package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;

class ExtraMisc extends Modifier {
	var ydID:Int;
	var zdID:Int;

	public function new(pf) {
		super(pf);
		ydID = findID('yd');
		zdID = findID('zd');
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		final player = params.player;
		var yd = getUnsafe(ydID, player);
		if (yd != 0)
			curPos.y += yd * (params.distance / HEIGHT);

		var zd = getUnsafe(zdID, player);
		if (zd != 0)
			curPos.z += zd * (params.distance / HEIGHT);

		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
