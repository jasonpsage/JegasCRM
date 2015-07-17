/* begin Page */

/* Generated with Artisteer version 2.5.0.29918, file checksum is 99A6CD73. */

// required for IE7, #150675
if (window.addEvent) window.addEvent('domready', function() { });

var jasEventHelper = {
	'bind': function(obj, evt, fn) {
		if (obj.addEventListener)
			obj.addEventListener(evt, fn, false);
		else if (obj.attachEvent)
			obj.attachEvent('on' + evt, fn);
		else
			obj['on' + evt] = fn;
	}
};

var jasUserAgent = navigator.userAgent.toLowerCase();

var jasBrowser = {
	version: (jasUserAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [])[1],
	safari: /webkit/.test(jasUserAgent) && !/chrome/.test(jasUserAgent),
	chrome: /chrome/.test(jasUserAgent),
	opera: /opera/.test(jasUserAgent),
	msie: /msie/.test(jasUserAgent) && !/opera/.test(jasUserAgent),
	mozilla: /mozilla/.test(jasUserAgent) && !/(compatible|webkit)/.test(jasUserAgent)
};
 
jasCssHelper = function() {
    var is = function(t) { return (jasUserAgent.indexOf(t) != -1) };
    var el = document.getElementsByTagName('html')[0];
    var val = [(!(/opera|webtv/i.test(jasUserAgent)) && /msie (\d)/.test(jasUserAgent)) ? ('ie ie' + RegExp.$1)
    : is('firefox/2') ? 'gecko firefox2'
    : is('firefox/3') ? 'gecko firefox3'
    : is('gecko/') ? 'gecko'
    : is('chrome/') ? 'chrome'
    : is('opera/9') ? 'opera opera9' : /opera (\d)/.test(jasUserAgent) ? 'opera opera' + RegExp.$1
    : is('konqueror') ? 'konqueror'
    : is('applewebkit/') ? 'webkit safari'
    : is('mozilla/') ? 'gecko' : '',
    (is('x11') || is('linux')) ? ' linux'
    : is('mac') ? ' mac'
    : is('win') ? ' win' : ''
    ].join(' ');
    if (!el.className) {
     el.className = val;
    } else {
     var newCl = el.className;
     newCl += (' ' + val);
     el.className = newCl;
    }
} ();

(function() {
    // fix ie blinking
    var m = document.uniqueID && document.compatMode && !window.XMLHttpRequest && document.execCommand;
    try { if (!!m) { m('BackgroundImageCache', false, true); } }
    catch (oh) { };
})();

var jasLoadEvent = (function() {
    var list = [];

    var done = false;
    var ready = function() {
        if (done) return;
        done = true;
        for (var i = 0; i < list.length; i++)
            list[i]();
    };

    if (document.addEventListener && !jasBrowser.opera)
        document.addEventListener('DOMContentLoaded', ready, false);

    if (jasBrowser.msie && window == top) {
        (function() {
            try {
                document.documentElement.doScroll('left');
            } catch (e) {
                setTimeout(arguments.callee, 10);
                return;
            }
            ready();
        })();
    }

    if (jasBrowser.opera) {
        document.addEventListener('DOMContentLoaded', function() {
            for (var i = 0; i < document.styleSheets.length; i++) {
                if (document.styleSheets[i].disabled) {
                    setTimeout(arguments.callee, 10);
                    return;
                }
            }
            ready();
        }, false);
    }

    if (jasBrowser.safari || jasBrowser.chrome) {
        var numStyles;
        (function() {
            if (document.readyState != 'loaded' && document.readyState != 'complete') {
                setTimeout(arguments.callee, 10);
                return;
            }
            if ('undefined' == typeof numStyles) {
                numStyles = document.getElementsByTagName('style').length;
                var links = document.getElementsByTagName('link');
                for (var i = 0; i < links.length; i++) {
                    numStyles += (links[i].getAttribute('rel') == 'stylesheet') ? 1 : 0;
                }
                if (document.styleSheets.length != numStyles) {
                    setTimeout(arguments.callee, 0);
                    return;
                }
            }
            ready();
        })();
    }

    if (!(jasBrowser.msie && window != top)) { // required for Blogger Page Elements in IE, #154540
        jasEventHelper.bind(window, 'load', ready);
    }
    return ({
        add: function(f) {
            list.push(f);
        }
    })
})();


