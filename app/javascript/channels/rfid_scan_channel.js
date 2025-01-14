import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer();

consumer.subscriptions.create("RfidScanChannel", {
  received(data) {
    if (data.action === "display_uid" && window.location.pathname === "/cards/new") {
      // Update the placeholder with the UID
      const placeholder = document.getElementById("rfid-uid-placeholder");
      const hiddenInput = document.getElementById("rfid-uid-input");

      if (placeholder && hiddenInput) {
        placeholder.textContent = data.uid; // Display the UID
        hiddenInput.value = data.uid; // Set the hidden input value
      }
    }
  }
});
