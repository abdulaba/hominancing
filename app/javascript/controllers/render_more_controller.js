import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="render-more"
export default class extends Controller {
  connect() {
    console.log("Estoy sirviendo");
  }
}
