
// based on this code https://stackoverflow.com/questions/799981/document-ready-equivalent-without-jquery
var on_load = fn => document.readyState !== 'loading' ?
    fn() :
    document.addEventListener('turbolinks:load', fn);

window.on_load = on_load;
