import { Controller } from "@hotwired/stimulus";
import SignaturePad from "signature_pad";

// known issues
// 1) not leveragin stimulus and targets for code reuse
// 2) can only use employee signature, require a request to refresh, then use the second signature

export default class extends Controller {
  static targets = ["signature"]

  initialize() {
    this.canvas = document.getElementById("canvas");
    this.ctx = this.canvas.getContext("2d");

    this.signaturePad = new SignaturePad(this.canvas, {
      minWidth: 0.5,
      maxWidth: 2.5,
      penColor: "rgb(0, 0, 0)"
    });

    console.log("canvas: " + this.canvas)
    console.log("ctx: " + this.ctx)
    console.log("signature pad: " + this.signaturePad)
  }

  connect() {
    const base64Signature = this.signatureTarget.dataset.signature;
    console.log("BASE64 SIGNATURE: " + base64Signature)
    this.convertBase64ToImage(base64Signature)


    // if no images are loaded
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
    console.log("Called the clear signature function");
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
  }

  toggleEmployeeSigPadVisibility() {
    console.log("Called the ctoggle employee sig pad visibility function");
    const employeeSigPadContainer = document.getElementById("employee-sig-pad-container");
    employeeSigPadContainer.classList.toggle("hidden");
  }

  saveEmployeeSignature() {
    const employeeSignatureField = document.getElementById("employee-signature-field");
    const employeeSignatureForm = document.getElementById("employee-signature-form");
    console.log("called the save employee signature function");
    console.log("Employee Signature Form:", employeeSignatureForm);

    if (employeeSignatureField) {
      const dataUrl = this.signaturePad.toDataURL();
      employeeSignatureField.value = dataUrl;
      console.log("Employee Signature Field Value:", employeeSignatureField.value);
      employeeSignatureForm.submit();
      console.log("Employee Signature Form Submitted");
    }
  }

  toggleCustomerSigPadVisibility() {
    console.log("Toggling customer signature pad visibility");
    const customerSigPadContainer = document.getElementById("customer-sig-pad-container");
    customerSigPadContainer.classList.toggle("hidden");
    this.eSignButtonTarget.classList.toggle("hidden");
  }

  saveCustomerSignature() {
    console.log("Saving customer signature");
    const customerSignatureField = document.getElementById("customer-signature-field");
    const customerSignatureForm = document.getElementById("customer-signature-form");

    console.log("Customer Signature Form:", customerSignatureForm);

    if (customerSignatureField) {
      const dataUrl = this.signaturePad.toDataURL();
      customerSignatureField.value = dataUrl;
      console.log("Customer Signature Field Value:", customerSignatureField.value);
      customerSignatureForm.submit();
      console.log("Customer Signature Form Submitted");
    }
  }

  convertBase64ToImage(base64Data) {
    const imageElement = document.getElementById("signatureImage");

    if (imageElement) {
      imageElement.src = "data:image/png;base64," + base64Data;
    }
  }

}
