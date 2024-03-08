import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flashes"
export default class extends Controller {
  static values = {
    notification: String,
    type: String,
  }

  connect() {
    Swal.fire({
      icon: this.typeValue,
      title: this.notificationValue,
      showConfirmButton: false,
      timer: 2000
    });
  }
}