function jasGetElementsByClassName(clsName, parentEle, tagName) {
	var elements = null;
	var found = [];
	var s = String.fromCharCode(92);
	var re = new RegExp('(?:^|' + s + 's+)' + clsName + '(?:$|' + s + 's+)');
	if (!parentEle) parentEle = document;
	if (!tagName) tagName = '*';
	elements = parentEle.getElementsByTagName(tagName);
	if (elements) {
		for (var i = 0; i < elements.length; ++i) {
			if (elements[i].className.search(re) != -1) {
				found[found.length] = elements[i];
			}
		}
	}
	return found;
}

var _jasStyleUrlCached = null;
function jasGetStyleUrl() {
    if (null == _jasStyleUrlCached) {
        var ns;
        _jasStyleUrlCached = '';
        ns = document.getElementsByTagName('link');
        for (var i = 0; i < ns.length; i++) {
            var l = ns[i];
            if (l.href && /style\.ie6\.css(\?.*)?$/.test(l.href)) {
                return _jasStyleUrlCached = l.href.replace(/style\.ie6\.css(\?.*)?$/, '');
            }
        }

        ns = document.getElementsByTagName('style');
        for (var i = 0; i < ns.length; i++) {
            var matches = new RegExp('import\\s+"([^"]+\\/)style\\.ie6\\.css"').exec(ns[i].innerHTML);
            if (null != matches && matches.length > 0)
                return _jasStyleUrlCached = matches[1];
        }
    }
    return _jasStyleUrlCached;
}

function jasFixPNG(element) {
	if (jasBrowser.msie && jasBrowser.version < 7) {
		var src;
		if (element.tagName == 'IMG') {
			if (/\.png$/.test(element.src)) {
				src = element.src;
				element.src = jasGetStyleUrl() + 'images/spacer.gif';
			}
		}
		else {
			src = element.currentStyle.backgroundImage.match(/url\("(.+\.png)"\)/i);
			if (src) {
				src = src[1];
				element.runtimeStyle.backgroundImage = 'none';
			}
		}
		if (src) element.runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "')";
	}
}

function jasHasClass(el, cls) {
	return (el && el.className && (' ' + el.className + ' ').indexOf(' ' + cls + ' ') != -1);
}
/* end Page */

/* begin Menu */
function jasGTranslateFix() {
	var menus = jasGetElementsByClassName("jas-menu", document, "ul");
	for (var i = 0; i < menus.length; i++) {
		var menu = menus[i];
		var childs = menu.childNodes;
		var listItems = [];
		for (var j = 0; j < childs.length; j++) {
			var el = childs[j];
			if (String(el.tagName).toLowerCase() == "li") listItems.push(el);
		}
		for (var j = 0; j < listItems.length; j++) {
			var item = listItems[j];
			var a = null;
			var gspan = null;
			for (var p = 0; p < item.childNodes.length; p++) {
				var l = item.childNodes[p];
				if (!(l && l.tagName)) continue;
				if (String(l.tagName).toLowerCase() == "a") a = l;
				if (String(l.tagName).toLowerCase() == "span") gspan = l;
			}
			if (gspan && a) {
				var t = null;
				for (var k = 0; k < gspan.childNodes.length; k++) {
					var e = gspan.childNodes[k];
					if (!(e && e.tagName)) continue;
					if (String(e.tagName).toLowerCase() == "a" && e.firstChild) e = e.firstChild;
					if (e && e.className && e.className == 't') {
						t = e;
						if (t.firstChild && t.firstChild.tagName && String(t.firstChild.tagName).toLowerCase() == "a") {
							while (t.firstChild.firstChild) t.appendChild(t.firstChild.firstChild);
							t.removeChild(t.firstChild);
						}
						a.appendChild(t);
						break;
					}
				}
				gspan.parentNode.removeChild(gspan);
			}
		}
	}
}
jasLoadEvent.add(jasGTranslateFix);

function jasAddMenuSeparators() {
	var menus = jasGetElementsByClassName("jas-menu", document, "ul");
	for (var i = 0; i < menus.length; i++) {
		var menu = menus[i];
		var childs = menu.childNodes;
		var listItems = [];
		for (var j = 0; j < childs.length; j++) {
			var el = childs[j];
			if (String(el.tagName).toLowerCase() == "li") listItems.push(el);
		}
		for (var j = 0; j < listItems.length - 1; j++) {
			var item = listItems[j];
			var span = document.createElement('span');
			span.className = 'jas-menu-separator';
			var li = document.createElement('li');
			li.className = 'jas-menu-li-separator';
			li.appendChild(span);
			item.parentNode.insertBefore(li, item.nextSibling);
		}
	}
}
jasLoadEvent.add(jasAddMenuSeparators);

