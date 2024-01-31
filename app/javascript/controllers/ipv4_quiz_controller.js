import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["bitButton", "displayBitValue"];

  connect() {
  }

  updateBitValue() {
    const buttonValue = parseInt(this.bitButtonTarget.dataset.value1);
    const operation = this.bitButtonTarget.dataset.value2;
    let currentValueTargetValue = document.getElementById("totalBitValue").textContent.trim();

    this.updateCurrentValue(buttonValue, currentValueTargetValue, operation);
    this.swapOperation(operation, currentValueTargetValue);
    this.toggleColor();
    this.toggleButtonContent();
  }

  toggleColor() {
    const parentDiv = this.bitButtonTarget.parentNode;

    if (parentDiv.classList.contains("bg-lime-400")) {
      parentDiv.classList.remove("bg-lime-400");
      parentDiv.classList.add("bg-red-200");
    } else if (parentDiv.classList.contains("bg-red-200")) {
      parentDiv.classList.remove("bg-red-200");
      parentDiv.classList.add("bg-lime-400");
    }
  }

  toggleButtonContent() {
    if (this.bitButtonTarget.textContent.trim() === "0") {
      this.bitButtonTarget.textContent = this.bitButtonTarget.dataset.value1;
    }
    else if (this.bitButtonTarget.textContent.trim() === this.bitButtonTarget.dataset.value1) {
      this.bitButtonTarget.textContent = "0";
    }
  }

  swapOperation(operation) {
    this.bitButtonTarget.dataset.value2 = operation === "add" ? "sub" : "add";
  }

  updateCurrentValue(buttonValue, currentValueTargetValue, operation) {
    const totalBitValueElement = document.getElementById("totalBitValue");
    const currentValue = parseInt(currentValueTargetValue);
    if (operation === "add") {
      totalBitValueElement.textContent = currentValue + buttonValue;
    } else if (operation === "sub") {
      totalBitValueElement.textContent = currentValue - buttonValue;
    }
  }

}
