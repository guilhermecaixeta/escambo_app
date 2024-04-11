import "froala-editor";
import FroalaEditor from "froala-editor";
import "startbootstrap-shop-homepage/src/js/scripts";

window.FroalaEditor = FroalaEditor

function openSpinModal() {
    let spinModalElement = document.querySelector('#app_modal_spin');
    let spinModal = bootstrap.Modal.getOrCreateInstance(spinModalElement, { backdrop: "static", focus: true, keyboard: true });
    spinModal.show();
}

function closeSpinModal() {
    // must wait for at least 0.5s before update the modal otherwise the function hide does not work.
    let spinModalElement = document.querySelector('#app_modal_spin');
    let spinModal = bootstrap.Modal.getOrCreateInstance(spinModalElement);
    setTimeout(function () {
        spinModal.hide();
    }, 500);
}

onTurboLinksLoad(() => document.body.addEventListener('turbolinks:click', openSpinModal, false));
onTurboLinksLoad(() => document.addEventListener('turbolinks:request-end', closeSpinModal, false));