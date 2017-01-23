var ko = require('knockout');
var $ = require('jquery');
var _ = require('lodash');

var searchModel = function() {
  var self = this;
  request = {
    zipCode: ko.observable(),
    maxSpend: ko.observable(50),
    maxRadius: ko.observable(20)
  };

  response = ko.observableArray(),

  apiSearch = function() {
    $.get({
      url: "/api/v1/recommend_products",
      data: self.request,
      success: response,
      dataType: "json"
    });
  };

  // TODO: 2 decimal digit
  formatCurrency = function(numericValue) {
    return "$ " + numericValue.toString();
  }

  // TODO: 2 decimal digit
  formatDistance = function(distanceValue) {
    return distanceValue.toString() + " mi";
  }
};

module.exports = searchModel;