function jasMenuIE6Setup() {
	var isIE6 = navigator.userAgent.toLowerCase().indexOf("msie") != -1
    && navigator.userAgent.toLowerCase().indexOf("msie 7") == -1;
	if (!isIE6) return;
	var aTmp2, i, j, oLI, aUL, aA;
	var aTmp = jasGetElementsByClassName("jas-menu", document, "ul");
	for (i = 0; i < aTmp.length; i++) {
		aTmp2 = aTmp[i].getElementsByTagName("li");
		for (j = 0; j < aTmp2.length; j++) {
			oLI = aTmp2[j];
			aUL = oLI.getElementsByTagName("ul");
			if (aUL && aUL.length) {
				oLI.UL = aUL[0];
				aA = oLI.getElementsByTagName("a");
				if (aA && aA.length)
					oLI.A = aA[0];
				oLI.onmouseenter = function() {
					this.className += " jas-menuhover";
					this.UL.className += " jas-menuhoverUL";
					if (this.A) this.A.className += " jas-menuhoverA";
				};
				oLI.onmouseleave = function() {
					this.className = this.className.replace(/jas-menuhover/, "");
					this.UL.className = this.UL.className.replace(/jas-menuhoverUL/, "");
					if (this.A) this.A.className = this.A.className.replace(/jas-menuhoverA/, "");
				};
			}
		}
	}
}
jasLoadEvent.add(jasMenuIE6Setup);
/* end Menu */

/* begin Layout */
function jasLayoutIESetup() {
    var isIE = navigator.userAgent.toLowerCase().indexOf("msie") != -1;
    if (!isIE) return;
    var q = jasGetElementsByClassName("jas-content-layout", document, "div");
    if (!q || !q.length) return;
    for (var i = 0; i < q.length; i++) {
        var l = q[i];
        var l_childs = l.childNodes;
        var r = null;
        for (var p = 0; p < l_childs.length; p++) {
            var l_ch = l_childs[p];
            if ((String(l_ch.tagName).toLowerCase() == "div") && jasHasClass(l_ch, "jas-content-layout-row")) {
                r = l_ch;
                break;
            }
        }
        if (!r) continue;
        var c = [];
        var r_childs = r.childNodes;
        for (var o = 0; o < r_childs.length; o++) {
            var r_ch = r_childs[o];
            if ((String(r_ch.tagName).toLowerCase() == "div") && jasHasClass(r_ch, "jas-layout-cell")) {
                c.push(r_ch);
            }
        }
        if (!c || !c.length) continue;
        var table = document.createElement("table");
        table.className = l.className;
        var row = table.insertRow(-1);
        table.className = l.className;
        for (var j = 0; j < c.length; j++) {
            var cell = row.insertCell(-1);
            var s = c[j];
            cell.className = s.className;
            while (s.firstChild) {
                cell.appendChild(s.firstChild);
            }
        }
        l.parentNode.insertBefore(table, l);
        l.parentNode.removeChild(l);
    }
}
jasLoadEvent.add(jasLayoutIESetup);
/* end Layout */

/* begin VMenu */
function jasAddVMenuSeparators() {
    var create_VSeparator = function(sub, first) {
        var cls = 'jas-v' + (sub ? "sub" : "") + 'menu-separator';
        var li = document.createElement('li');
        li.className = (first ? (cls + " " + cls + " jas-vmenu-separator-first") : cls);
        var span = document.createElement('span');
        span.className = cls+'-span';
        li.appendChild(span);
        return li;
    };
	var menus = jasGetElementsByClassName("jas-vmenublock", document, "div");
	for (var k = 0; k < menus.length; k++) {
		var uls = menus[k].getElementsByTagName("ul");
		for (var i = 0; i < uls.length; i++) {
			var ul = uls[i];
			var childs = ul.childNodes;
			var listItems = [];
			for (var y = 0; y < childs.length; y++) {
				var el = childs[y];
				if (String(el.tagName).toLowerCase() == "li") listItems.push(el);
            }
    		for (var j = 0; j < listItems.length; j++) {
			    var item = listItems[j];
			    if ((item.parentNode.getElementsByTagName("li")[0] == item) && (item.parentNode != uls[0]))
			        item.parentNode.insertBefore(create_VSeparator(item.parentNode.parentNode.parentNode != uls[0], true), item);
			    if (j < listItems.length - 1)
			        item.parentNode.insertBefore(create_VSeparator(item.parentNode != uls[0], false), item.nextSibling);
			}
		}
	}
}
jasLoadEvent.add(jasAddVMenuSeparators);

