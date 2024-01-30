import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bitButton", "displayBitValue"];

  connect() {
    console.log("Connecting to ipv4 quiz controller...");
  }

  addBitValue() {

    let current_value = Document.getElementById("totalBitValue").value;
    console.log("performing add bit value should be renamed to calculate bit value...");
    const value1 = parseInt(this.bitButtonTarget.dataset.value1);
    const value2 = this.bitButtonTarget.dataset.value2;

    if (value2 == "add") {
      console.log("adding", value1);
      console.log(current_value + value1);
      current_value = current_value + value1
      console.log("switching to sub");
      this.bitButtonTarget.dataset.value2 = "sub"
      this.displayBitValueTarget.textContent = value1
    }

    if (value2 == "sub") {
      console.log("subtracting", value1)
      console.log(current_value - value1);
      current_value = current_value - value1
      console.log("switching to add");
      this.bitButtonTarget.dataset.value2 = "add"
      this.displayBitValueTarget.textContent = 0
    }
  }


  // changeColor(){

  // }
}

