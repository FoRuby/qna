//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require action_cable
//= require popper
//= require skim
//= require bootstrap-sprockets
//= require cocoon

//= require_tree .

var App = App|| {};
App.cable = ActionCable.createConsumer();
