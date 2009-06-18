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
    public var layerHierarchy:ArrayCollection = null;
    public var currentConfiguration:CurrentConfigurationMO = null;

    /*
    public var layerHeaders:ArrayCollection = null;
    */

    public function ConfigurationParametersMO()
    {
      //currentConfig = new CurrentConfigurationMO();
      function loadConfigSucceeded(event:ResultEvent):void{
        sizeMeasures = new ArrayCollection(event.result.configuration.sizeSelectors.sizeField.source);
        colorMeasures = new ArrayCollection(event.result.configuration.colorSelectors.colorField.source);
        layerHierarchy = new ArrayCollection(event.result.configuration.orderBy.option.source);
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
  }
}
