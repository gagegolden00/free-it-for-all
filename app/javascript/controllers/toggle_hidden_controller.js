import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Connected to toggle-hidden controller")
  }

  toggle(event) {
    const targetIds = event.currentTarget.dataset.targetId.split(' ');
    targetIds.forEach(id => {
      const element = document.getElementById(id);
      if (element.classList.contains("hidden")) {
        element.classList.remove("hidden");
        element.removeAttribute("disabled");
      } else {
        element.classList.add("hidden");
        element.setAttribute("disabled", "true");
      }
    });
  }
}
