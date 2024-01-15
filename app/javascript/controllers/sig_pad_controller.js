import { Controller } from "@hotwired/stimulus";
import SignaturePad from "signature_pad";

export default class extends Controller {
  static targets = ["canvas", "submitButton"];

  initialize() {
    console.log("SigPadController initialized");
    this.hasDrawn = false;

    // Initialize the signature pad
    this.signaturePad = new SignaturePad(this.canvasTarget, {
      minWidth: 0.5,
      maxWidth: 2.5,
      penColor: "rgb(0, 0, 0)"
    });
  }

  connect() {
    console.log("Connecting to sig pad controller...");

    // Adding mousemove event listener to actively check for drawing
    this.canvasTarget.addEventListener('mousemove', this.canvasDrawn.bind(this));

    // Resize canvas on window resize
    window.addEventListener("resize", this.resizeCanvas.bind(this));
    this.resizeCanvas();
  }

  canvasDrawn() {
    // Check if any pixel is drawn on the canvas
    const imageData = this.getCanvasPixelData();
    this.hasDrawn = this.checkIfCanvasDrawn(imageData);

    // You can use this.hasDrawn for further actions
    console.log('Canvas has been drawn:', this.hasDrawn);
    this.enableSubmitIfCanvasDrawn();
  }

  enableSubmitIfCanvasDrawn() {
    if (this.hasDrawn) {
      this.submitButtonTarget.disabled = false;
      this.submitButtonTarget.classList.remove('dark:bg-gray-800');
    }
  }

  resizeCanvas() {
    const ratio = Math.max(window.devicePixelRatio || 1, 1);
    this.canvasTarget.width = this.canvasTarget.offsetWidth * ratio;
    this.canvasTarget.height = this.canvasTarget.offsetHeight * ratio;
    this.signaturePad.clear();
  }

  getCanvasPixelData() {
    // Get the pixel data of the entire canvas
    const ctx = this.canvasTarget.getContext("2d");
    return ctx.getImageData(0, 0, this.canvasTarget.width, this.canvasTarget.height);
  }

  checkIfCanvasDrawn(imageData) {
    // Check if any non-transparent pixel is present
    const data = imageData.data;
    for (let i = 3; i < data.length; i += 4) {
      if (data[i] !== 0) {
        return true; // Pixel is not fully transparent, canvas has been drawn on
      }
    }
    return false; // No non-transparent pixel found, canvas is empty
  }

  clearSignature() {
    const ctx = this.canvasTarget.getContext("2d");
    ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height);
    this.submitButtonTarget.disabled = true;
    this.submitButtonTarget.classList.add("dark:bg-gray-800");
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
    this.submitButtonTarget.classList.toggle("hidden");
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
