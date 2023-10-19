import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Connected to toggle-hidden controller")
  }

  toggleVisibility(event) {
    const targetIds = event.currentTarget.dataset.targetId.split(' ');
    targetIds.forEach(id => {
      const element = document.getElementById(id);
      if (element.classList.contains("hidden")) {
        element.classList.remove("hidden");
      } else {
        element.classList.add("hidden");
      }
    });
  }

  toggleDisabled(event) {
    const targetIds = event.currentTarget.dataset.targetId.split(' ');
    targetIds.forEach(id => {
      const element = document.getElementById(id);
      if (element.disabled) {
        element.disabled = false;
      } else {
        element.disabled = true;
      }
    });
  }
}
