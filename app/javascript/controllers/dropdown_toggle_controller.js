import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown-toggle"
export default class extends Controller {
  static targets = ["options"];

  toggle() {
    console.log("Toggle dropdown")
    this.optionsTarget.classList.toggle("hidden");
  }
}
