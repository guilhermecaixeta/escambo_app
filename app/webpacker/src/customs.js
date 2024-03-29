import { DataTable } from "simple-datatables.min.js";
import { read } from "@popperjs/core";
import Chart from "chart.js/auto";

// based on this code https://stackoverflow.com/questions/799981/document-ready-equivalent-without-jquery
var on_load = fn => document.readyState !== 'loading' ?
    fn() :
    document.addEventListener('turbolinks:load', fn);

var on_request_complete = fn => on_load(() => {
    document.addEventListener('ajax:complete', function (event) {
        fn(event);
    }, false)
});

window.DataTable = DataTable;
window.Chart = Chart;
window.read = read;
window.on_load = on_load;
window.on_request_complete = on_request_complete;

on_request_complete(() => {
    if (document.getElementById("datatablesSimple")) {
        new DataTable("#datatablesSimple");
    }
});

// Display errors in form when remote: 'true'.
// To see more: https://github.com/turbolinks/turbolinks/issues/85#issuecomment-338784510
// https://stackoverflow.com/questions/57935148/rails-6-form-with-remote-true-and-turbolinks-not-showing-flash-after-redirect
on_request_complete((event) => {
    var xhr = event.detail[0]
    if ((xhr.getResponseHeader('Content-Type') || '').substring(0, 9) === 'text/html') {
        var referrer = window.location.href
        var snapshot = Turbolinks.Snapshot.wrap(xhr.response)
        Turbolinks.controller.cache.put(referrer, snapshot)
        Turbolinks.visit(referrer, { action: 'restore' })
    }
});