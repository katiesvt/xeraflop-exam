var ko = require('knockout');

// Generate view models
var appModel = {};

appModel.searchModel = require('models/searchModel');

ko.applyBindings(appModel);
