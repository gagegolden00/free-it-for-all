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
    console.log(this.bitButtonTarget.textContent.trim())
    console.log(this.bitButtonTarget.dataset.value1)
    
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















// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   static targets = ["bitButton", "displayBitValue"];

//   connect() {
//     console.log("Connecting to ipv4 quiz controller...");
//   }

//   addBitValue() {




//     console.log("Performing calculate bit value...");
//     const value1 = parseInt(this.bitButtonTarget.dataset.value1);
//     const operation = this.bitButtonTarget.dataset.operation;

//     let current_value = parseInt(this.displayBitValueTarget.textContent);

//     if (operation === "add") {
//       current_value += value1; // Add the value1 to the current total value
//     } else if (operation === "sub") {
//       current_value -= value1; // Subtract the value1 from the current total value
//     }

//     this.displayBitValueTarget.textContent = current_value; // Update the displayed value
//     this.bitButtonTarget.dataset.operation = operation === "add" ? "sub" : "add"; // Toggle operation
//   }

// }



