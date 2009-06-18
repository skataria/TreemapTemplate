// ActionScript file
import models.ConfigurationParametersMO;
import models.CurrentConfigurationMO;

import mx.core.Application;
import mx.managers.PopUpManager;


[Bindable]
public var configRef:ConfigurationParametersMO;

[Bindable]
public var selectedMeasures:CurrentConfigurationMO;

public static function useConfiguration(config:ConfigurationParametersMO):void{
  const selector:Selector = new Selector();
  selector.configRef = config;

  PopUpManager.addPopUp(selector, Application.application as DisplayObject, true);
  PopUpManager.centerPopUp(selector);
}

private function onCreationComplete():void{
  selectedMeasures = configRef.currentConfiguration as CurrentConfigurationMO;
  setDefaults();

  this.setFocus();
}

private function setDefaults():void{
  if(selectedMeasures){

    var selSizeIndex:int = -1;
    if(sizeList.dataProvider && sizeList.dataProvider.length > 0){
      var source:Array = sizeList.dataProvider.source;
      for( var count:int =0; count < source.length; count++){
        if(source[count].name == selectedMeasures.selSizeMeasure) selSizeIndex = count;
      }
    }

    var selColorIndex:int = -1;
    if(colorList.dataProvider && colorList.dataProvider.length > 0){
      var src:Array = colorList.dataProvider.source;
      for( var cnt:int =0; cnt < src.length; cnt++){
        if(src[cnt].name == selectedMeasures.selColorMeasure) selColorIndex = cnt;
      }
    }

    var selHierIndex:int = -1;
    if(hierarchyList.dataProvider && hierarchyList.dataProvider.length > 0){
      var arr:Array = hierarchyList.dataProvider.source;
      for( var ix:int =0; ix < arr.length; ix++){
        if(arr[ix].name == selectedMeasures.selLayerHierarchy) selHierIndex = ix;
      }
    }

    sizeList.selectedIndex = selSizeIndex;
    colorList.selectedIndex = selColorIndex;
    hierarchyList.selectedIndex = selHierIndex;
  }
}

private function updateTreemap():void{
  //ToDo: Update the treemap with the selected configurations.
  selectedMeasures = new CurrentConfigurationMO();
  if(sizeList.selectedItem != null){
    selectedMeasures.selSizeMeasure = sizeList.selectedItem.name;
  }
  if(colorList.selectedItem != null){
    selectedMeasures.selColorMeasure = colorList.selectedItem.name;
  }
  if(hierarchyList.selectedItem != null){
    selectedMeasures.selLayerHierarchy = hierarchyList.selectedItem.name;
  }
  configRef.currentConfiguration = selectedMeasures;
  exitPopUp();
}

private function cancel():void{
  exitPopUp();
}

private function exitPopUp():void{
  configRef = null;
  selectedMeasures = null;
  PopUpManager.removePopUp(this);
}

private function onKeyUp(event:KeyboardEvent):void {
  // Capture ESC and ENTER key presses to use as shortcuts for the 'Cancel' and
  // 'OK' buttons respectively.

  switch (event.keyCode) {
    case 13:  // ENTER
    updateTreemap();
    break;

    case 27:  // ESC
    cancel();
    break;
  }
}

