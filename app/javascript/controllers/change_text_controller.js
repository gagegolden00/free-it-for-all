import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Connected to change-text controller");
  }

  toggleNewServiceJobCustomerButtonText(event) {
    const button = event.currentTarget;
    console.log("toggle text");
    if (button.textContent.includes("Add new customer")) {
      button.textContent = "Select existing customer";
    } else if (button.textContent.includes("Select existing customer")) {
      button.textContent = "Add new customer";
    }
  }
}


