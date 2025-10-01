import flixel.FlxG;
import flixel.tweens.FlxTween;
import funkin.Preferences;
import funkin.play.PlayState;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.util.Constants;
import funkin.modding.module.Module;
import funkin.modding.module.ModuleHandler;

import ModuleInitializer;

class StrumlineHandler extends Module {

    public static var MIDDLESCROLL_X = FlxG.width / 2 - PlayState.instance.playerStrumline.width / 2;

    // This is where the strums are by DEFAULT, these will not change
    public static var PLAYER_STRUM_X:Float = (FlxG.width / 2 + Constants.STRUMLINE_X_OFFSET) + (PlayState.instance.cutoutSize / 2.0);
    public static var PLAYER_STRUM_Y = Preferences.downscroll ? FlxG.height - PlayState.instance.playerStrumline.height - Constants.STRUMLINE_Y_OFFSET - NoteStyle.getStrumlineOffsets()[1] : Constants.STRUMLINE_Y_OFFSET;

    public static var OPPONENT_STRUM_X:Float = Constants.STRUMLINE_X_OFFSET + PlayState.instance.cutoutSize;
    public static var OPPONENT_STRUM_Y = Preferences.downscroll ? FlxG.height - PlayState.instance.opponentStrumline.height - Constants.STRUMLINE_Y_OFFSET - NoteStyle.getStrumlineOffsets()[1] : Constants.STRUMLINE_Y_OFFSET;

    public static var doStrumlineWiggle:Bool = false; // not to be confused with doModcharts

    public static var doModcharts:Bool = true;

    public static var strumlinePositionSet:Bool = false;
	public static var wiggleIntensity:Float = 8;

	public function new() {
		super("StrumlineHandler");
    }

    override function onCreate(event:ScriptEvent):Void {
        super.onCreate(event);
    }

    public static function forceMiddlescroll():Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

        PlayState.instance.playerStrumline.x = MIDDLESCROLL_X;
        PlayState.instance.opponentStrumline.visible = false;
    }

    public static function swapStrumlineX():Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

        PlayState.instance.playerStrumline.x = OPPONENT_STRUM_X;
        PlayState.instance.opponentStrumline.x = PLAYER_STRUM_X;
    }

    public static function swapStrumlineY():Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

        PlayState.instance.playerStrumline.y = OPPONENT_STRUM_Y;
        PlayState.instance.opponentStrumline.y = PLAYER_STRUM_Y;
    }

    public static function resetStrumlines():Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

        PlayState.instance.playerStrumline.x = PLAYER_STRUM_X;
        PlayState.instance.playerStrumline.y = PLAYER_STRUM_Y;
        PlayState.instance.opponentStrumline.x = OPPONENT_STRUM_X;
        PlayState.instance.opponentStrumline.y = OPPONENT_STRUM_Y;
    }

    public static function startModchart():Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

        doStrumlineWiggle = true;
    }

    public static function stopModchart():Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

        doStrumlineWiggle = false;

        PlayState.instance.playerStrumline.strumlineNotes.members[0].x = 0;
        PlayState.instance.opponentStrumline.strumlineNotes.members[0].x = 0;
        PlayState.instance.playerStrumline.strumlineNotes.members[0].y = 0;
        PlayState.instance.opponentStrumline.strumlineNotes.members[0].y = 0;
    }

    override function onUpdate(event:UpdateScriptEvent):Void {
        if (FlxG.onMobile || !doModcharts || PlayState.instance == null) return;
        doModcharts = ModuleHandler.getModule("EXEOptions").scriptGet("modcharts");

		if (!strumlinePositionSet && PlayState.instance.playerStrumline != null && PlayState.instance.opponentStrumline != null) {
			basePlayerStrumPos = PlayState.instance.playerStrumline.x;
			baseOpponentStrumPos = PlayState.instance.opponentStrumline.x;
			basePlayerStrumPosY = PlayState.instance.playerStrumline.strumlineNotes.members[0] != null ? PlayState.instance.playerStrumline.strumlineNotes.members[0].y : 0;
			baseOpponentStrumPosY = PlayState.instance.opponentStrumline.strumlineNotes.members[0] != null ? PlayState.instance.opponentStrumline.strumlineNotes.members[0].y : 0;
			strumlinePositionSet = true;
		}

		if (doStrumlineWiggle) {
			var curbet = (Conductor.instance.songPosition/1000)*(Conductor.instance.bpm/60);
			for (i in 0...4) {
				if (PlayState.instance.playerStrumline.strumlineNotes.members[i] != null)
					PlayState.instance.playerStrumline.strumlineNotes.members[i].y = basePlayerStrumPosY + (wiggleIntensity * Math.cos((curbet + i*0.25) * Math.PI));
				if (PlayState.instance.opponentStrumline.strumlineNotes.members[i] != null)
					PlayState.instance.opponentStrumline.strumlineNotes.members[i].y = baseOpponentStrumPosY + (wiggleIntensity * Math.cos((curbet + i*0.25) * Math.PI));
			}
			PlayState.instance.playerStrumline.x = basePlayerStrumPos + Math.sin(curbet * Math.PI) * wiggleIntensity;
			PlayState.instance.opponentStrumline.x = baseOpponentStrumPos + Math.sin(curbet * Math.PI) * wiggleIntensity;
		}
    }
}