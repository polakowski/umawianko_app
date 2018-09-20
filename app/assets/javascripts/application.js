// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

moment.updateLocale('en', {
  week: { dow: 1 }
});

function datetimepicker(selector) {
  $(function() {
    $(selector).datetimepicker({
      sideBySide: true,
      format: 'YYYY-MM-D HH:mm Z',
      stepping: 15,
      icons: {
        up: 'umi umi--chevron-up',
        down: 'umi umi--chevron-down',
        next: 'umi umi--chevron-right',
        previous: 'umi umi--chevron-left'
      }
    });
  });
}
