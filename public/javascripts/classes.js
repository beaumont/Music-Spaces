/*
-------------------------------------
what?: Classes < classes.js >
why?:  Javascript classes for Prototype	
when?: 1/30/2009

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
author: Kabari Hendrick < http://kabari.name >
legal: copyright 2008 You-Net-Works, Inc

-------------------------------------
*/

var Json = {};
Json.AutoComplete = Class.create({
	initialize: function(url, input, options){
		this.options = $H({
				list_class: "dataset",
				match_name: "some_field_to_check",
				lower_limit: 4,
				template: "#{some_field_to_check}"
		}).merge(options);
		
		this.list_position = 0;
		this.input = $(input);
		this.list_holder = new Element("ul", {"class": this.options.get('list_class')});
		this.list_holder.hide();
		this.input.insert({"after" : this.list_holder});
		this.template = new Template(this.options.get("template"));
		if(!Object.isArray(this.options.get("match_name"))) this.options.set("match_name", [this.options.get("match_name")]);
		new Ajax.Request( url,{
							method: "get",
							requestHeaders: {Accept: 'application/json'},
							onSuccess: function(transport){
								var json = transport.responseText.evalJSON(true);
								this.dataset = json;
								this.input.observe("keyup", this.find_matches.bindAsEventListener(this));
								this.input.observe("blur", function(){ this.list_holder.hide(); }.bind(this));
							}.bind(this)
						});			
	},
	find_matches: function(e){
			var code, val, matches;
			// get the key code for the event
			if (e.keyCode) code = e.keyCode;
			else if (e.which) code = e.which;
			
			val = this.input.getValue();
			if (!this.input.present() || val.length < this.options.get('lower_limit')) {
				this.list_holder.hide();
				return this.list_holder.update();
			};
			if ( (code == Event.KEY_UP || code == Event.KEY_DOWN) || (!$R(65,90).include(code) && code != Event.KEY_BACKSPACE)) { //lazy match
				return this.select_matches(code, e);
			};
			val = new RegExp(val, "i");
			matches = this.dataset.select(function(data, index) {
				return this.options.get("match_name").detect(function(m){ 
					return data[m].match(val); 
				});
			}, this);
			var set = [];
			matches.each(function(object , index){
				var match_obj = Object.clone(object);
				this.options.get('match_name').each(function(m) {
					var match_str = object[m];
					match_obj[m] = match_str.replace(val, function(match){
						return "<strong>"+match+"</strong>";
					});
				});
				var list_item = new Element("li").update(this.template.evaluate(match_obj));
				set.push(list_item);
			},this);
			this.list_holder.update();
			set.each(function(el){ this.list_holder.insert({'top': el}); }, this);
			if(set.length > 10) this.list_holder.addClassName('overflown');
			else this.list_holder.removeClassName('overflown');
			if(set.length > 0) this.list_holder.show();
	},
	select_matches: function(code, e){
		var el = this.list_holder.down(".selected") || this.list_holder.firstDescendant();
		if (code == Event.KEY_DOWN) {
			// this.input.blur();
			el.removeClassName("selected");
			if(el.next()) el.next().addClassName("selected");
		};
		if (code == Event.KEY_UP) {
			el.removeClassName("selected");
			if(el.previous()) el.previous().addClassName("selected");
			// else this.input.focus();
		};
		if (code == Event.KEY_RETURN) {
			if (el.hasClassName("selected")){
				Event.stop(e);
				location.href = el.down('a').href;
			}
		};
	}
});
