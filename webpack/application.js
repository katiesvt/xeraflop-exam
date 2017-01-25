import 'babel-polyfill';

import ko from 'knockout';
import _ from 'lodash';

import SearchModel from 'models/searchModel';

var appModel = {
  searchModel: new SearchModel()
};

ko.applyBindings(appModel);
