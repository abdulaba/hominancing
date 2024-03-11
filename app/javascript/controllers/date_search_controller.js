import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-search"
export default class extends Controller {
  static targets = ["startDate", "endDate"]

  setMin() {
    this.endDateTarget.setAttribute("min", this.startDateTarget.value)

  }

  setMax() {
    this.startDateTarget.setAttribute("max", this.endDateTarget.value)
  }
}
