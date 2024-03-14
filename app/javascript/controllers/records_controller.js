import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="records"
export default class extends Controller {
  static targets = ["info", "edit", "footer"]

  connect() {
    console.log("Estoy funcionando");
  }

  displayForm() {
    console.log(this.editTarget);
    this.infoTarget.classList.toggle("hide");
    this.infoTarget.classList.toggle("show");
    this.editTarget.classList.toggle("hide");
    this.editTarget.classList.toggle("show");
    this.footerTarget.classList.toggle("hide");
    this.footerTarget.classList.toggle("show");
  }
}
