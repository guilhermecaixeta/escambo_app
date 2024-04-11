import { DataTable } from "simple-datatables.min.js";
import { read } from "@popperjs/core";
import Chart from "chart.js/auto";

// based on this code https://stackoverflow.com/questions/799981/document-ready-equivalent-without-jquery
var onTurboLinksLoad = fn => document.readyState !== 'loading' ?
    fn() :
    document.addEventListener('turbolinks:load', fn);


window.DataTable = DataTable;
window.Chart = Chart;
window.read = read;
window.onTurboLinksLoad = onTurboLinksLoad;

onTurboLinksLoad(() => {
    if (document.getElementById("datatablesSimple")) {
        new DataTable("#datatablesSimple");
    }
});

// Display errors in form when remote: 'true'.
// To see more: https://github.com/turbolinks/turbolinks/issues/85#issuecomment-338784510
// https://stackoverflow.com/questions/57935148/rails-6-form-with-remote-true-and-turbolinks-not-showing-flash-after-redirect
function setErrors(event) {
    var xhr = event.detail[0]
    if ((xhr.getResponseHeader('Content-Type') || '').substring(0, 9) === 'text/html') {
        var referrer = window.location.href
        var snapshot = Turbolinks.Snapshot.wrap(xhr.response)
        Turbolinks.controller.cache.put(referrer, snapshot)
        Turbolinks.visit(referrer, { action: 'restore' })
    }
}

document.addEventListener('ajax:complete', setErrors, false);
