Vue.component('toggle', {
  'props': ['disabled', 'component'],
  'data': function() {
    return {
      'toggleobject': null
    };
  },
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                <a v-on:click="onclick()">\
                  <input type="checkbox" :checked="component.value" data-onstyle="warning" v-if="component.type == \'ro\'" >\
                  <input type="checkbox" :checked="component.value" v-else-if="component.type == \'do\'">\
                </a>\
                <span class="label label-primary" v-if="component.type == \'di\' && component.value == 1" :readonly=disabled>On</span>\
                <span class="label label-default" v-else-if="component.type == \'di\' && component.value == 0" :readonly=disabled>Off</span>\
                <input type="text" class="col-md-6" v-model="component.name" v-if="this.$root.checked == true" disabled>\
                <input type="text" class="col-md-6" v-model="component.name" v-else>\
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
    return {
      barValue: 0,
      is_active: false,
    };
  },
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                <div class="col-md-4">\
                  <span class="label label-default col-md-3">{{ component.value }}</span>\
                  <input type="number" min="0" max="4095" v-model="barValue" v-if="component.type == \'ao\'">\
                </div>\
                <div class="col-md-4" v-if="component.type == \'ao\'">\
                 <input type="range" min="0" step="barValue" max="4095" v-model="barValue">\
                </div>\
                <div class="col-md-4">\
                  <button  v-on:click="onclick()" type="button" v-if="component.type == \'ao\'" :class="is_active == true ? \'btn btn-primary\' : \'btn btn-dafault\'" :disabled=!is_active>\
                    <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>\
                  </button>\
                  <input type="text" class="col-md-6" v-model="component.name" v-if="this.$root.checked == true" disabled>\
                  <input type="text" v-model="component.name" v-else>\
                </div>\
              </div>',
  'watch': {
    'barValue': function() {
      this.is_active = true
    }
  },
  'methods': {
    'onclick': function(data) {
      this.is_active = false;
      async_request('GET', this.$root.url + this.component.type + '/' + this.component.id + '/' +  'write?val=' + parseInt(this.barValue) , [], null, r => {this.component.value = JSON.parse(r).value;});
      }
    }
});


Vue.component('datetime', {
  'props': ['datenow', 'counter'],
  'template': '<span class="indicator">{{ datenow }} + {{ counter }}</span>',
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
    'current_interval': 10,
    'intervals': [10, 15, 30, 60],
    'status':[],
    'name_list': {},
    'url': 'http://172.22.9.13/api/',
    'checked': true,
    'interval': null,
    'barValue': 0,
    'counter': 0
  },
  'watch':{
    'interval': function() {}
  },
  computed: {
    'status_ordered': function () {
      obj = {}
      for (key in this.status) {
        obj[key] = _.orderBy(this.status[key], 'id');
      }
      return obj;
    }
  },
  'created': function () {
    this.get_status();
    this.interval = setInterval(this.tick, 1000)
  },
  'methods': {
    'tick': function() {
      if ( this.counter > 0 && this.counter % this.current_interval === 0 && this.checked == true) {
        this.get_status();
        this.counter = 0;
      }
      this.counter += 1;
    },
    'datetime': function() {
      var d = new Date();
      this.datenow = d.toLocaleTimeString('en-GB');
    },
    'refresh_onclick': function() {
      this.get_status();
    },
    'reset_onclick': function() {
      application = this;
      async_request('GET', this.url + 'reset' , [], null, function(response) {application.get_status();});
    },
    'get_status': function() {
      this.datetime();
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
        status_data_list = this.status_ordered[dictionary[key]]
        for (var i = name_list.length - 1; i >= 0; i--) {
          if (dictionary[key] == 'ro') {
            this.status_ordered[dictionary[key]][i].name = name_list[i].name;
          }
          if(parseInt(status_data_list[i].id) === parseInt( name_list[i].pin)){
            this.status_ordered[dictionary[key]][i].name = name_list[i].name;
          }
        }
      }
    },
    'update_checked': function() {
      if (this.checked === true) {
        this.checked = false;
      } else {
        this.update_name_onclick();
      }
    },
    'update_name_onclick': function() {
        data = JSON.stringify(this.status);
        request('POST', '/gui/update', [['Content-Type', 'application/json']], data);
        this.checked = true;
    },
    'interval_refresh_onclick': function(interval) {
      this.current_interval = interval;
    }
  }
});


