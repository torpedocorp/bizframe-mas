/**  
 *  Deserialize forms serialized with the Prototype JavaScript framework (version 1.5.0)
 *  (c) 2005 Pierpaolo Follia <pfollia@gmail.com>
 *
 *  This cado is freely distributable under the terms of an MIT-style license.
 *
 *  For details, see the my web site: http://madchicken.altervista.org/tech/
 *  deserialize.js,v 1.3 2006/05/12 09:15:57
 */

Object.extend(Form, {
	deserialize: function(form, data) {
		form = $(form);
		var tokens = data.split('&');

	    tokens.each(
	    	function(input, index) {
            	var	data = decodeURIComponent(input);
	    		data = data.split('=');
	    		var id = data[0];
	    		var value = data[1];
	    		if(id != form.id && value != 'undefined' && value != null)
					Form.Element.deserialize(id, value);
	    	}
	    );
	}
});

Object.extend(Form.Element, {
	deserialize: function(element, data) {
	    element = $(element);
	    if(element != null) {
		    var method = element.tagName.toLowerCase();
		    Form.Element.Deserializers[method](element, data);
		}
	}
});

Form.Element.Deserializers = {
  input: function(element, data) {
    switch (element.type.toLowerCase()) {
      case 'submit':
      case 'hidden':
      case 'password':
      case 'text':
        return Form.Element.Deserializers.textarea(element, data);
      case 'checkbox':
        return Form.Element.Deserializers.inputSelector(element, data);
      case 'radio':
        return Form.Element.Deserializers.radioSelector(element, data);
    }
    return false;
  },

  inputSelector: function(element, data) {
    element.checked = true;
  },

  radioSelector: function(element, data) {
    var name = element.name;
    var radiobuttons = Form.getInputs(element.form, 'radio', element.name);
    for(i = 0; i < radiobuttons.length; i++) {
      radiobutton = radiobuttons[i];
      if(radiobutton.value == data)
	radiobutton.checked = true;  
    }
  },

  textarea: function(element, data) {
    element.value = data;
  },

  select: function(element, data) {
    return Form.Element.Deserializers[element.type == 'select-one' ?
      'selectOne' : 'selectMany'](element, data);
  },

  selectOne: function(element, data) {
	element.value = data;
  },

  selectMany: function(element, data) {
    for(i = 0; i < element.options.length; i++) {
		op = element.options[i];
		op.selected = false;
        if(op.value == data)
        	op.selected = true;
    }
  }

}
