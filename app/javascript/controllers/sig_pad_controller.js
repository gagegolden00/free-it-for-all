import { Controller } from "@hotwired/stimulus";
import SignaturePad from "signature_pad";

// known issues
// 1) not leveragin stimulus and targets for code reuse.
// still work to be done here to fall in line with stimulus conventions.

export default class extends Controller {
  static targets = ["canvas"]

  initialize() {
    console.log("SigPadController initialized");
    this.canvas = this.canvasTarget;
    this.ctx = this.canvas.getContext("2d");

    this.signaturePad = new SignaturePad(this.canvas, {
      minWidth: 0.5,
      maxWidth: 2.5,
      penColor: "rgb(0, 0, 0)"
    });
  }

  connect() {
    console.log("Connecting to sig pad controller...");
    const resizeCanvas = () => {
      const ratio = Math.max(window.devicePixelRatio || 1, 1);
      this.canvas.width = this.canvas.offsetWidth * ratio;
      this.canvas.height = this.canvas.offsetHeight * ratio;
      this.ctx.scale(ratio, ratio);
      this.signaturePad.clear();
    };
    window.addEventListener("resize", resizeCanvas);
    resizeCanvas();
  }

  clearSignature() {
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
  }

  toggleEmployeeSigPadVisibility() {
    const employeeSigPadContainer = document.getElementById("employee-sig-pad-container");
    employeeSigPadContainer.classList.toggle("hidden");
  }

  saveEmployeeSignature() {
    const employeeSignatureField = document.getElementById("employee-signature-field");
    const employeeSignatureForm = document.getElementById("employee-signature-form");

    if (employeeSignatureField) {
      const dataUrl = this.signaturePad.toDataURL();
      employeeSignatureField.value = dataUrl;
      employeeSignatureForm.submit();
    }
  }

  toggleCustomerSigPadVisibility() {
    const customerSigPadContainer = document.getElementById("customer-sig-pad-container");
    customerSigPadContainer.classList.toggle("hidden");
    this.eSignButtonTarget.classList.toggle("hidden");
  }

  saveCustomerSignature() {
    const customerSignatureField = document.getElementById("customer-signature-field");
    const customerSignatureForm = document.getElementById("customer-signature-form");

    if (customerSignatureField) {
      const dataUrl = this.signaturePad.toDataURL();
      customerSignatureField.value = dataUrl;
      customerSignatureForm.submit();
    }
  }

}
