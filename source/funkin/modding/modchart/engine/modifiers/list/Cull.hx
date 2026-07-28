package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;

class Cull extends Modifier {
	var _cullID:Int;

	public function new(pf) {
		super(pf);
		_cullID = findID('cull');
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		final player = params.player;
		final cull = getUnsafe(_cullID, player);
		if (cull == 0)
			return curPos;

		// cull > 0: hide notes behind camera (z > threshold)
		// cull < 0: hide notes in front of camera
		if ((cull > 0 && curPos.z > 0) || (cull < 0 && curPos.z < 0))
			curPos.z = 99999;

		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
