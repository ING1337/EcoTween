package  
{
	import flash.display.Shape;
	import flash.events.Event;
	
	public class EcoTween
	{
		public var tweens:Vector.<EcoTween>  = new Vector.<EcoTween>();
		public var isPlaying:Boolean         = false;
		public var frame:Number              = 0;
		public var lastFrame:Number          = 0;
		
		public var target:Object;
		public var length:Number;
		public var values:Object;
		public var spread:uint;
		public var easing:String;
		public var start:Number;
		public var speed:Number;
		
		private var i:int, prop:String, tween:EcoTween, dispatcher:Shape, valueMap:Array;

		public function EcoTween(_target:Object = null, _length:Number = 0, _values:Object = null, _spread:uint = EcoUtils.SPREAD_NONE, _easing:String = EcoUtils.EASE_LINEAR, _start:Number = 0, _speed:Number = 1) {
			target	= _target;
			length	= _length;
			values	= _values;
			spread	= _spread;
			easing	= _easing;
			start	= _start;
			speed	= _speed;
		}
		
		// ########################################################################################################################
		// ########################################################################################################################
		// ########################################################################################################################
		
		public function render(e:Event = null) : void {
			frame = EcoUtils.spread(isPlaying ? frame + speed : frame, length, spread);
			
			if (frame == lastFrame) return;

			for each (tween in tweens) {
				if (!tween.isPlaying) tween.frame = frame - tween.start;
				tween.render();
			}
			
			
			for (prop in values) {
				//if (!target.hasOwnProperty(prop)) continue;
				if (values[prop] is Number) {
					target[prop] += getValue(values[prop]);
				} else if (values[prop] is Array) {
					valueMap = values[prop].concat();
					for (i = 0; i < valueMap.length; ++i) if (valueMap[i] is Number) valueMap[i] = getValue(valueMap[i]);
					target[prop].apply(target, valueMap);
				}
			}
			
			lastFrame = frame;
		}
		
		private function getValue(_value:Number) : Number {
			return EcoUtils[easing](0, _value, frame / length) - EcoUtils[easing](0, _value, lastFrame / length);
		}
		
		// ########################################################################################################################
		// ########################################################################################################################
		// ########################################################################################################################
		
		public function newTween(_target:Object = null, _length:Number = 100, _values:Object = null, _spread:uint = EcoUtils.SPREAD_PAD, _easing:String = EcoUtils.EASE_LINEAR, _start:Number = NaN) : EcoTween {
			tween = new EcoTween(_target, _length, _values, _spread, _easing, isNaN(_start) ? frame : _start);
			tweens.push(tween);
			return tween;
		}
		
		public function addTween(...para:Array) : void {
			var targetFrame:Number = frame;
			for (var i:int = 0; i < para.length; ++i) {
				if (para[i] is Number) {
					targetFrame = para[i];
				} else if (para[i] is Array) {
					addTween.apply(this, para[i].unshift(targetFrame));
					para[i].shift();
				} else if (para[i] is EcoTween) {
					para[i].start = targetFrame;
					tweens.push(para[i]);
				}
			}
		}
		
		public function removeTween(...para:Array) : void {
			for (i = 0; i < para.length; ++i) {
				var j:int = tweens.indexOf(para[i]);
				if (j + 1) tweens.splice(j, 1);
			}
		}
		
		public function copy(_newParams:Object) : void {
			for (prop in _newParams) {
				if (!hasOwnProperty(prop)) continue;
				this[prop] = _newParams[prop];
			}
		}
		
		public function clone(_newParams:Object = null) : EcoTween {
			tween = new EcoTween(target, length, values, spread, easing, start, speed);
			tween.copy(_newParams);
			return tween;
		}
		
		// ########################################################################################################################
		// ########################################################################################################################
		// ########################################################################################################################
		
		public function play() : void {
			if (isPlaying) return;
			if (!dispatcher) dispatcher = new Shape();
			dispatcher.addEventListener(Event.ENTER_FRAME, render);
			isPlaying = true;
		}
		
		public function stop() : void {
			if (!isPlaying) return;
			dispatcher.removeEventListener(Event.ENTER_FRAME, render);
			isPlaying = false;
		}
		
		public function goto(_frame:Number) : void {
			frame = _frame;
			render();
		}
	}
}
