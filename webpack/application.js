var ko = require('knockout');
var _ = require('lodash');

// Generate view models
var appModel = {};

appModel.searchModel = require('models/searchModel');

ko.applyBindings(appModel);
