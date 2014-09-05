package thx.stream.dom;

using StringTools;
using thx.stream.Emitter;
import js.html.*;

class Dom {
  public static function streamEvent<TEvent : Event>(el : Element, name : String, capture = false) : Emitter<TEvent>
    return Emitter.create(function(stream) {
      el.addEventListener(name, stream.pulse, capture);
      stream.addCleanUp(function() el.removeEventListener(name, stream.pulse, capture));
    });

  public inline static function streamMouseEvent(el : Element, name : String, capture = false) : Emitter<MouseEvent>
    return streamEvent(el, name, capture);

  public static function streamKey(el : Element, name : String, capture = false) : Emitter<KeyboardEvent>
    return Emitter.create({
      if(!name.startsWith('key'))
        name = 'key$name';
      function(stream) {
        el.addEventListener(name, stream.pulse, capture);
        stream.addCleanUp(function() el.removeEventListener(name, stream.pulse, capture));
      }
    });

  public inline static function streamClick(el : Element, capture = false) : Emitter<MouseEvent>
    return streamMouseEvent(el, 'click', capture);

  public static function subscribeText(el : Element) : String -> Void
    return function(text : String) el.innerText = text;

  public static function subscribeHTML(el : Element) : String -> Void
    return function(html : String) el.innerHTML = html;

  public static function subscribeFocus(el : Element) : Bool -> Void
    return function(focus : Bool) if(focus) el.focus() else el.blur();

  public static function subscribeAttribute<T>(el : Element, name : String) : T -> Void
    return function(value : T) if(null == value) el.removeAttribute(name) else el.setAttribute(name, cast value);

  public static function subscribeToggleAttribute<T>(el : Element, name : String, ?value : T) : Bool -> Void {
    if(null == value)
      value = cast el.getAttribute(name);
    return function(on) if(on) el.removeAttribute(name) else el.setAttribute(name, cast value);
  }

  public static function subscribeToggleVisibility(el : Element) : Bool -> Void {
    var originalDisplay = el.style.display;
    if(originalDisplay == 'none')
      originalDisplay = '';
    return function(on) if(on) el.style.display = originalDisplay else el.style.display = 'none';
  }
}