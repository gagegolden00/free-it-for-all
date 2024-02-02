import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "octet1", "octet2", "octet3", "octet4", "currentIpv4"];

  connect() {
    console.log("Connecting to ipv4-quiz-answer-check controller...");

    const form = this.formTarget;

    form.addEventListener("submit", (event) => {
      event.preventDefault();

      const octet1String = this.octet1Target.value;
      const octet2String = this.octet2Target.value;
      const octet3String = this.octet3Target.value;
      const octet4String = this.octet4Target.value;

      const ipv4ToCheck = this.currentIpv4Target.textContent;

      const [ipv4Octet1, ipv4Octet2, ipv4Octet3, ipv4Octet4] = ipv4ToCheck.split(".").map(Number);

      const binaryOctet1 = ipv4Octet1.toString(2).padStart(8, "0");
      const binaryOctet2 = ipv4Octet2.toString(2).padStart(8, "0");
      const binaryOctet3 = ipv4Octet3.toString(2).padStart(8, "0");
      const binaryOctet4 = ipv4Octet4.toString(2).padStart(8, "0");

      let allOctetsEqual = true;

      console.log("IPv4 Octets:", binaryOctet1, binaryOctet2, binaryOctet3, binaryOctet4);
      console.log("Input parameters:", octet1String, octet2String, octet3String, octet4String);

      if (octet1String === binaryOctet1) {
        console.log("if 1 is true");
        this.octet1Target.classList.remove('bg-secondary');
        this.octet1Target.classList.remove('bg-red-400');
        this.octet1Target.classList.add('bg-lime-400');
      } else {
        console.log("if 1 is false");
        this.octet1Target.classList.remove('bg-secondary');
        this.octet1Target.classList.remove('bg-lime-400');
        this.octet1Target.classList.add('bg-red-400');
        allOctetsEqual = false;
      }

      if (octet2String === binaryOctet2) {
        console.log("if 1 is true");
        this.octet2Target.classList.remove('bg-secondary');
        this.octet2Target.classList.remove('bg-red-400');
        this.octet2Target.classList.add('bg-lime-400');
      } else {
        console.log("if 1 is false");
        this.octet2Target.classList.remove('bg-secondary');
        this.octet2Target.classList.remove('bg-lime-400');
        this.octet2Target.classList.add('bg-red-400');
        allOctetsEqual = false;
      }
      if (octet3String === binaryOctet3) {
        console.log("if 1 is true");
        this.octet3Target.classList.remove('bg-secondary');
        this.octet3Target.classList.remove('bg-red-400');
        this.octet3Target.classList.add('bg-lime-400');
      } else {
        console.log("if 1 is false");
        this.octet3Target.classList.remove('bg-secondary');
        this.octet3Target.classList.remove('bg-lime-400');
        this.octet3Target.classList.add('bg-red-400');
        allOctetsEqual = false;
      }
      if (octet4String === binaryOctet4) {
        console.log("if 1 is true");
        this.octet4Target.classList.remove('bg-secondary');
        this.octet4Target.classList.remove('bg-red-400');
        this.octet4Target.classList.add('bg-lime-400');
      } else {
        console.log("if 1 is false");
        this.octet4Target.classList.remove('bg-secondary');
        this.octet4Target.classList.remove('bg-lime-400');
        this.octet4Target.classList.add('bg-red-400');
        allOctetsEqual = false;
      }

      if (allOctetsEqual) {
        console.log("All octets are equal. Submitting the form...");
        const form = this.formTarget;
        form.submit(); // Submit the form
      }
    }

    );
  }
}

