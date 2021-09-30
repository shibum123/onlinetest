package com.catlin.utils {
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.ui.flex.widgets.grid.BasicDataGrid;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class GridExportUtils {

		public static const XLS_EXTENSION:String =".xls";

		public static function exportBasicDataGridToExcel(grid:BasicDataGrid, onlySelected:Boolean=false):void {
			var bytes:ByteArray=generateXL(grid, onlySelected);
			var fileName:String = ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.GRID_EXPORT_UTILS_SAVE_FILE_FILENAME_PREFIX, [new Date().time]);
			saveFile(bytes, fileName + XLS_EXTENSION);
		}

		private static function generateXL(grid:BasicDataGrid, onlySelected:Boolean=false):ByteArray {
			var bytes:ByteArray;

			var dataSource:ICollectionView=(onlySelected ? new ArrayCollection(grid.selectedItems) : grid.dataProvider) as ICollectionView;

			if (dataSource != null && dataSource.length > 0) {

				var xlsFile:ExcelFile=new ExcelFile();
				var sheet:Sheet=new Sheet();

				// Generates the Header
				sheet.resize(dataSource.length + 1, grid.columns.length);

				var col:int=0;
				var row:int=0;
				for each (var hcol:Object in grid.columns) //coltypes differe between DG & ADG
				{
					//trace("row: " + row + " - Col: " + col + " - Header: " + hcol.headerText);
					sheet.setCell(row, col, hcol.headerText);
					col++;
				}

				// Populates the Rows
				var cursor:IViewCursor=dataSource.createCursor();
				var item:Object;
				var itemData:String;

				do {
					item=cursor.current;
					itemData="";
					col=0;
					row++;

					for each (var gridCol:Object in grid.columns) {
						//trace("row: " + row + " - Col: " + col + " - Data: " + gridCol.itemToLabel(item));
						sheet.setCell(row, col, gridCol.itemToLabel(item));
						col++;
					}
				} while (cursor.moveNext())

				xlsFile.sheets.addItem(sheet);
				bytes=xlsFile.saveToByteArray();
			} else {
				xlsFile=new ExcelFile();
				bytes=xlsFile.saveToByteArray();
			}

			return bytes;

		}

		public static function saveFile(bytes:ByteArray, fileName:String):void {

			try {
				
				var saveFile:FileReference=new FileReference();

				saveFile.addEventListener(Event.COMPLETE, function(e:Event):void {
					var savedFile:FileReference = FileReference(e.target);
					Alert.show(ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.GRID_EXPORT_UTILS_SAVE_FILE_SAVED_DESCRIPTION, [savedFile.name])
						, ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.GRID_EXPORT_UTILS_SAVE_FILE_SAVED_TITLE));
				});
				saveFile.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
					Alert.show(ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.GRID_EXPORT_UTILS_SAVE_FILE_ERROR_DESCRIPTION)
						, ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.GRID_EXPORT_UTILS_SAVE_FILE_ERROR_TITLE));					
				});

				saveFile.save(bytes, fileName);

			} catch (err:Error) {
				Alert.show(err.toString());
			}
		}

		// EXPORT TO CSV / TAB Delimiters

		protected static var TAB_DELIMITER:String="\t";
		protected static var COMMA_DELIMITER:String=",";
		protected static var NEW_LINE:String="\n";

		public static function exportBasicDataGridToClipboard(grid:BasicDataGrid, csv:Boolean=true, onlySelected:Boolean=false):void {
			System.setClipboard(exportGridToCSV(grid, csv, onlySelected));
		}

		public static function exportGridToCSV(grid:Object, csv:Boolean, onlySelected:Boolean=false):String {
			var dataSource:ICollectionView=(onlySelected ? new ArrayCollection(grid.selectedItems) : grid.dataProvider) as ICollectionView;

			var headers:String="";
			var delimiter:String="";

			if (csv)
				delimiter=COMMA_DELIMITER;
			else
				delimiter=TAB_DELIMITER;

			//build header
			for each (var hcol:Object in grid.columns) //coltypes differe between DG & ADG
			{
				if (headers.length > 0) //avoid firstcolumn having extra delimeter
					headers+=delimiter;

				headers+=hcol.headerText;
			}
			headers+=NEW_LINE;

			//populate data
			var cursor:IViewCursor=dataSource.createCursor();
			var data:String="";
			var item:Object;
			var itemData:String;

			do {
				item=cursor.current;
				itemData="";
				var pos:int=0;

				for each (var col:Object in grid.columns) {
					//avoid firstcolumn having extra delimeter
					if (pos++ != 0)
						itemData+=delimiter;
					itemData+=col.itemToLabel(item);
				}

				data+=itemData + NEW_LINE;
			} while (cursor.moveNext())

			return headers + data;
		}

	}
}
