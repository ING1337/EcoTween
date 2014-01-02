package  
{
	public class EcoUtils
	{
		public static const SPREAD_NONE:uint      = 0;
		public static const SPREAD_REPEAT:uint    = 1;
		public static const SPREAD_REFLECT:uint   = 2;
		public static const SPREAD_PAD_LEFT:uint  = 4;
		public static const SPREAD_PAD_RIGHT:uint = 8;
		public static const SPREAD_PAD:uint       = 12;
		
		public static const EASE_LINEAR:String    = "linear";
		public static const EASE_IN:String        = "easeIn";
		public static const EASE_OUT:String       = "easeOut";
		public static const EASE_INOUT:String     = "easeInOut";
		
		// ########################################################################################################################
		// ########################################################################################################################
		// ########################################################################################################################
		
		public static function spread(val1:Number, val2:Number, spread:uint) : Number {
			var result:Number = val1;
			
			if ((spread & SPREAD_REPEAT) == SPREAD_REPEAT)       result = val1 < 0 ? val2 + (val1 + 1) % (val2 + 1) : val1 % (val2 + 1);
			if ((spread & SPREAD_REFLECT) == SPREAD_REFLECT)     result = int(val1 / val2) % 2 ? val2 - Math.abs(val1 % val2) : Math.abs(val1 % val2);

			if ((spread & SPREAD_PAD_LEFT) == SPREAD_PAD_LEFT)   result = val1 <= 0 ? 0 : result;
			if ((spread & SPREAD_PAD_RIGHT) == SPREAD_PAD_RIGHT) result = val1 >= val2 ? val2 : result;
			
			return result;
		}
		
		// ########################################################################################################################
		// ########################################################################################################################
		// ########################################################################################################################
		
		public static function linear(val1:Number, val2:Number, ratio:Number) : Number {
			return val1 + (val2 - val1) * ratio;
		}
		
		public static function easeIn(val1:Number, val2:Number, ratio:Number) : Number {
			return val1 + (val2 - val1) * ratio * ratio * ratio;
		}
		
		public static function easeOut(val1:Number, val2:Number, ratio:Number) : Number {
			return easeIn(val1, val2, ratio / 1 - 1) + 1;
		}
		
		public static function easeInOut(val1:Number, val2:Number, ratio:Number) : Number {
		   return .5 * (easeIn(val1, val2, (ratio < .5 ? ratio : ratio - 1) * 2) + (ratio < .5 ? 0 : val2 * 2));
		}
		
		public static function round(num:Number, decimals:Number) : Number {
				var p:Number = Math.pow(10, decimals);
				return Math.round(num * p) / p;
		}
	}
}
