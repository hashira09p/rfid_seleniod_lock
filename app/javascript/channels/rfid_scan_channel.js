import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer();

consumer.subscriptions.create("RfidScanChannel", {
  received(data) {
    if (data.action === "display_uid" && window.location.pathname === "/cards/new") {
      // Update the placeholder with the UID
      const placeholder = document.getElementById("rfid-uid-placeholder");
      const hiddenInput = document.getElementById("rfid-uid-input");

      var uid = data.uid;

      if(uid){
        placeholder.textContent = uid; // Display the UID
        hiddenInput.value = uid; // Set the hidden input value
      }else{
        placeholder.textContent = "The card is already in use";
      }
    }
  }
});
