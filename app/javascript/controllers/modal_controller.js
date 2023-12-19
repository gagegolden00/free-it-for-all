import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modalContainer"];

  connect() {
    console.log("Connecting to modal controller");
  }

  toggleModalVisibility() {
    console.log("Toggling visibility of modal");
    this.modalContainerTarget.classList.toggle("hidden");
  }
}

