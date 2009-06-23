package models
{
  import flash.events.Event;
  import flash.events.EventDispatcher;

  import mx.binding.utils.BindingUtils;
  import mx.binding.utils.ChangeWatcher;
  import mx.collections.ArrayCollection;
  import mx.utils.StringUtil;

  [Bindable]
  public class CurrentConfigurationMO extends EventDispatcher
  {
    public var selSizeMeasure:String;
    public var selColorMeasure:String;
    public var selLayerHierarchy:String;
    public var layerHeaders:ArrayCollection;

    public function CurrentConfigurationMO()
    {
      this.selSizeMeasure = null;
      this.selColorMeasure = null;
      this.selLayerHierarchy = null;
      this.layerHeaders = new ArrayCollection();

      BindingUtils.bindSetter(updateHeaders, this, "selLayerHierarchy");
      ChangeWatcher.watch(layerHeaders, "list", test);
      ChangeWatcher.watch(this, 'layerHeaders', test);
    }

    private function updateHeaders(str:String):void{
      if(str){
        //layerHeaders = new ArrayCollection();
        layerHeaders.removeAll();
        var headers:Array = str.split(">");
        for each(var item:String in headers){
          item = StringUtil.trim(item);
          layerHeaders.addItem(item);
        }
        layerHeaders.refresh();
        trace("look at headers..");
      }
    }

    private function test(e:Event):void{
      trace("Headers just updated.");
    }

  }
}
