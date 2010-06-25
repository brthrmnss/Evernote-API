package org.robotlegs.popups.view
{
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.default_popups.popup_modal_bg;
	import org.robotlegs.popups.view.popups.stockprice_popup;
	import org.robotlegs.stockchart.model.StockChartModel;

	//import org.robotlegs.stockchart.model.StockChartModelEvent;
	
	public class PopupModalMediator extends Mediator
	{
		[Inject] public var popup:org.robotlegs.popups.view.popups.default_popups.popup_modal_bg;
		[Inject] public var popupModal : PopupModel;
		
		public function PopupModalMediator()
		{
		} 
		
		override public function onRegister():void
		{
			/*
			if you have your own event ... 
			should they all 
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
			*/
			/*		
			eventMap.mapListener(eventDispatcher, StockChartModelEvent.CHART_DATES_FILTERED, whenDatesFiltered);			
			//eventMap.mapListener(eventDispatcher, ChartPageEvent.LOAD_CHART, onLoadChart);
			this.ui.dp.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.whenChartDatesChaganged, false, 0, true)
			this.ui.hslicer.addEventListener( ChartDataSlicer.SLICED_DATA, this.whenDataSliced , false, 0, true )
			this.ui.addEventListener( 'DataLoaded' , whenDataRecieved )
			*/
			this.popup.addEventListener( popup_modal_bg.SHOWING_MODAL_POPUP , onShowPopup )
			this.popup.addEventListener(popup_modal_bg.HIDING_MODAL_POPUP , onHidePopup )			
			this.popupModal.modalPopup = this.popup; 
			this.popupModal.registerModalPopup( this.popup ) 
		}
/*		
		private function onLoadChart(e:ChartPageEvent):void
		{
		}
		
		private function whenFilterApplied(e:ChartFilterEvent):void
		{
			trace('x' + e.data )
			var maxDifferent : Number = e.data as Number
			var ee : DateField
			var newSource :  Array = []
			var firstDate : Date = DateField.stringToDate( this.ui.dp[0].Date, "YYYY-MM-DD" );
			for each ( var item :  Object in this.ui.dp ) 
			{
				var date : Date = DateField.stringToDate( item.Date, "YYYY-MM-DD" );
				if ( date.getTime() - firstDate.getTime() > maxDifferent ) 
				{
					continue; 
				}
				newSource.push( item ) 
			}
			
			this.ui.dp.source = newSource
			this.ui.dp.refresh()
		}
		
		
		private function whenDataSliced(e:Event):void
		{
			this.stockChartModel.filterChart_ByIndex( this.ui.hslicer.slicedStart, this.ui.hslicer.slicedLength ) 
		}			
		private function whenDataRecieved(e:Event):void
		{
			this.stockChartModel.loadData( this.ui.dp.source ) 
			//this.graphPage.charts.source = e.data as Array
		}		
	*/
		private function onShowPopup(e:Event):void
		{
			this.popupModal.modalPopupOpened()
		}			
		
		private function onHidePopup(e:Event):void
		{
	
			this.popupModal.modalPopupClosed()
		}					
		
		
	}
}