/* end VMenu */

/* begin VMenuItem */
function jasVMenu() {
    var menus = jasGetElementsByClassName("jas-vmenu", document, "ul");
    for (var k = 0; k < menus.length; k++) {
        var vmenu = menus[k];
        vmenu.uls = vmenu.getElementsByTagName("ul");
        vmenu.items = vmenu.getElementsByTagName("li");
        vmenu.alinks = vmenu.getElementsByTagName("a");
        
        for (var x = 0; x < vmenu.items.length; x++) {
            var li = vmenu.items[x];
            li.className = li.className.replace(/active/, "").replace("  ", " ");
            for (var s = 0; s < li.childNodes.length; s++) {
                var ch = li.childNodes[s];
                if (!(ch && ch.tagName)) continue;
                if (String(ch.tagName).toLowerCase() == "a") {
                    if (ch.href == window.location.href)
                       vmenu.active = li;
                    li.a = ch;
                }
                if (String(ch.tagName).toLowerCase() == "ul") 
                    li.ul = ch;
                ch.className = ch.className.replace(/active/, "").replace("  ", " ");
            }
        }
        if (!vmenu.active) return;
        if (vmenu.active.ul) vmenu.active.ul.className += " active";
        var parent = vmenu.active;
        while (parent && parent != vmenu) {
            parent.className += " active";
            if (parent.a) parent.a.className += " active";
            parent = parent.parentNode;
        }
    }
}

jasLoadEvent.add(jasVMenu);
/* end VMenuItem */

/* begin Button */

function jasButtonsSetupJsHover(className) {
	var tags = ["input", "a", "button"];
	for (var j = 0; j < tags.length; j++){
		var buttons = jasGetElementsByClassName(className, document, tags[j]);
		for (var i = 0; i < buttons.length; i++) {
			var button = buttons[i];
			if (!button.tagName || !button.parentNode) return;
			if (!jasHasClass(button.parentNode, 'jas-button-wrapper')) {
				if (!jasHasClass(button, 'jas-button')) button.className += ' jas-button';
				var wrapper = document.createElement('span');
				wrapper.className = "jas-button-wrapper";
				if (jasHasClass(button, 'active')) wrapper.className += ' active';
				var spanL = document.createElement('span');
				spanL.className = "l";
				spanL.innerHTML = " ";
				wrapper.appendChild(spanL);
				var spanR = document.createElement('span');
				spanR.className = "r";
				spanR.innerHTML = " ";
				wrapper.appendChild(spanR);
				button.parentNode.insertBefore(wrapper, button);
				wrapper.appendChild(button);
			}
			jasEventHelper.bind(button, 'mouseover', function(e) {
				e = e || window.event;
				wrapper = (e.target || e.srcElement).parentNode;
				wrapper.className += " hover";
			});
			jasEventHelper.bind(button, 'mouseout', function(e) {
				e = e || window.event;
				button = e.target || e.srcElement;
				wrapper = button.parentNode;
				wrapper.className = wrapper.className.replace(/hover/, "");
				if (!jasHasClass(button, 'active')) wrapper.className = wrapper.className.replace(/active/, "");
			});
			jasEventHelper.bind(button, 'mousedown', function(e) {
				e = e || window.event;
				button = e.target || e.srcElement;
				wrapper = button.parentNode;
				if (!jasHasClass(button, 'active')) wrapper.className += " active";
			});
			jasEventHelper.bind(button, 'mouseup', function(e) {
				e = e || window.event;
				button = e.target || e.srcElement;
				wrapper = button.parentNode;
				if (!jasHasClass(button, 'active')) wrapper.className = wrapper.className.replace(/active/, "");
			});
		}
	}
}

jasLoadEvent.add(function() { jasButtonsSetupJsHover("jas-button"); });
/* end Button */


  //--------------------------------------------
  // COLORS - BINARY FLAGS DECIDE
  // Task      1
  // Meeting  10
  // Call    100
  //--------------------------------------------
  var arColor=new Array(8);
  arColor[0]='';         // nothing
  arColor[1]='#AA5500';  // Task
  arColor[2]='#0066CC';  // meeting
  arColor[3]='#FF00FF';  // Task+Meeting
  arColor[4]='#33CC33';  // Call
  arColor[5]='#CC9900';  // Task+Call
  arColor[6]='#33FF66';  // Meeting+Call
  arColor[7]='#FF0300';  // Task+Meeting+Call
  //--------------------------------------------
