Vue.component('toggle', {
  'props': ['disabled', 'component'],
  'data': function() {
    return {
      'value': this.component.value,
      'name': this.component.name,
      'type': this.component.type,
      'id': this.component.id};
  },
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                <a v-on:click="onclick()">\
                  <input data-size="small" v-if="this.type == \'ro\'" data-onstyle="warning"  type="checkbox" data-toggle="toggle" :checked="this.value">\
                  <input data-size="small" v-else-if="this.type == \'do\'" type="checkbox" data-toggle="toggle" :checked="this.value">\
                </a>\
                <span class="label label-primary" v-if="this.type == \'di\' && this.value == 1" :readonly=disabled>On</span>\
                <span class="label label-default" v-else-if="this.type == \'di\' && this.value == 0" :readonly=disabled>Off</span>\
                <input type="text" class="col-md-6" :value="this.name">\
              </div>',
  'methods': {
    'onclick': function() {
      if (this.value === 0) {
        method = 'set';
      } else {
        method = 'reset';
      }
      async_request('GET', this.$root.url + this.type + '/' + this.id + '/' +  method , [], null, r => {console.log(this); this.value = JSON.parse(r).value;});

    }
  }
});



Vue.component('analog-toggle', {
  'props': ['name', 'value', 'disabled', 'component', 'show'],
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                  <div class="input-group col-md-4">\
                    <input :value="value" :readonly="disabled" type="number" class="form-control">\
                    <span class="input-group-btn">\
                      </button>\
                    </span>\
                    <input type="text" class="col-md-6" :value="name">\
                </div>\
              </div>',
  'methods': {
    'data_onclick': function(data) {
      console.log(data);
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
    'digital_outputs': {},
    'digital_inputs': {},
    'analog_outputs': {},
    'analog_inputs': {},
    'relay_outputs': {},
    'temperature': '',
    'datenow': '',
    'current_interval': 0,
    'intervals': [10, 15, 20],
    'status':{},
    'name_list': '',
    'url': 'http://172.22.9.13/api/',
  },
  'created': function () {
    this.status_onclick();
    this.created_datetime();
  },
  'methods': {
    'created_datetime': function() {
      var d = new Date();
      this.datenow = d.toLocaleTimeString();
    },
    'refresh_onclick': function() {
      this.status_onclick();
    },
    'interval_refresh_onclick': function() {
      this.current_interval = interval;
    },
    'reset_onclick': function() {
      // app.digital_outputs = {};
      request('GET', this.url + 'reset' , [], null);
      this.status_onclick();
    },
    'status_callback': function (response) {
      this.created_datetime();
      this.status = JSON.parse(response).value;
      this.temperature = JSON.parse(response).temperature;
    },
    'status_onclick': function() {
      async_request('GET', '/gui/status',  [], null, this.status_callback);
      this.data_name_onclick();

    },
    'data_name_callback': function (response) {
      this.name_list = JSON.parse(response).data_list;
      this.fill_data();
    },
    'data_name_onclick': function() {
      async_request('GET', '/gui/data',  [], null, this.data_name_callback);
    },
    'fill_data': function() {
      var dictionary = {analog_output:'ao', analog_input: 'ai',
                        digital_outputs: 'do', digital_inputs: 'di', relay_outputs: 'ro'}

      for (var key in dictionary){
        name_list = this.name_list[key]
        status_data_list = this.status[dictionary[key]]
        for (var i = name_list.length - 1; i >= 0; i--) {
          if(parseInt(status_data_list[i].id) === parseInt( name_list[i].pin)){
            this.status[dictionary[key]][i].name = name_list[i].name;
          }
        }
      }
      this.data_set();
    },
    'data_set': function() {
      this.digital_outputs = this.status['do'];
      this.digital_inputs = this.status['di'];
      this.analog_inputs = this.status['ai'];
      this.analog_outputs = this.status['ao'];
      this.relay_outputs = this.status['ro'];
    }
  }
});


