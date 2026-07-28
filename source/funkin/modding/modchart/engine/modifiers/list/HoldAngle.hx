package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;
import funkin.modding.modchart.backend.core.VisualParameters;

class HoldAngle extends Modifier {
	var holdAngleXID:Int;
	var holdAngleYID:Int;
	var holdAngleZID:Int;

	public function new(pf) {
		super(pf);
		holdAngleXID = findID('holdanglex');
		holdAngleYID = findID('holdangley');
		holdAngleZID = findID('holdanglez');
	}

	override public function visuals(data:VisualParameters, params:ModifierParameters) {
		final player = params.player;
		// For holds only - add rotation based on distance
		if (params.straightHolds) {
			data.angleX += getUnsafe(holdAngleXID, player) * (params.distance * 0.001);
			data.angleY += getUnsafe(holdAngleYID, player) * (params.distance * 0.001);
			data.angleZ += getUnsafe(holdAngleZID, player) * (params.distance * 0.001);
		}
		return data;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
