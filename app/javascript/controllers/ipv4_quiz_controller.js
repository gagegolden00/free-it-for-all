import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ipv4-quiz"
export default class extends Controller {
  
  connect() {
    console.log("Connecting to ipv4 quiz controller...");
  }


}
