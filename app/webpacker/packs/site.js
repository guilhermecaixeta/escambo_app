import "froala-editor";
import FroalaEditor from "froala-editor";
import "startbootstrap-shop-homepage/src/js/scripts";

window.FroalaEditor = FroalaEditor

on_load(() => {
    document.body.addEventListener('ajax:before', function (event) {
        let spinModalElement = document.querySelector('#app_modal_spin');
        let spinModal = bootstrap.Modal.getOrCreateInstance(spinModalElement, { backdrop: "static", focus: true, keyboard: true });
        spinModal.show();
    }, false)
})

on_request_complete(() => {
      // must wait for at least 0.5s before update the modal otherwise the function hide does not work.
      setTimeout(function () {
        let spinModalElement = document.querySelector('#app_modal_spin');
        let spinModal = bootstrap.Modal.getOrCreateInstance(spinModalElement);
        spinModal.hide();
    }, 500);
})