package settings;
class GlobalSettings {

	public static inline var ORB_RADIUS:Float = 20;
	public static inline var MAX_RELATED:Int = 5;

    public static inline var OFFLINE_DEBUG_MODE:Bool = false;
    public static inline var OFFLINE_DEBUG_IMAGE:String = "./resources/offlineDebugImage.png";


	public function new() {
	}


    public static function OFFLINE_DEBUG_RELATED():Array<String>{
        return ["3LyQ9aDH7Id4t7SqAEaxfn", "27JDTiYCwtiLKRWrHMDe3A", "3TKwR0c2W9ZLaNdoPGDl33", "1a6tqLJPUs4DBAnNUZkr2O", "0rFVdej5uMjF7nca0nAjEY"];
    }


}
