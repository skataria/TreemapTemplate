package models
{
  import flash.events.EventDispatcher;

  import mx.collections.ArrayCollection;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.http.HTTPService;

  [Bindable]
  public class ConfigurationParametersMO extends EventDispatcher
  {
    public var sizeMeasures:ArrayCollection = null;
    public var colorMeasures:ArrayCollection = null;
    public var hierarchies:ArrayCollection = null;
    public var currentConfiguration:CurrentConfigurationMO = null;

    public function ConfigurationParametersMO()
    {
      function loadConfigSucceeded(event:ResultEvent):void{
        sizeMeasures = new ArrayCollection(event.result.configuration.sizeFields.sizeField.source);
        colorMeasures = new ArrayCollection(event.result.configuration.colorFields.colorField.source);
        hierarchies = new ArrayCollection();

        var hierAC:ArrayCollection = event.result.configuration.hierarchies.hierarchy;
        for each(var hierarchy:Object in hierAC){
          var lbl:String ="";
          if(hierarchy.hasOwnProperty("name")){
            lbl = hierarchy.name;
          }
          else{
            var fldsAC:ArrayCollection = hierarchy.Field;
            for(var i:int = 0; i < fldsAC.length; i++){
              if(i > 0) lbl += " > ";
              lbl += fldsAC[i].name;
            }
            hierarchy["name"] = lbl;
          }
          hierarchies.addItem(hierarchy);
        }

        getdefaultConfigurations();

      }

      function loadConfigFailed(event:FaultEvent):void{
        trace("Unable to load configuartion file.");
      }

      var loader:HTTPService = new HTTPService();
      loader.addEventListener(ResultEvent.RESULT, loadConfigSucceeded);
      loader.addEventListener(FaultEvent.FAULT, loadConfigFailed);
      loader.url = "data/templateConfiguration.xml";
      loader.send();
    }

    private function  getdefaultConfigurations():void{
      currentConfiguration = new CurrentConfigurationMO();

      for each(var sizeField:Object in sizeMeasures){
        if(sizeField.hasOwnProperty("default") && sizeField["default"] == true){
          currentConfiguration.selSizeMeasure = sizeField.field;
        }
      }

      for each(var colorField:Object in colorMeasures){
        if(colorField.hasOwnProperty("default") && colorField["default"] == true){
          currentConfiguration.selColorMeasure = colorField.field;
        }
      }

      for each(var hierarchy:Object in hierarchies){
        if(hierarchy.hasOwnProperty("default") && hierarchy["default"] == true){
          currentConfiguration.selLayerHierarchy = hierarchy.name;
        }
      }

    }

  }
}
