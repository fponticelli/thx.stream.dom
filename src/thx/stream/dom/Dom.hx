package thx.stream.dom;

using StringTools;
import js.html.DOMElement as Element;
import js.html.MouseEvent;
import js.html.KeyboardEvent;
import js.html.InputElement;
import js.html.Event;
using thx.core.Nil;
using thx.stream.Emitter;
using thx.promise.Promise;

class Dom {
  public static function ready() : Promise<Nil>
    return Promise.create(function(resolve, _) {
      js.Browser.document.addEventListener("DOMContentLoaded", function(_) {
        resolve(nil);
      }, false);
    });

  public inline static function streamClick(el : Element, capture = false) : Emitter<MouseEvent>
    return streamMouseEvent(el, 'click', capture);

  public static function streamEvent<TEvent : Event>(el : Element, name : String, capture = false) : Emitter<TEvent>
    return new Emitter(function(stream) {
      el.addEventListener(name, stream.pulse, capture);
      stream.addCleanUp(function() el.removeEventListener(name, stream.pulse, capture));
    });

  public static function streamFocus(el : Element, capture = false) : Emitter<Bool>
    return streamEvent(el, 'focus', capture).toTrue().merge(streamEvent(el, 'blur', capture).toFalse());

  public static function streamKey(el : Element, name : String, capture = false) : Emitter<KeyboardEvent>
    return new Emitter({
      if(!name.startsWith('key'))
        name = 'key$name';
      function(stream) {
        el.addEventListener(name, stream.pulse, capture);
        stream.addCleanUp(function() el.removeEventListener(name, stream.pulse, capture));
      }
    });

  public inline static function streamChecked(el : InputElement, capture = false) : Emitter<Bool>
    return streamEvent(el, 'change', capture).map(function(_) return el.checked);

  public inline static function streamChange(el : InputElement, capture = false) : Emitter<String>
    return streamEvent(el, 'change', capture).map(function(_) return el.value);

  public inline static function streamInput(el : InputElement, capture = false) : Emitter<String>
    return streamMouseEvent(el, 'input', capture).map(function(_) return el.value);

  public inline static function streamMouseDown(el : Element, capture = false) : Emitter<MouseEvent>
    return streamEvent(el, "mousedown", capture);

  public inline static function streamMouseEvent(el : Element, name : String, capture = false) : Emitter<MouseEvent>
    return streamEvent(el, name, capture);

  public inline static function streamMouseMove(el : Element, capture = false) : Emitter<MouseEvent>
    return streamEvent(el, "mousemove", capture);

  public inline static function streamMouseUp(el : Element, capture = false) : Emitter<MouseEvent>
    return streamEvent(el, "mouseup", capture);

  public static function subscribeAttribute<T>(el : Element, name : String) : T -> Void
    return function(value : T) if(null == value) el.removeAttribute(name) else el.setAttribute(name, cast value);

  public static function subscribeFocus(el : Element) : Bool -> Void
    return function(focus : Bool) if(focus) el.focus() else el.blur();

  public static function subscribeHTML(el : Element) : String -> Void
    return function(html : String) el.innerHTML = html;

  public static function subscribeText(el : Element, force = false) : String -> Void
    return function(text : String) if(el.textContent != text || force) el.textContent = text;

  public static function subscribeToggleAttribute<T>(el : Element, name : String, ?value : T) : Bool -> Void {
    if(null == value)
      value = cast el.getAttribute(name);
    return function(on) if(on) el.setAttribute(name, cast value) else el.removeAttribute(name);
  }

  public static function subscribeToggleClass(el : Element, name : String) : Bool -> Void
    return function(on) if(on) el.classList.add(name) else el.classList.remove(name);

  public static function subscribeSwapClass(el : Element, nameOn : String, nameOff : String) : Bool -> Void
    return function(on) if(on) {
        el.classList.add(nameOn);
        el.classList.remove(nameOff);
      } else {
        el.classList.add(nameOff);
        el.classList.remove(nameOn);
      };

  public static function subscribeToggleVisibility(el : Element) : Bool -> Void {
    var originalDisplay = el.style.display;
    if(originalDisplay == 'none')
      originalDisplay = '';
    return function(on) if(on) el.style.display = originalDisplay else el.style.display = 'none';
  }
}