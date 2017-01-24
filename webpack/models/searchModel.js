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

  formatCurrency = function(numericValue) {
    return "$ " + numericValue.toFixed(2);
  }

  formatDistance = function(distanceValue) {
    return distanceValue.toFixed(2) + " mi";
  }

  /**
   * @param {Array} array
   */
  formatTHC = function(array) {
    return (_.sum(array) / array.length).toFixed(2) + "%";
  }

};

module.exports = searchModel;
