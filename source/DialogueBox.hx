package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var gfPortrait:FlxSprite;
	var bfPortrait:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var SkipThisShit:FlxText;

	var dialogueSound:FlxSound;
	var dialogueSoundPaths:Array<String>;
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.23, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(50, 350);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'other-friends':
				dialogueSoundPaths = CoolUtil.coolTextFile(Paths.txt('other-friends/lines'));
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('spinel/box');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24, true);
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (PlayState.SONG.song.toLowerCase() == 'senpai'
			|| PlayState.SONG.song.toLowerCase() == 'roses'
			|| PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		else if (PlayState.SONG.song.toLowerCase() == 'other-friends')
		{
			portraitLeft = new FlxSprite(-20, -40);
			portraitLeft.frames = Paths.getSparrowAtlas('spinel/portraits/spinelspritedialogue');
			portraitLeft.animation.addByPrefix('smug', 'smug', 24, false);
			portraitLeft.animation.addByPrefix('meh', 'meh', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
			portraitLeft.scrollFactor.set();
			portraitLeft.antialiasing = true;
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		portraitRight = new FlxSprite(800, 170);
		portraitRight.frames = Paths.getSparrowAtlas('spinel/portraits/bf_sprite_dialogue');
		portraitRight.animation.addByPrefix('yes', 'yes', 24, false);
		portraitRight.animation.addByPrefix('excited', 'excited', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		portraitRight.antialiasing = true;
		add(portraitRight);
		portraitRight.visible = false;

		gfPortrait = new FlxSprite(500, 30);
		gfPortrait.frames = Paths.getSparrowAtlas('spinel/portraits/gf_sprite_dialogue');
		gfPortrait.animation.addByPrefix('normal', 'face1', 24, false);
		gfPortrait.animation.addByPrefix('upset', 'face2', 24, false);
		gfPortrait.updateHitbox();
		gfPortrait.setGraphicSize(Std.int(gfPortrait.width * 0.9));
		gfPortrait.antialiasing = true;
		gfPortrait.scrollFactor.set();
		add(gfPortrait);
		gfPortrait.visible = false;

		bfPortrait = new FlxSprite(800, 170);
		bfPortrait.frames = Paths.getSparrowAtlas('spinel/portraits/bf_sprite_dialogue');
		bfPortrait.animation.addByPrefix('shocked', 'shocked', 24, false);
		bfPortrait.animation.addByPrefix('worried', 'worried', 24, false);
		bfPortrait.updateHitbox();
		bfPortrait.setGraphicSize(Std.int(bfPortrait.width * 0.9));
		bfPortrait.antialiasing = true;
		bfPortrait.scrollFactor.set();
		add(bfPortrait);
		bfPortrait.visible = false;
		
		box.animation.play('normalOpen');
		if(PlayState.curStage != 'injector')box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		if (hasDialog)
			{
				SkipThisShit = new FlxText(0, FlxG.height * 0.92, -100, "Press SPACE to skip", 32);
				SkipThisShit.font = 'Crewniverse';
				add(SkipThisShit);
			}

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'DejaVu Sans Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'DejaVu Sans Bold';
		swagDialogue.color = 0xFF3F2021;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
		dialogueSound = new FlxSound();
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.SPACE && dialogueStarted == true)
			{
				if (!isEnding)
				{
					remove(dialogue);
					remove(SkipThisShit);
					isEnding = true;
		
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						gfPortrait.visible = false;
						bfPortrait.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);
		
					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
					
					super.update(elapsed);
				}
			}
	
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.SPACE && dialogueStarted == true)
			{
				if (!isEnding)
				{
					remove(dialogue);		
				}
	
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						remove(SkipThisShit);
	
						if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxG.sound.music.fadeOut(2.2, 0);
	
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							gfPortrait.visible = false;
							bfPortrait.visible = false;
							swagDialogue.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);
	
						new FlxTimer().start(1.2, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					if (!isEnding)
					{
						
						dialogueList.remove(dialogueList[0]);
						dialogueSoundPaths.remove(dialogueSoundPaths[0]);
						startDialogue();
					}
				}
			}
			
			super.update(elapsed);
		}

	var isEnding:Bool = false;
	

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		if (dialogueSound.playing)
			dialogueSound.stop();
		dialogueSound = new FlxSound().loadEmbedded(dialogueSoundPaths[0]);
		dialogueSound.play();
		switch (curCharacter)
		{
			case 'gf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				if (!portraitLeft.visible)
					{
						gfPortrait.visible = true;
						gfPortrait.animation.play('normal');
					}
			case 'gfdif':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				if (!portraitLeft.visible)
					{
						gfPortrait.visible = true;
						gfPortrait.animation.play('upset');
					}
			case 'spinel':
				portraitRight.visible = false;
				gfPortrait.visible = false;
				bfPortrait.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('smug');
				}
			case 'spinellol':
				portraitRight.visible = false;
				gfPortrait.visible = false;
				bfPortrait.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('meh');
				}
			case 'bf':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					bfPortrait.visible = true;
					bfPortrait.animation.play('shocked');
				}
			case 'bfwor':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					bfPortrait.visible = true;
					bfPortrait.animation.play('worried');
				}
			case 'bfexc':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('excited');
				}
			case 'bfyes':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('yes');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
