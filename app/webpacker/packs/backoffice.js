require('bootstrap');
require("startbootstrap-sb-admin/scripts");
require("@fortawesome/fontawesome-free/js/all.min.js");

import Chart from 'chart.js/auto';
import { DataTable } from 'simple-datatables.min.js';

document.addEventListener('turbolinks:load', () => {
    if (!document.getElementById('line_chart')) {
        return;
    }

    var ctx = document.getElementById('line_chart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            // labels: JSON.parse(ctx.canvas.dataset.labels),
            labels: ["Jan", "Feb", "Mar"],
            datasets: [{
                // data: JSON.parse(ctx.canvas.dataset.data),
                data: [10, 25, 5]
            }]
        }
    });
});

document.addEventListener('readystatechange', () => {
});

// $(document).ready(function () {
//     new DataTable('#datatablesSimple');
// });