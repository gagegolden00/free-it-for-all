import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['datepickers', 'form', 'timeFrameSelect'];

  connect() {
    this.timeFrameSelectTarget.addEventListener("change", this.handleSubmit.bind(this));
    const timeFrameValue = this.element.querySelector('[name="time_frame"]').value;
    if (timeFrameValue === "Custom time"){
      this.datepickersTarget.classList.remove("hidden");
      this.datepickersTarget.classList.remove("disabled");
    }
  }

  handleSubmit(event) {
    event.preventDefault();

    const timeFrameValue = this.element.querySelector('[name="time_frame"]').value;
    const startDateValue = this.element.querySelector('[name="start_date"]').value;
    const endDateValue = this.element.querySelector('[name="end_date"]').value;

    console.log("Start Date:", startDateValue);
    console.log("End Date:", endDateValue);

    if (timeFrameValue === "Custom time" && (!startDateValue || !endDateValue)) {
      this.datepickersTarget.classList.remove("hidden");
    } else {
      this.formTarget.submit();
    }
  }


}
