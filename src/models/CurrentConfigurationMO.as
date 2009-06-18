package models
{
  import flash.events.EventDispatcher;

  [Bindable]
  public class CurrentConfigurationMO extends EventDispatcher
  {
    public var selSizeMeasure:String;
    public var selColorMeasure:String;
    public var selLayerHierarchy:String;

    public function CurrentConfigurationMO()
    {
      this.selSizeMeasure = null;
      this.selColorMeasure = null;
      this.selLayerHierarchy = null;
    }

  }
}
