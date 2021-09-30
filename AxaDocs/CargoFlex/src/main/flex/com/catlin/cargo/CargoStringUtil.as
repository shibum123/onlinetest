package com.catlin.cargo {
	import mx.utils.StringUtil;

	public class CargoStringUtil {

		public static function nullIfEmpty(value:String):String {
			var ret:String=value;
			if (ret != null && StringUtil.trim(ret).length == 0) {
				ret=null;
			}
			return ret;
		}

		public static function isNullOrEmpty(value:String):Boolean {
			if (value == null || StringUtil.trim(value).length == 0) {
				return true;
			}
			return false;
		}

	}
}
