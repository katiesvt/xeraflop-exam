import ko from 'knockout';
import $ from 'jquery';
import _ from 'lodash';

export default class SearchModel {
  constructor() {
    this.request = {
      zipCode: ko.observable(),
      maxSpend: ko.observable(50),
      maxRadius: ko.observable(20)
    };

    this.response = ko.observableArray();

    /**
     * Creates a human-readable currency string
     *
     * @param {number} numericValue
     * @returns
     */
    this.formatCurrency = value => "$ " + value.toFixed(2);

    this.formatDistance = value => value.toFixed(2) + " mi";
    /**
     * Averages a `thc_range` array and adds a percent sign
     *
     * @param {Array<number>} array
     * @returns
     */
    this.formatTHC = array => (_.sum(array) / array.length).toFixed(2) + "%";
  }

  /**
   * Send a recommended product request to the Rails backend.
   */
  apiSearch() {
    $.get({
      url: "/api/v1/recommend_products",
      data: this.request,
      success: this.response,
      dataType: "json"
    });
  }
}
