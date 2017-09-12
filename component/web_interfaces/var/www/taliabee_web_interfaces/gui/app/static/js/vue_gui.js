Vue.component('toggle', {
  'props': ['disabled', 'component'],
  'data': function() {
     return {
       'toggleobject': null
     };
  },
  'template': '<div class="no-side-space col-md-12 col-sm-12 col-xs-12">\
           <div class="no-side-space col-md-4 col-sm-4 col-xs-4" v-if="component.type == \'di\'">\
             <span class="label label-default label-digital" :readonly=disabled v-if="component.value == 0">Off</span>\
             <span class="label label-primary label-digital" :readonly=disabled v-else>On</span>\
           </div>\
           <div class="no-side-space col-md-4 col-sm-4 col-xs-4" v-else>\
                   <a v-on:click="onclick()">\
               <input type="checkbox" :checked="component.value" data-onstyle="warning" v-if="component.type == \'ro\'" >\
               <input type="checkbox" :checked="component.value" v-else>\
             </a>\
           </div>\
           <div class="no-side-space space-on-top col-md-8 col-sm-8 col-xs-8">\
                   <input type="text" v-model="component.name" v-if="this.$root.checked == true" disabled>\
             <input type="text" v-model="component.name" v-else>\
           </div>\
               </div>',
  'watch': {
    'component': function() {
    if (this.component.type === 'do' || this.component.type === 'ro') {
      this.toggleobject.bootstrapToggle(this.component.value == 1 ? 'on' : 'off');
    }
    }
  },
  'mounted': function() {
    if (this.component.type === 'do' || this.component.type === 'ro') {
      this.toggleobject = $(this.$el.children[0].children[0].children[0]).bootstrapToggle({'size': 'small'});
    }
  },
  'methods': {
    'onclick': function() {
      if (this.component.value == 0) {
        method = 'set';
      } else {
        method = 'reset';
      }
      async_request('GET', this.$root.url + this.component.type + '/' + this.component.id + '/' +  method , [], null,
        r => {
          if (JSON.parse(r).status === 'OK') {
            this.component.value = JSON.parse(r).value;
          }
        },
        r => {
          this.toggleobject.bootstrapToggle(this.component.value == 1 ? 'on' : 'off');
        });
    }
  }
});


Vue.component('analog-toggle', {
  'props': ['disabled', 'component'],
  'data': function() {
    return {
      current_value: '' ,
      barValue: 0,
      is_active: false,
    };
  },
  'template': '<div class="no-side-space space-on-bottom col-md-12 col-xs-12 col-sm-12">\
                <div class="no-side-space col-md-12 col-sm-12 col-xs-12">\
            <div class="no-side-space col-md-2 col-sm-2 col-xs-4">\
                    <span class="label label-default label-analog">{{ component.value }}</span>\
            </div>\
            <div class="no-side-space space-on-top col-md-10 col-sm-10 col-xs-8">\
                    <input class="analog-text" v-model="component.name" v-if="this.$root.checked == true" disabled >\
                    <input class="analog-text" v-model="component.name" v-else>\
            </div>\
                </div>\
                <div class="no-side-space col-md-12 col-sm-12 col-xs-12" v-if="component.type == \'ao\'">\
            <div class="no-side-space space-on-top col-md-9 col-sm-9 col-xs-7">\
                    <input type="range" min="0" step="barValue" max="4095" v-model="barValue" class="no-spinner">\
            </div>\
            <div class="no-side-space col-md-2 col-sm-2 col-xs-3">\
                    <input type="number" class="form-control" min="0" max="4095" v-model="barValue">\
            </div>\
            <div class="no-side-space space-on-top col-md-1 col-sm-1 col-xs-2">\
                    <button  v-on:click="onclick()" type="button" :class="is_active == true ? \'btn-primary\' : \'btn-default\'" :disabled=!is_active>\
                      <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>\
                    </button>\
            </div>\
                </div>\
              </div>',
  'watch': {
    'barValue': function() {
      this.is_active = true
      this.current_value = this.component.value
    }
  },
  'methods': {
    'onclick': function() {
      this.is_active = false;
      if (0 <= parseInt(this.barValue) && parseInt(this.barValue) < 4096) {
        async_request('GET', this.$root.url + this.component.type + '/' + this.component.id + '/' +  'write?val=' + parseInt(this.barValue) , [], null,
          r => {
            if (JSON.parse(r).status === 'OK') {
              this.component.value = JSON.parse(r).value;
            }
          });
        } else {
          alert('Invalid value');
        }
      }
    }
});


Vue.component('page-header', {
  'props': ['datenow', 'counter', 'temp'],
  'template': '<div id="page-header">\
               <div class="col-md-6 col-sm-6 col-xs-12 temp-indicator"> {{ temp }}°C </div>\
               <div class="col-md-6 col-sm-6 col-xs-12 indicator">\
                 <span class="indicator"> {{ datenow }} </span>\
                 <span class="indicator counter-indicator">+ {{ counter }} </span>\
               </div>\
              </div>',
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
    'url': '/api/',
    // 'url': 'http://172.22.9.17/api/',
    'checked': true,
    'interval': null,
    'barValue': 0,
    'counter': 0,
    'mini_bug': 0
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
    this.mini_bug = Math.floor(Math.random() * 10000);
  },
  'methods': {
    'tick': function() {
      this.counter += 1;
      if ( this.counter > 0 && this.counter % this.current_interval == 0 && this.checked == true) {
        this.get_status();
      }
    },
    'datetime': function() {
      var d = new Date();
      this.datenow = d.toLocaleTimeString('en-GB');
    },
    'refresh_onclick': function() {
      this.get_status();
    },
    'reset_onclick': function() {
        var ready = confirm("Do you want to reset all outputs?");
        if (ready == true){
          application = this;
          async_request('GET', this.url + 'reset' , [], null, function(response) {application.get_status();});
        } else {
        }
    },
    'get_status': function() {
      document.getElementById('refresh_button').disabled = true;

      application = this;
      async_request('GET', '/gui/status',  [], null, function (response) {
        if (JSON.parse(response).status === 'OK') {
          status_data = JSON.parse(response);
          application.status = status_data.value ? status_data.value : '';
          application.temperature = status_data.temperature ? status_data.temperature : '';
          application.get_names();
          application.datetime();
          application.counter = 0;
        }
      document.getElementById("refresh_button").disabled = false;
      }, r => { document.getElementById('refresh_button').disabled = false; });

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
    },
    'alert_message_onclick': function() {
      if ( this.mini_bug === 1729) {
      alert('It was working in my computer.');
      }
    }
  }
});


