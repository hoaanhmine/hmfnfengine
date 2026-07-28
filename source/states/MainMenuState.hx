package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
import options.OptionsState;
import objects.Character;
import openfl.geom.Matrix;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0.4';
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = ['freeplay', 'options'];

	var bg:FlxSprite;
	var menuCharacter:FlxSprite;
	var selectedSomethin:Bool = false;
	var danceBeat:Int = 0;

	override function create()
	{
		super.create();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		// Random character from available files
		try
		{
			var charList = getAvailableCharacters();
			if (charList.length > 0)
			{
				var charName = charList[FlxG.random.int(0, charList.length - 1)];
				menuCharacter = new Character(0, 0, charName, false);
				menuCharacter.scrollFactor.set(0, 0);
				menuCharacter.screenCenter(Y);
				menuCharacter.x = FlxG.width - menuCharacter.width - 100;
				menuCharacter.y += 60;
				add(menuCharacter);
			}
		}
		catch (e:Dynamic) {}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (num => option in optionShit)
		{
			var item:FlxSprite = new FlxSprite(0, 0);
			item.frames = Paths.getSparrowAtlas('mainmenu/menu_' + option);
			item.antialiasing = ClientPrefs.data.antialiasing;
			item.animation.addByPrefix('idle', option + ' idle', 24, true);
			item.animation.addByPrefix('selected', option + ' selected', 24, false);
			item.animation.play('idle', true);
			item.ID = num;
			item.x = 100;
			item.y = 200 + num * 170;
			item.scrollFactor.set(0, 0);
			menuItems.add(item);
		}

		var versionText:FlxText = new FlxText(12, FlxG.height - 24, 0, "hmfnfengine v" + Application.current.meta.get('version'), 12);
		versionText.scrollFactor.set();
		versionText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);

		changeItem(0);
	}

	function getAvailableCharacters():Array<String>
	{
		var charList:Array<String> = [];
		var paths:Array<String> = [
			#if MODS_ALLOWED
			Paths.mods('characters/'),
			#end
			Paths.getSharedPath() + 'characters/'
		];

		for (path in paths)
		{
			#if MODS_ALLOWED
			if (FileSystem.exists(path))
			{
				for (file in FileSystem.readDirectory(path))
				{
					if (file.toLowerCase().endsWith('.json'))
					{
						var name = file.substr(0, file.length - 5);
						if (!charList.contains(name))
							charList.push(name);
					}
				}
			}
			#end
		}

		return charList;
	}

	override function beatHit()
	{
		super.beatHit();

		danceBeat++;
		if (menuCharacter != null && (menuCharacter is Character))
		{
			var char:Character = cast menuCharacter;
			if (danceBeat % 2 == 0)
				char.dance();
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;

				var item = menuItems.members[curSelected];
				FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					switch (optionShit[curSelected])
					{
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
					}
				});

				for (memb in menuItems)
				{
					if (memb == item)
						continue;
					FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (num => item in menuItems.members)
		{
			item.animation.play((item.ID == curSelected) ? 'selected' : 'idle', true);
		}
	}
}
