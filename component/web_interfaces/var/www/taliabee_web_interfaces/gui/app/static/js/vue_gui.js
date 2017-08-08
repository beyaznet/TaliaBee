Vue.component('toggle', {
  'props': ['disabled', 'component'],
  'data': {
    'toggleobject': null
  },
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                <a v-on:click="onclick()">\
                  <input type="checkbox" :checked="component.value" data-onstyle="warning" v-if="component.type == \'ro\'" >\
                  <input type="checkbox" :checked="component.value" v-else-if="component.type == \'do\'">\
                </a>\
                <span class="label label-primary" v-if="component.type == \'di\' && component.value == 1" :readonly=disabled>On</span>\
                <span class="label label-default" v-else-if="component.type == \'di\' && component.value == 0" :readonly=disabled>Off</span>\
                <input type="text" class="col-md-6" v-model="component.name">\
              </div>',
  'watch': {
    'component': function() {
      this.toggleobject.bootstrapToggle(this.component.value === 1 ? 'on' : 'off');
    }
  },
  'mounted': function() {
    this.toggleobject = $(this.$el.children[0].children[0]).bootstrapToggle({'size': 'small'});
  },
  'methods': {
    'onclick': function() {
      if (this.component.value === 0) {
        method = 'set';
      } else {
        method = 'reset';
      }
      async_request('GET', this.$root.url + this.component.type + '/' + this.component.id + '/' +  method , [], null, r => {this.component.value = JSON.parse(r).value;});
    }
  }
});


Vue.component('analog-toggle', {
  'props': ['disabled', 'component'],
  'data': function() {
    return this.component;
  },
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                  <div class="input-group col-md-4">\
                    <input :value="value" :readonly="disabled" type="number" class="form-control">\
                    <span class="input-group-btn">\
                      </button>\
                    </span>\
                    <input type="text" class="col-md-6" v-model="name">\
                </div>\
              </div>',
  'methods': {
    'data_onclick': function(data) {
    }
  }
});

Vue.component('datetime', {
  'props': ['datenow'],
  'template': '<span class="indicator">{{ datenow }}</span>'
});

Vue.component('temperature', {
  'props': ['temp'],
  'template': '<span class="indicator">{{ temp }}°C</span>'
});

var app = new Vue({
  'el': '#app',
  'data': {
    'temperature': '',
    'datenow': '',
    'current_interval': 0,
    'intervals': [10, 15, 20],
    'status':{},
    'name_list': {},
    'url': 'http://172.22.9.13/api/',
  },
  'created': function () {
    this.get_status();
    this.datetime();
  },
  'methods': {
    'datetime': function() {
      var d = new Date();
      this.datenow = d.toLocaleTimeString();
    },
    'refresh_onclick': function() {
      this.get_status();
    },
    'interval_refresh_onclick': function() {
      this.current_interval = interval;
    },
    'reset_onclick': function() {
      application = this;
      async_request('GET', this.url + 'reset' , [], null, function(response) {application.get_status();});
    },
    'get_status': function() {
      application = this;
      async_request('GET', '/gui/status',  [], null, function (response) {
        status_data = JSON.parse(response);
        application.status = status_data.value;
        application.temperature = status_data.temperature;
        application.get_names();
      });
    },
    'get_names': function() {
      application = this;
      async_request('GET', '/gui/data',  [], null, function (response) {
        application.name_list = JSON.parse(response).data_list;
        application.update_names();
      });
    },
    'update_names': function() {
      var dictionary = {analog_output:'ao', analog_input: 'ai', digital_outputs: 'do',
                        digital_inputs: 'di', relay_outputs: 'ro'}

      for (var key in dictionary){
        name_list = this.name_list[key]
        status_data_list = this.status[dictionary[key]]

        for (var i = name_list.length - 1; i >= 0; i--) {
          if(parseInt(status_data_list[i].id) === parseInt( name_list[i].pin)){
            this.status[dictionary[key]][i].name = name_list[i].name;
          }
        }
      }
    },
    'update_name_onclick': function() {
      data = JSON.stringify(this.status)
      request('POST', '/gui/update', [['Content-Type', 'application/json']], data);
    }
  }
});


