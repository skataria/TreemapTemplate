package controllers
{
  import flash.display.Loader;
  import flash.display.LoaderInfo;
  import flash.events.Event;
  import flash.net.URLRequest;

  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.http.HTTPService;
  import mx.styles.CSSStyleDeclaration;
  import mx.utils.StringUtil;
  import mx.core.Singleton;
  import mx.styles.StyleManager;

  import org.juicekit.util.helper.CSSUtil;

  public class StyleDetails
  {
    private var styleManager:IStyleManager2;
    private static const NOT_A_COLOR:uint = 0xFFFFFFFF;

    public function StyleDetails()
    {
      var skinLoader:HTTPService = new HTTPService();
      skinLoader.addEventListener(ResultEvent.RESULT, onLoadParseSkin);
      skinLoader.addEventListener(FaultEvent.FAULT, loadFailed);
      skinLoader.url = "data/dynamicSkin.xml";
      skinLoader.resultFormat = "e4x";
      skinLoader.send();
    }

     private function onLoadParseSkin(event:ResultEvent):void{
      var xml:XML = event.result as XML;
      trace("Loaded xml file. About to parse...");

      //Use loader to load swf file for font
      for each(var font:XML in xml.resources.font){
        const loader:Loader = new Loader();
        loader.load(new URLRequest(font.@url));
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);
      }

      function loaded(event:Event):void{
        trace("swf file loaded.");

        const loaderInfo:LoaderInfo = event.target as LoaderInfo;
        loaderInfo.removeEventListener(Event.COMPLETE, loaded);

        for each(var selector:XML in xml.styles.selector){
          var styleProperties:Object = new Object();
          for each(var prop:XML in selector.property){
            var name:String = prop.@name.toString();
            var value:String = prop.@value.toString();

            if(value.search(",") != -1){
              trace("comma separated value for: "+ name);
              var values:Array = value.split(",");

              for(var i:int = 0; i<values.length; i++){
                values[i] = StringUtil.trim(values[i]);
                var numVal:Number = Number(values[i]);
                if(!isNaN(numVal)){
                  values[i] = numVal;
                }
                else{
                  if (!styleManager){
                    styleManager = Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2;
                  }
                  var colorNumber:uint = styleManager.getColorName(values[i]);
                  if (colorNumber != NOT_A_COLOR) values[i] = colorNumber;
                }
              }
              styleProperties[name] = values;
            }

            else{
              var numValue:Number = Number(value);
              styleProperties[name] = isNaN(numValue) ? value : numValue;
            }
          }
          var styleDecl:CSSStyleDeclaration = CSSUtil.setStyleFor(selector.@name.toString(), styleProperties);
          trace("set style for: "+selector.@name);
        }
       }
      }

      private function loadFailed(event:FaultEvent):void{
        trace("Dynamic skin not loaded");
      }
  }
}
