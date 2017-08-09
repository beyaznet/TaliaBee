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
  'props': ['disabled', 'component', 'value'],
  'template': '<div class="col-md-12 col-xs-12 col-sm-12">\
                <div class="col-md-4">\
                  <span class="label label-default col-md-3" v-if="component.type == \'ao\'">{{ component.value }}</span>\
                  <input type="text" maxlength="4" v-model="value" :disabled=disabled>\
                </div>\
                <div class="col-md-4" v-if="component.type == \'ao\'">\
                 <input type="range" min="0" step="value" max="4095" v-model="value">\
                </div>\
                <div class="col-md-4">\
                  <input type="text" class="col-md-6" v-model="component.name" v-if="this.$root.checked == true" disabled>\
                  <input type="text" class="col-md-6" v-model="component.name" v-else>\
                  <button  v-on:click="onclick()" type="button" v-if="component.type == \'ao\'" class="btn btn-primary">\
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>\
                  </button>\
                </div>\
              </div>',
  'methods': {
    'onclick': function(data) {
      async_request('GET', this.$root.url + this.component.type + '/' + this.component.id + '/' +  'write?val=' + parseInt(this.value) , [], null, r => {this.component.value = JSON.parse(r).value;});
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
    'current_interval': 10,
    'intervals': [10, 15, 30, 60],
    'status':{},
    'name_list': {},
    'url': 'http://172.22.9.13/api/',
    'checked': true,
    'interval': null,
    'barValue': 0
  },
  'created': function () {
    this.get_status();
    this.interval = setInterval(this.get_status, (this.current_interval * 1000))
  },
  'methods': {
    'datetime': function() {
      var d = new Date();
      this.datenow = d.toLocaleTimeString();
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
        status_data_list = this.status[dictionary[key]]
        for (var i = name_list.length - 1; i >= 0; i--) {

          if(parseInt(status_data_list[i].id) === parseInt( name_list[i].pin)){
            this.status[dictionary[key]][i].name = name_list[i].name;
          }
        }
      }
    },
    'update_checked': function() {
      if (this.checked === true) {
        clearInterval(this.interval)
        this.checked = false;
      } else {
        this.update_name_onclick();
      }
    },
    'update_name_onclick': function() {
        data = JSON.stringify(this.status);
        request('POST', '/gui/update', [['Content-Type', 'application/json']], data);
        this.checked = true;
        this.interval = setInterval(this.get_status, (this.current_interval * 1000))
    },
    'interval_refresh_onclick': function(interval) {
      this.current_interval = interval;
    }
  }
});


