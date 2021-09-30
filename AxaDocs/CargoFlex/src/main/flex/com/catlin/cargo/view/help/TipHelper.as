package com.catlin.cargo.view.help
{
	import com.catlin.cargo.bundles.RB_ui;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	import mx.core.Container;
	import mx.core.IContainer;
	import mx.core.IToolTip;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.managers.ToolTipManager;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class TipHelper {
		
		private var key:String;
		
		public function TipHelper() {
		}

		protected function get rm():IResourceManager {
			return ResourceManager.getInstance();
		}
		
		protected function hideTips(uic:UIComponent):void {
			if (uic == null) return;
			for each (var o:UIComponent in (uic.parent as Container).getChildren()) {
				if (o is HelpIconPanel) {
					o.visible = false;
					return;
				}
			} 
		}
		
		public function getTips(uic:UIComponent, localizedTooltipKey:String):String {

			this.key = localizedTooltipKey;
			// Function can be called before the instantiation of the ui component
			if (uic == null)
				return null;
			
			// Might be wrong as it finds the first in the container
			// Will blow internally if uic.getParent fails (Which it sometimes does because of event series)
			var cvsHelp:HelpIconPanel = new HelpIconPanel();
			cvsHelp.id = "cvsHelp" + uic.id; // Make the panel id unique for easier testing of click images
			cvsHelp.label = cvsHelp.id;
			
			for each (var o:UIComponent in (uic.parent as Container).getChildren()) {
				if (o is HelpIconPanel) {
					o.visible = true;
					return null;
				}
			} 
			
			// Create a hbox container and add the ui field and the help panel to its right 
			var c:IContainer  = uic.parent as IContainer;
			var idx:Number = c.getChildIndex(uic);
			var hbx:HBox = new HBox();
			hbx.addChild(uic);
			hbx.addChild(cvsHelp);
			hbx.setStyle("horizontalAlign", "center"); 
			c.addChildAt(hbx, idx); // Replace the ui component with the new hbox
			
			// Set the instance state
			cvsHelp.objComponentHolder.prop = uic;
			cvsHelp.objComponentHolder.tip = null;
			cvsHelp.objComponentHolder.key = key; 
			
			// Add events to trigger the appearance of the text
			cvsHelp.imgHelp.addEventListener(MouseEvent.MOUSE_UP, onShowToolTip);
			cvsHelp.imgHelp.addEventListener(MouseEvent.MOUSE_OVER, onShowToolTip);
			cvsHelp.imgHelp.addEventListener(MouseEvent.MOUSE_OUT, onResetToolTip);

			return null;
	  	}
	  	
	  	protected function onShowToolTip(event:MouseEvent):void {
	  		var pnlHelp:HelpIconPanel = event.target.parent as HelpIconPanel;
			
			var tooltipText:String = null;
			if (pnlHelp.objComponentHolder && pnlHelp.objComponentHolder.key )
				tooltipText = ResourceManager.getInstance().getString(RB_ui.RB_NAME, pnlHelp.objComponentHolder.key);
			
			
	  		if (pnlHelp.objComponentHolder.tip == null || (!tooltipText && pnlHelp.objComponentHolder.tip != tooltipText) ) {
				
				var rm:IResourceManager =  ResourceManager.getInstance();
				if (tooltipText != null) {
	  				var tt:IToolTip = ToolTipManager.createToolTip(tooltipText, event.stageX, event.stageY);
	  				positionTip(pnlHelp, tt);
	  				pnlHelp.objComponentHolder.tip = tt;
				} else {
					pnlHelp.objComponentHolder.tip = null;
				}
	  		}
	  	}

		protected function onResetToolTip(event:Event):void {
	  		var pnlHelp:HelpIconPanel = event.target.parent as HelpIconPanel;
	  		if (pnlHelp.objComponentHolder.tip != null) {
		  		ToolTipManager.destroyToolTip(pnlHelp.objComponentHolder.tip);
		  		pnlHelp.objComponentHolder.tip = null;
	  		}
	  	}

		//
		//  C'n'P from ToolTipManagerImpl
		//
	    private function positionTip(pnlHelp:HelpIconPanel, currentToolTip:IToolTip):void
	    {
	        var x:Number;
	        var y:Number;
	
	        var screenWidth:Number = currentToolTip.screen.width;
	        var screenHeight:Number = currentToolTip.screen.height;
	
	        var sm:ISystemManager = getSystemManager(pnlHelp.imgHelp);
	        // Position the upper-left of the tooltip
	        // at the lower-right of the arrow cursor.
	        x = DisplayObject(sm).mouseX + 11;
	        y = DisplayObject(sm).mouseY + 22;
	
	        // If the tooltip is too wide to fit onstage, move it left.
	        var toolTipWidth:Number = currentToolTip.width;
	        if (x + toolTipWidth > screenWidth)
	            x = screenWidth - toolTipWidth;
	
	        // If the tooltip is too tall to fit onstage, move it up.
	        var toolTipHeight:Number = currentToolTip.height;
	        if (y + toolTipHeight > screenHeight)
	            y = screenHeight - toolTipHeight;
	
			var pos:Point = DisplayObject(sm).localToGlobal(new Point(x, y));
			//(SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager).getSandboxRoot();
			pos = DisplayObject(getSystemManager(pnlHelp.imgHelp).getSandboxRoot()).globalToLocal(pos);
			x = pos.x;
			y = pos.y;
	
	        currentToolTip.move(x, y);
	    }
	    
	     private function getSystemManager(target:DisplayObject):ISystemManager
	     {
	        return target is IUIComponent ?
	               IUIComponent(target).systemManager :
	               null;
	     }
	}
}