package funkin.modding.modchart.engine.modifiers.list;

import flixel.FlxG;
import funkin.modding.modchart.backend.core.ModifierParameters;
import funkin.modding.modchart.backend.util.ModchartUtil;

class Rotate extends Modifier {
	var offXID:Int;
	var offYID:Int;
	var offZID:Int;

	public function new(pf) {
		super(pf);
		offXID = findID('rotateXOffset');
		offYID = findID('rotateYOffset');
		offZID = findID('rotateZOffset');
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		var rotateName = getRotateName();
		var player = params.player;

		var angleX = getPercent(rotateName + 'X', player);
		var angleY = getPercent(rotateName + 'Y', player);
		var angleZ = getPercent(rotateName + 'Z', player);

		// does angleY work here if angleX and angleZ are disabled? - ye
		if (angleX == 0 && angleY == 0 && angleZ == 0)
			return curPos;

		final origin:Vector3 = getOrigin(curPos, params);
		curPos = ModchartUtil.rotate3DVector(curPos -= origin, angleX, angleY, angleZ);
		curPos += origin;
		return curPos;
	}

	public function getOrigin(curPos:Vector3, params:ModifierParameters):Vector3 {
		var player = params.player;
		var ox = getUnsafe(offXID, player);
		var oy = getUnsafe(offYID, player);
		var oz = getUnsafe(offZID, player);
		var fixedLane = Math.round(getKeyCount(player) * .5);
		return new Vector3(getReceptorX(fixedLane, player) + ox, FlxG.height / 2 + oy, oz);
	}

	public function getRotateName():String
		return 'rotate';

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
