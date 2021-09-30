package com.catlin.cargo.view.risk.clauses {
	import com.catlin.cargo.model.core.clause.Clause;
	
	import mx.controls.listClasses.ListItemRenderer;
	
	public class ClauseListItemRenderer extends ListItemRenderer {

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var clause:Clause = data as Clause;
			if (clause != null && !clause.active) {
				label.setColor(getStyle("disabledColor"));
			}
		}
	}
}