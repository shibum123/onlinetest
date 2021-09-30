package com.catlin.cargo.view.menu {
	import mx.skins.halo.LinkButtonSkin;

	public class TopMenuLinkButtonSkin extends LinkButtonSkin {
		public function TopMenuLinkButtonSkin() {
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			var themeColor:uint = getStyle("themeColor");
			graphics.clear();
			graphics.beginFill(themeColor);
			graphics.drawRect(0, 10, w, 10);
			graphics.endFill();
		}
	}
}