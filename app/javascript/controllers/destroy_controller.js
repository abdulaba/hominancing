import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="destroy"
export default class extends Controller {
  static targets = ["del"]

  static values = {
    title: String,
    message: String,
  }

  delete() {

    Swal.fire({
      title: this.titleValue,
      text: this.messageValue,
      showDenyButton: true,
      confirmButtonText: "No Borrar",
      denyButtonText: "Borrar"
    }).then((result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
      } else if (result.isDenied) {
        this.delTarget.click()
      }
    });

  }
}
