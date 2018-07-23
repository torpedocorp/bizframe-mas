var errorWindow = null;
var errorText;
var buttons;
function error(text, reverse) {
	if (errorWindow == null)
 		return;

	clearError();
	var time = new Date();
	var timeStr = time.toLocaleString();
	if (reverse) {
		$('error').innerHTML = timeStr + " - <p>" + text + "<br>"
			+ $('error').innerHTML;
		errorWindow.getContent().scrollTop=0;
	} else {
		$('error').innerHTML += timeStr + " - <p>" + text + "<br>";
		errorText = timeStr + " - <p>" + text + "<br>";
		errorWindow.getContent().scrollTop=10000; // Far away
	}
}

function hideError() {
	if (errorWindow) {
		errorWindow.destroy();
		errorWindow = null;
	}
}

function _showError(errorText, title, okStr, cancelStr) {
	var date;
	if (errorWindow == null) {
		errorWindow = new Window('error_window',
				{
				className: "error",
				width:550,
				height:300,
				closable:false,
				maximizable:false,
				//minimizable:true,
			   	//right:4,
			   	//bottom:42,
			   	zIndex:1000,
			   	opacity:1,
			   	showEffect: Element.show,
			   	//hideEffect: Element.hide,
				buttonClass: "errorButtonClass",
			   	resizable: false,
			   	//recenterAuto: true,
				title: title
				})
		errorWindow.getContent().innerHTML = "<style>#error_window .error_content {background:#a0a0a0;}</style> <div id='error'></div> <div id='errorButtonId'></div>";
		var okButtonClass = "class ='errorButtonClass ok_button'"
		var cancelButtonClass = "class ='errorButtonClass cancel_button'"
		buttons = "\
			<div class='error_buttons'>\
			<input type='button' value='" + okStr + "' onclick='submitError()' " + okButtonClass + "/>\
			<input type='button' value='" + cancelStr + "' onclick='ignoreError()' " + cancelButtonClass + "/>\
			</div>\
			"//;
	}

	clearError();
	var time = new Date();
	var timeStr = time.toLocaleString();
	//errorText = timeStr + " - <p>" + errorText + "<br>";
	$('error').innerHTML =
		"<textarea id = 'errdlg' wrap='off' style='width:100%; height: 240px;'> "
		+ "--- " + timeStr + " --- \n"
		+ errorText
		+ "</textarea><br>";
	$('errorButtonId').innerHTML = " <p>" + buttons;
	errorWindow.getContent().scrollTop=10000; // Far away

	errorWindow.showCenter(false);
}

function _showErrorPopup(errorText, title, okStr, cancelStr) {
	var date;
	if (errorWindow == null) {
		errorWindow = new Window('error_window',
				{
				className: "error",
				width:550,
				height:300,
				closable:false,
				maximizable:false,
				//minimizable:true,
			   	//right:4,
			   	//bottom:42,
			   	zIndex:1000,
			   	opacity:1,
			   	showEffect: Element.show,
			   	//hideEffect: Element.hide,
				buttonClass: "errorButtonClass",
			   	resizable: false,
			   	//recenterAuto: true,
				title: title
				})
		errorWindow.getContent().innerHTML = "<style>#error_window .error_content {background:#a0a0a0;}</style> <div id='error'></div> <div id='errorButtonId'></div>";
		var okButtonClass = "class ='errorButtonClass ok_button'"
		var cancelButtonClass = "class ='errorButtonClass cancel_button'"
		buttons = "\
			<div class='error_buttons'>\
			<input type='button' value='" + okStr + "' onclick='submitError()' " + okButtonClass + "/>\
			<input type='button' value='" + cancelStr + "' onclick='hideError()' " + cancelButtonClass + "/>\
			</div>\
			"//;
	}

	clearError();
	var time = new Date();
	var timeStr = time.toLocaleString();
	//errorText = timeStr + " - <p>" + errorText + "<br>";
	$('error').innerHTML = errorText
	$('errorButtonId').innerHTML = " <p>" + buttons;
	errorWindow.getContent().scrollTop=10000; // Far away

	errorWindow.showCenter(false);
}



function clearError() {
	if (errorWindow == null)
 		return;
	$('error').innerHTML = "";
}

function submitError() {
	document.getElementById("command").value = "ok";
	document.errorReport.submit();
}

function ignoreError() {
	document.getElementById("command").value = "cancel";
	document.errorReport.submit();
}

/**
 * document.createElement convenience wrapper
 *
 * The data parameter is an object that must have the "tag" key, containing
 * a string with the tagname of the element to create.  It can optionally have
 * a "children" key which can be: a string, "data" object, or an array of "data"
 * objects to append to this element as children.  Any other key is taken as an
 * attribute to be applied to this tag.
 *
 * Available under an MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * @param {Object} data The data representing the element to create
 * @return {Element} The element created.
 */
function $E(data) {
	var el;
	if ('string'==typeof data) {
		el=document.createTextNode(data);
	} else {
		//create the element
		el=document.createElement(data.tag);
		delete(data.tag);

		//append the children
		if ('undefined'!=typeof data.children) {
			if ('string'==typeof data.children ||'undefined'==typeof data.children.length) {
				//strings and single elements
				el.appendChild($E(data.children));
			} else {
				//arrays of elements
				for (var i=0, child=null; 'undefined'!=typeof (child=data.children[i]); i++) {
					el.appendChild($E(child));
				}
			}
			delete(data.children);
		}

		//any other data is attributes
		for (attr in data) {
			el[attr]=data[attr];
		}
	}

	return el;
}

// FROM Nick Hemsley
var Error = {
	inspectOutput: function (container, within) {
		within = within || errorWindow.getContent()

		if (errorWindow == null)
 			return;

		within.appendChild(container)
	},

	inspect: function(object) {
		var cont = $E({tag: "div", className: "inspector"})
		Error.inspectObj(object, cont)
		errorWindow.getContent().appendChild(cont)
	},

	inspectObj: function (object, container) {
		for (prop in object) {
			Error.inspectOutput(Error.inspectable(object, prop), container)
		}
	},

	inspectable: function(object, prop) {
		cont = $E({tag: 'div', className: 'inspectable', children: [prop + " value: " + object[prop] ]})
		cont.toInspect = object[prop]
		Event.observe(cont, 'click', Error.inspectClicked, false)
		return cont
	},

	inspectClicked: function(e) {
		Error.inspectContained(Event.element(e))
		Event.stop(e)
	},

	inspectContained: function(container) {
		if (container.opened) {
			container.parentNode.removeChild(container.opened)
			delete(container.opened)
		} else {
			sibling = container.parentNode.insertBefore($E({tag: "div", className: "child"}), container.nextSibling)
			if (container.toInspect)
				Error.inspectObj(container.toInspect, sibling)
			container.opened = sibling
		}
	}
}
var inspect = Error.inspect;
