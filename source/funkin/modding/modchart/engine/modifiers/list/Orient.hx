package funkin.modding.modchart.engine.modifiers.list;

import funkin.modding.modchart.backend.core.ModifierParameters;
import funkin.modding.modchart.backend.core.VisualParameters;

class Orient extends Modifier {
	var orientID:Int;
	var orientXID:Int;
	var orientYID:Int;

	public function new(pf) {
		super(pf);
		orientID = findID('orient');
		orientXID = findID('orientx');
		orientYID = findID('orienty');
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
